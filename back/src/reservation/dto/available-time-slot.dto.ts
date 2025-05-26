import { ApiProperty } from '@nestjs/swagger';
import { Table } from '../entities/table.entity';

export class AvailableTimeSlotDto {
  @ApiProperty({
    description: 'Start time of the slot',
    example: '2024-03-27T12:00:00.000Z',
  })
  start: Date;

  @ApiProperty({
    description: 'End time of the slot',
    example: '2024-03-27T13:00:00.000Z',
  })
  end: Date;

  @ApiProperty({
    description: 'Number of available seats',
    example: 4,
  })
  availableSeats: number;

  @ApiProperty({
    description: 'Table information',
    type: () => Table,
  })
  table: Table;
}
