import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ScheduleModule } from '@nestjs/schedule';
import { NotificationService } from './notification.service';
import { SchedulerService } from './scheduler.service';
import { Reservation } from '../reservation/entities/reservation.entity';

@Module({
  imports: [
    ConfigModule,
    TypeOrmModule.forFeature([Reservation]),
    ScheduleModule.forRoot(),
  ],
  providers: [NotificationService, SchedulerService],
  exports: [NotificationService],
})
export class NotificationModule {} 