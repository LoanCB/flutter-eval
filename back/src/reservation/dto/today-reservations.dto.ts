import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional } from 'class-validator';
import { ReservationStatus } from '../types/reservation.types';

export class TodayReservationsDto {
  @ApiPropertyOptional({
    description: 'Filter by reservation status',
    enum: ReservationStatus,
  })
  @IsEnum(ReservationStatus)
  @IsOptional()
  status?: ReservationStatus;
}
