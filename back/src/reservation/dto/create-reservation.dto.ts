import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsNotEmpty, IsNumber, IsOptional, IsPhoneNumber, IsString, Min } from 'class-validator';

export class CreateReservationDto {
  @ApiProperty({
    description: 'Name of the person making the reservation',
    example: 'John Doe',
  })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({
    description: 'Contact phone number for the reservation',
    example: '+33 6 05 04 03 02',
  })
  @IsPhoneNumber()
  @IsNotEmpty()
  phone: string;

  @ApiProperty({
    description: 'Number of guests for the reservation',
    example: 4,
    minimum: 1,
  })
  @IsNumber()
  @Min(1)
  numberOfGuests: number;

  @ApiProperty({
    description: 'Date and time of the reservation',
    example: '2024-03-20T19:00:00Z',
  })
  @IsDateString()
  @IsNotEmpty()
  reservationDate: Date;

  @ApiProperty({
    description: 'Duration of the reservation in minutes',
    example: 120,
    default: 120,
  })
  @IsNumber()
  @Min(30)
  @IsOptional()
  duration?: number = 120;

  @ApiProperty({
    description: 'ID of the time slot for the reservation (optional)',
    example: 1,
    required: false,
  })
  @IsNumber()
  @IsOptional()
  timeSlotId?: number;

  @ApiProperty({
    description: 'ID of the table for the reservation',
    example: 1,
    required: false,
  })
  @IsNumber()
  @IsOptional()
  tableId?: number;
}
