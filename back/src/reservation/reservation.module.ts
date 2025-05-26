import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Table } from 'typeorm';
import { Reservation } from './entities/reservation.entity';
import { TimeSlot } from './entities/time-slot.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Reservation, Table, TimeSlot])],
})
export class ReservationModule {}
