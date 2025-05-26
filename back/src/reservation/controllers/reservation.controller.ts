import { Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { ActivityLogger } from '@src/activity-logger/helpers/activity-logger.decorator';
import { Resources } from '@src/activity-logger/types/resource.types';
import { Roles } from '@src/auth/decorators/role.decorator';
import { GetUser } from '@src/auth/decorators/user.decorator';
import { JwtAuthGuard } from '@src/auth/guards/jwt.guard';
import { RolesGuard } from '@src/auth/guards/role.guard';
import { LoggedUser } from '@src/auth/types/logged-user.type';
import { SwaggerFailureResponse } from '@src/common/helpers/common-set-decorators.helper';
import { PaginatedList } from '@src/paginator/paginator.type';
import { RoleType } from '@src/users/types/role.types';
import { AvailableReservationsDto } from '../dto/available-reservations.dto';
import { AvailableTimeSlotDto } from '../dto/available-time-slot.dto';
import { CreateReservationWithTimeDto } from '../dto/create-reservation-with-time.dto';
import { CreateReservationDto } from '../dto/create-reservation.dto';
import { CreateTableDto } from '../dto/create-table.dto';
import { ReservationQueryFilterDto } from '../dto/reservation-query-filter.dto';
import { Reservation } from '../entities/reservation.entity';
import { Table } from '../entities/table.entity';
import { ReservationForbiddenException } from '../helpers/exceptions/reservation.exception';
import { ReservationService } from '../services/reservation.service';
import { ReservationStatus } from '../types/reservation.types';

@ApiTags(Resources.RESERVATION)
@SwaggerFailureResponse()
@UseGuards(RolesGuard)
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
@Controller({ path: 'reservations', version: ['1'] })
export class ReservationController {
  constructor(private readonly reservationService: ReservationService) {}

  @Post('tables')
  @Roles(RoleType.HOST)
  @ActivityLogger({ description: 'Create a new table' })
  async createTable(@Body() createTableDto: CreateTableDto): Promise<Table> {
    return this.reservationService.createTable(createTableDto);
  }

  @Post()
  @Roles(RoleType.CUSTOMER)
  @ActivityLogger({ description: 'Create a new reservation' })
  async create(@Body() createReservationDto: CreateReservationDto, @GetUser() user: LoggedUser): Promise<Reservation> {
    return this.reservationService.create(createReservationDto, user);
  }

  @Post('with-time')
  @ApiOperation({ summary: 'Create a new reservation with specific table and time' })
  @ApiResponse({
    status: 201,
    description: 'The reservation has been successfully created.',
    type: Reservation,
  })
  @ApiResponse({ status: 400, description: 'Bad request.' })
  @ApiResponse({ status: 401, description: 'Unauthorized.' })
  @ApiResponse({ status: 404, description: 'Table not found.' })
  @UseGuards(JwtAuthGuard)
  @Roles(RoleType.CUSTOMER)
  createWithTime(
    @Body() createReservationDto: CreateReservationWithTimeDto,
    @GetUser() user: LoggedUser,
  ): Promise<Reservation> {
    return this.reservationService.createWithTime(createReservationDto, user);
  }

  @Get('my-reservations')
  @ApiOperation({ summary: 'Get all reservations for the connected user' })
  @ApiResponse({
    status: 200,
    description: 'Returns a list of reservations for the connected user',
    type: [Reservation],
  })
  @ApiResponse({ status: 401, description: 'Unauthorized.' })
  @UseGuards(JwtAuthGuard)
  @Roles(RoleType.CUSTOMER)
  @ActivityLogger({ description: 'Get user reservations' })
  async findMyReservations(@GetUser() user: LoggedUser): Promise<Reservation[]> {
    return await this.reservationService.findByUser(user.id);
  }

  @Get()
  @Roles(RoleType.ADMINISTRATOR, RoleType.HOST)
  @ActivityLogger({ description: 'Get all reservations' })
  async findAll(@Query() queryFilter: ReservationQueryFilterDto): Promise<PaginatedList<Reservation>> {
    const [reservations, total] = await this.reservationService.findAll(queryFilter);
    return {
      ...queryFilter,
      results: reservations,
      totalResults: total,
      currentResults: reservations.length,
    };
  }

  @Get('available')
  @Roles(RoleType.CUSTOMER)
  @ActivityLogger({ description: 'Get available reservations' })
  async findAvailable(@Query() query: AvailableReservationsDto): Promise<AvailableTimeSlotDto[]> {
    return this.reservationService.findAvailableReservations(query);
  }

  @Get(':id')
  @Roles(RoleType.CUSTOMER)
  @ActivityLogger({ description: 'Get a reservation by id' })
  async findOne(@Param('id', ParseIntPipe) id: number, @GetUser() user: LoggedUser): Promise<Reservation> {
    const reservation = await this.reservationService.findOne(id);
    if (user.role.type === RoleType.CUSTOMER && reservation.user.id !== user.id) {
      throw new ReservationForbiddenException({ id: reservation.id });
    }

    return reservation;
  }

  @Patch(':id/status')
  @Roles(RoleType.ADMINISTRATOR, RoleType.HOST)
  @ActivityLogger({ description: 'Update reservation status' })
  async updateStatus(
    @Param('id', ParseIntPipe) id: number,
    @Body('status') status: ReservationStatus,
  ): Promise<Reservation> {
    return this.reservationService.updateStatus(id, status);
  }

  @Delete(':id')
  @Roles(RoleType.ADMINISTRATOR, RoleType.HOST)
  @ActivityLogger({ description: 'Delete a reservation' })
  async remove(@Param('id', ParseIntPipe) id: number): Promise<void> {
    return this.reservationService.remove(id);
  }
}
