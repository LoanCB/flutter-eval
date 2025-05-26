import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsDateString, IsInt, IsNotEmpty, Min } from 'class-validator';

export class CreateReservationWithTimeDto {
  @ApiProperty({
    description: 'ID of the table to reserve',
    example: 1,
  })
  @IsInt()
  @Min(1)
  @Transform(({ value }) => parseInt(value, 10))
  tableId: number;

  @ApiProperty({
    description: 'Start time of the reservation (YYYY-MM-DD HH:mm)',
    example: '2024-03-20 12:00',
  })
  @IsDateString()
  @IsNotEmpty()
  startTime: string;

  @ApiProperty({
    description: 'Number of guests',
    example: 4,
  })
  @IsInt()
  @Min(1)
  @Transform(({ value }) => parseInt(value, 10))
  numberOfGuests: number;
}
