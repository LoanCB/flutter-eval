import { ApiProperty } from '@nestjs/swagger';
import { BaseEntity } from '@src/common/entities/base.entity';
import { Column, Entity, OneToMany, Relation } from 'typeorm';
import { Reservation } from './reservation.entity';

@Entity()
export class Table extends BaseEntity {
  @ApiProperty({
    description: 'Number of seats available at the table',
    example: 4,
    minimum: 1,
  })
  @Column({ type: 'smallint' })
  capacity: number;

  @ApiProperty({
    description: 'Unique identifier for the table',
    example: 'T1',
  })
  @Column({ type: 'varchar' })
  tableNumber: string;

  @ApiProperty({
    description: 'Reservations associated with this table',
    type: () => [Reservation],
    nullable: true,
  })
  @OneToMany(() => Reservation, (reservation) => reservation.table)
  reservations?: Relation<Reservation[]> | null;
}
