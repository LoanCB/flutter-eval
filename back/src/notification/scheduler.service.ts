import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThanOrEqual, MoreThanOrEqual } from 'typeorm';
import { Reservation } from '../reservation/entities/reservation.entity';
import { NotificationService } from './notification.service';

@Injectable()
export class SchedulerService implements OnModuleInit {
  private readonly logger = new Logger(SchedulerService.name);

  constructor(
    @InjectRepository(Reservation)
    private readonly reservationRepository: Repository<Reservation>,
    private readonly notificationService: NotificationService,
  ) {}

  onModuleInit() {
    this.logger.log('Scheduler service initialized');
  }

  @Cron(CronExpression.EVERY_DAY_AT_9AM)
  async sendReservationReminders() {
    this.logger.log('Sending reservation reminders...');

    try {
      // Récupérer toutes les réservations pour demain
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      tomorrow.setHours(0, 0, 0, 0);

      const dayAfterTomorrow = new Date(tomorrow);
      dayAfterTomorrow.setDate(dayAfterTomorrow.getDate() + 1);

      const reservations = await this.reservationRepository.find({
        where: {
          timeSlot: {
            start: MoreThanOrEqual(tomorrow),
            end: LessThanOrEqual(dayAfterTomorrow),
          },
          status: 'confirmed',
        },
        relations: ['user', 'timeSlot'],
      });

      this.logger.log(`Found ${reservations.length} reservations for tomorrow`);

      // Envoyer un rappel pour chaque réservation
      for (const reservation of reservations) {
        try {
          await this.notificationService.sendReservationReminder(reservation);
          this.logger.log(`Reminder sent for reservation ${reservation.id}`);
        } catch (error) {
          this.logger.error(`Failed to send reminder for reservation ${reservation.id}:`, error);
        }
      }
    } catch (error) {
      this.logger.error('Failed to send reservation reminders:', error);
    }
  }
} 