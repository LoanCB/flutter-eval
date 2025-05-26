import { HttpExceptionOptions, HttpStatus } from '@nestjs/common';
import { CustomHttpException, ErrorDetails } from '@src/common/helpers/error-codes/custom.exception';

export enum ReservationErrorCode {
  NOT_FOUND = 'NOT_FOUND',
  TIME_SLOT_NOT_FOUND = 'TIME_SLOT_NOT_FOUND',
  TABLE_NOT_FOUND = 'TABLE_NOT_FOUND',
  TIME_SLOT_ALREADY_RESERVED = 'TIME_SLOT_ALREADY_RESERVED',
  NOT_ENOUGH_SEATS = 'NOT_ENOUGH_SEATS',
  RESERVATION_FORBIDDEN = 'RESERVATION_FORBIDDEN',
}

export class ReservationHttpException extends CustomHttpException {
  declare readonly code: ReservationErrorCode;

  constructor(code: ReservationErrorCode, status: HttpStatus, details?: ErrorDetails, options?: HttpExceptionOptions) {
    super(code, status, details, options);
  }

  getMessage() {
    const messages: Record<ReservationErrorCode, string> = {
      [ReservationErrorCode.NOT_FOUND]: 'Reservation not found',
      [ReservationErrorCode.TIME_SLOT_NOT_FOUND]: 'Time slot not found',
      [ReservationErrorCode.TABLE_NOT_FOUND]: 'Table not found',
      [ReservationErrorCode.TIME_SLOT_ALREADY_RESERVED]: 'Time slot is already reserved',
      [ReservationErrorCode.NOT_ENOUGH_SEATS]: 'Not enough seats available',
      [ReservationErrorCode.RESERVATION_FORBIDDEN]: "You haven't rights to access to this reservation",
    };

    return messages[this.code] || null;
  }
}

export class ReservationNotFoundException extends ReservationHttpException {
  constructor(details?: Record<string, string | number>) {
    super(ReservationErrorCode.NOT_FOUND, HttpStatus.NOT_FOUND, details);
  }
}

export class TimeSlotNotFoundException extends ReservationHttpException {
  constructor(details?: Record<string, string | number>) {
    super(ReservationErrorCode.TIME_SLOT_NOT_FOUND, HttpStatus.NOT_FOUND, details);
  }
}

export class TableNotFoundException extends ReservationHttpException {
  constructor(details?: Record<string, string | number>) {
    super(ReservationErrorCode.TABLE_NOT_FOUND, HttpStatus.NOT_FOUND, details);
  }
}

export class ReservationForbiddenException extends ReservationHttpException {
  constructor(details?: Record<string, string | number>) {
    super(ReservationErrorCode.RESERVATION_FORBIDDEN, HttpStatus.FORBIDDEN, details);
  }
}
