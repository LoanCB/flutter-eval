import { ApiProperty } from '@nestjs/swagger';
import { TimestampEntity } from '@src/common/entities/timestamp.entity';
import { User } from '@src/users/entities/user.entity';
import { Column, Entity, JoinColumn, ManyToOne, OneToOne, Relation } from 'typeorm';
import { ReservationStatus } from '../types/reservation.types';
import { Table } from './table.entity';
import { TimeSlot } from './time-slot.entity';

@Entity()
export class Reservation extends TimestampEntity {
  @ApiProperty({
    description: 'Number of guests for the reservation',
    example: 4,
    minimum: 1,
  })
  @Column({ type: 'smallint' })
  numberOfGuests: number;

  @ApiProperty({
    description: 'Date of the reservation',
    example: '2024-03-20T19:00:00Z',
  })
  @Column({ type: 'timestamptz' })
  reservationDate: Date;

  @ApiProperty({
    description: 'Current status of the reservation',
    enum: ReservationStatus,
    example: ReservationStatus.PENDING,
    default: ReservationStatus.PENDING,
  })
  @Column({ type: 'enum', enum: ReservationStatus, default: ReservationStatus.PENDING })
  status: ReservationStatus;

  @ApiProperty({
    description: 'User who made the reservation',
    type: () => User,
  })
  @ManyToOne(() => User, (user) => user.reservations, { nullable: false })
  user: Relation<User>;

  @ApiProperty({
    description: 'Assigned table for the reservation',
    type: () => Table,
    nullable: true,
  })
  @ManyToOne(() => Table, (table) => table.reservations)
  table?: Relation<Table> | null;

  @ApiProperty({
    description: 'Time slot for the reservation',
    type: () => TimeSlot,
  })
  @OneToOne(() => TimeSlot, (timeSlot) => timeSlot.reservation, { nullable: false })
  @JoinColumn()
  timeSlot: Relation<TimeSlot>;
}
