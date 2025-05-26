import { HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityFilteredListResults, getEntityFilteredList } from '@paginator/paginator.service';
import { LoggedUser } from '@src/auth/types/logged-user.type';
import { Between, Repository } from 'typeorm';
import { AvailableReservationsDto } from '../dto/available-reservations.dto';
import { AvailableTimeSlotDto } from '../dto/available-time-slot.dto';
import { CreateReservationDto } from '../dto/create-reservation.dto';
import { CreateTableDto } from '../dto/create-table.dto';
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

@Injectable()
export class ReservationService {
  constructor(
    @InjectRepository(Reservation)
    private readonly reservationRepository: Repository<Reservation>,
    @InjectRepository(TimeSlot)
    private readonly timeSlotRepository: Repository<TimeSlot>,
    @InjectRepository(Table)
    private readonly tableRepository: Repository<Table>,
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

    return this.reservationRepository.save(reservation);
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
    reservation.status = status;
    return this.reservationRepository.save(reservation);
  }

  async remove(id: number): Promise<void> {
    const reservation = await this.findOne(id);
    await this.reservationRepository.remove(reservation);
  }

  async findAvailableReservations(query: AvailableReservationsDto): Promise<AvailableTimeSlotDto[]> {
    const date = new Date(query.date);
    date.setHours(0, 0, 0, 0);

    // Create time slots for 12:00 and 13:00
    const timeSlots: AvailableTimeSlotDto[] = [];
    const hours = [12, 13];

    // Find all available tables that can accommodate the requested seats
    const availableTables = await this.tableRepository.find({
      where: query.seats ? { capacity: query.seats } : {},
    });

    if (availableTables.length === 0) {
      return [];
    }

    for (const hour of hours) {
      const startTime = new Date(date);
      startTime.setHours(hour, 0, 0, 0);

      const endTime = new Date(startTime);
      endTime.setHours(hour + 1, 0, 0, 0); // 1-hour duration

      // For each table, check availability
      for (const table of availableTables) {
        // Check if there's an existing reservation that overlaps for this table
        const existingReservation = await this.reservationRepository.findOne({
          where: {
            table: { id: table.id },
            timeSlot: {
              start: Between(startTime, endTime),
              end: Between(startTime, endTime),
            },
          },
          relations: ['timeSlot'],
        });

        // If no existing reservation for this table and time slot
        if (!existingReservation) {
          // Create a new time slot with table information
          const timeSlot: AvailableTimeSlotDto = {
            start: startTime,
            end: endTime,
            availableSeats: table.capacity,
            table: table,
          };

          timeSlots.push(timeSlot);
        }
      }
    }

    return timeSlots;
  }

  async createTable(createTableDto: CreateTableDto): Promise<Table> {
    // Check if table number already exists
    const existingTable = await this.tableRepository.findOne({
      where: { tableNumber: createTableDto.tableNumber },
    });

    if (existingTable) {
      throw new ReservationHttpException(ReservationErrorCode.TABLE_ALREADY_EXISTS, HttpStatus.BAD_REQUEST, {
        tableNumber: createTableDto.tableNumber,
      });
    }

    const table = this.tableRepository.create(createTableDto);
    return this.tableRepository.save(table);
  }
}
