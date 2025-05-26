import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ReservationController } from './controllers/reservation.controller';
import { Reservation } from './entities/reservation.entity';
import { Table } from './entities/table.entity';
import { TimeSlot } from './entities/time-slot.entity';
import { ReservationService } from './services/reservation.service';

@Module({
  imports: [TypeOrmModule.forFeature([Reservation, TimeSlot, Table])],
  controllers: [ReservationController],
  providers: [ReservationService],
  exports: [ReservationService],
})
export class ReservationModule {}
