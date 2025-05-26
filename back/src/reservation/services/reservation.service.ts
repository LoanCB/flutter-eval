import { HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityFilteredListResults, getEntityFilteredList } from '@paginator/paginator.service';
import { LoggedUser } from '@src/auth/types/logged-user.type';
import { Between, Repository } from 'typeorm';
import { CreateReservationDto } from '../dto/create-reservation.dto';
import { ReservationQueryFilterDto } from '../dto/reservation-query-filter.dto';
import { Reservation } from '../entities/reservation.entity';
import { Table } from '../entities/table.entity';
import { TimeSlot } from '../entities/time-slot.entity';
import {
  ReservationErrorCode,
  ReservationHttpException,
  ReservationNotFoundException,
  TableNotFoundException,
  TimeSlotNotFoundException,
} from '../helpers/exceptions/reservation.exception';
import { ReservationStatus } from '../types/reservation.types';
import { NotificationService } from '../../notification/notification.service';

@Injectable()
export class ReservationService {
  constructor(
    @InjectRepository(Reservation)
    private readonly reservationRepository: Repository<Reservation>,
    @InjectRepository(TimeSlot)
    private readonly timeSlotRepository: Repository<TimeSlot>,
    @InjectRepository(Table)
    private readonly tableRepository: Repository<Table>,
    private readonly notificationService: NotificationService,
  ) {}

  async create(createReservationDto: CreateReservationDto, user: LoggedUser): Promise<Reservation> {
    let timeSlot: TimeSlot | null = null;

    if (createReservationDto.timeSlotId) {
      // If timeSlotId is provided, use existing time slot
      timeSlot = await this.timeSlotRepository.findOne({
        where: { id: createReservationDto.timeSlotId },
        relations: ['reservation'],
      });
      if (!timeSlot) {
        throw new TimeSlotNotFoundException({ id: createReservationDto.timeSlotId });
      }
    } else {
      // Create new time slot
      const startTime = new Date(createReservationDto.reservationDate);
      const endTime = new Date(startTime.getTime() + (createReservationDto.duration || 120) * 60000);

      // Check for existing time slots that overlap
      const existingTimeSlot = await this.timeSlotRepository.findOne({
        where: {
          start: Between(startTime, endTime),
          end: Between(startTime, endTime),
        },
        relations: ['reservation'],
      });

      if (existingTimeSlot && existingTimeSlot.reservation) {
        throw new ReservationHttpException(ReservationErrorCode.TIME_SLOT_ALREADY_RESERVED, HttpStatus.BAD_REQUEST, {
          startTime: startTime.toISOString(),
          endTime: endTime.toISOString(),
        });
      }

      // Find available tables that can accommodate the number of guests
      const availableTables = await this.tableRepository.find({
        where: {
          capacity: createReservationDto.numberOfGuests,
        },
      });

      if (availableTables.length === 0) {
        throw new ReservationHttpException(ReservationErrorCode.NOT_ENOUGH_SEATS, HttpStatus.BAD_REQUEST, {
          requested: createReservationDto.numberOfGuests,
        });
      }

      // Create new time slot
      timeSlot = this.timeSlotRepository.create({
        start: startTime,
        end: endTime,
        availableSeats: createReservationDto.numberOfGuests,
      });

      timeSlot = await this.timeSlotRepository.save(timeSlot);
    }

    if (!timeSlot) {
      throw new ReservationHttpException(ReservationErrorCode.TIME_SLOT_NOT_FOUND, HttpStatus.BAD_REQUEST);
    }

    // Check if time slot is available
    if (timeSlot.reservation) {
      throw new ReservationHttpException(ReservationErrorCode.TIME_SLOT_ALREADY_RESERVED, HttpStatus.BAD_REQUEST, {
        timeSlotId: timeSlot.id,
      });
    }

    // Check if there are enough seats
    if (timeSlot.availableSeats < createReservationDto.numberOfGuests) {
      throw new ReservationHttpException(ReservationErrorCode.NOT_ENOUGH_SEATS, HttpStatus.BAD_REQUEST, {
        requested: createReservationDto.numberOfGuests,
        available: timeSlot.availableSeats,
      });
    }

    // Get table if specified
    let table: Table | null = null;
    if (createReservationDto.tableId) {
      table = await this.tableRepository.findOneBy({ id: createReservationDto.tableId });
      if (!table) {
        throw new TableNotFoundException({ id: createReservationDto.tableId });
      }
    } else {
      // Find a suitable table if not specified
      const availableTables = await this.tableRepository.find({
        where: {
          capacity: createReservationDto.numberOfGuests,
        },
      });
      if (availableTables.length > 0) {
        table = availableTables[0];
      }
    }

    // Create reservation
    const reservation = this.reservationRepository.create({
      ...createReservationDto,
      user,
      timeSlot,
      table,
    });

    const savedReservation = await this.reservationRepository.save(reservation);

    // Envoyer une notification de confirmation
    await this.notificationService.sendReservationConfirmation(savedReservation);

    return savedReservation;
  }

  async findAll(queryFilter: ReservationQueryFilterDto): Promise<EntityFilteredListResults<Reservation>> {
    const [reservations, totalResults] = await getEntityFilteredList({
      repository: this.reservationRepository,
      queryFilter,
      relations: [
        { relation: 'user', alias: 'u' },
        { relation: 'table', alias: 't' },
        { relation: 'timeSlot', alias: 'ts' },
      ],
    });
    return [reservations, reservations.length, totalResults];
  }

  async findOne(id: number): Promise<Reservation> {
    const reservation = await this.reservationRepository.findOne({
      where: { id },
      relations: ['user', 'table', 'timeSlot'],
    });

    if (!reservation) {
      throw new ReservationNotFoundException({ id });
    }

    return reservation;
  }

  async updateStatus(id: number, status: ReservationStatus): Promise<Reservation> {
    const reservation = await this.findOne(id);
    const oldStatus = reservation.status;
    reservation.status = status;
    const updatedReservation = await this.reservationRepository.save(reservation);

    // Envoyer une notification de confirmation si le statut a changé
    if (oldStatus !== status) {
      await this.notificationService.sendReservationConfirmation(updatedReservation);
    }

    return updatedReservation;
  }

  async remove(id: number): Promise<void> {
    const reservation = await this.findOne(id);
    
    // Envoyer une notification d'annulation avant de supprimer la réservation
    await this.notificationService.sendReservationCancellation(reservation);
    
    await this.reservationRepository.remove(reservation);
  }
}
