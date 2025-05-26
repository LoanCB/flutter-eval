import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsDateString, IsNumber, IsOptional, Min } from 'class-validator';

export class AvailableReservationsDto {
  @ApiProperty({
    description: 'Date to check for available reservations',
    example: '2024-03-20',
  })
  @IsDateString()
  date: string;

  @ApiProperty({
    description: 'Number of seats required',
    example: 4,
    required: false,
  })
  @IsOptional()
  @Transform(({ value }) => (value ? parseInt(value, 10) : undefined))
  @IsNumber()
  @Min(1)
  seats?: number;
}
