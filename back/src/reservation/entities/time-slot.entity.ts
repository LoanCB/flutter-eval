import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@src/common/entities/base.entity';
import { Column, Entity, OneToOne, Relation } from 'typeorm';
import { Reservation } from './reservation.entity';

@Entity()
export class TimeSlot extends BaseEntity {
  @ApiProperty({
    description: 'Start time of the reservation slot',
    example: '2024-03-20T19:00:00Z',
  })
  @Column({ type: 'timestamptz' })
  start: Date;

  @ApiProperty({
    description: 'End time of the reservation slot',
    example: '2024-03-20T20:00:00Z',
  })
  @Column({ type: 'timestamptz' })
  end: Date;

  @Column({ type: 'smallint' })
  availableSeats: number;

  @ApiProperty({
    description: 'Associated reservation',
    type: () => Reservation,
    nullable: true,
  })
  @OneToOne(() => Reservation, (reservation) => reservation.timeSlot)
  reservation?: Relation<Reservation> | null;
}
