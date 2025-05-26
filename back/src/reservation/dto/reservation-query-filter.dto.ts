import { ApiPropertyOptional } from '@nestjs/swagger';
import { PaginationParamsDto } from '@paginator/paginator.dto';
import { IsEnum, IsOptional } from 'class-validator';
import { ReservationStatus } from '../types/reservation.types';

enum ReservationEntityFields {
  ID = 'id',
  NAME = 'name',
  PHONE = 'phone',
  NUMBER_OF_GUESTS = 'numberOfGuests',
  RESERVATION_DATE = 'reservationDate',
  STATUS = 'status',
  CREATED_AT = 'createdAt',
  UPDATED_AT = 'updatedAt',
}

export class ReservationQueryFilterDto extends PaginationParamsDto {
  @ApiPropertyOptional({
    example: ReservationEntityFields.RESERVATION_DATE,
    description: 'Name of the column to sort',
    default: ReservationEntityFields.CREATED_AT,
    enum: ReservationEntityFields,
  })
  @IsEnum(ReservationEntityFields)
  @IsOptional()
  sortField: string = ReservationEntityFields.CREATED_AT;

  @ApiPropertyOptional({
    description: 'Filter by reservation status',
    enum: ReservationStatus,
  })
  @IsEnum(ReservationStatus)
  @IsOptional()
  status?: ReservationStatus;
}
