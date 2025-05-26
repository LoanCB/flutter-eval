import { Body, Controller, Get, HttpCode, HttpStatus, Post, Request, UseGuards } from '@nestjs/common';
import { DisableActivityLogger } from '@src/activity-logger/helpers/disable-logger.decorator';
import { Request as ExpressRequest } from 'express';
import { LoginDto } from '../dtos/login.dto';
import { JwtAuthGuard } from '../guards/jwt.guard';
import { UserRequestNotFoundException } from '../helpers/auth.exception';
import { LoggedUser, LoggedUserWithToken } from '../types/logged-user.type';
import { AuthService } from './../services/auth.service';

@Controller({ path: 'auth', version: ['1'] })
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @HttpCode(HttpStatus.OK)
  @Post('login')
  @DisableActivityLogger()
  signIn(@Body() signInDto: LoginDto): Promise<LoggedUserWithToken> {
    return this.authService.singIn(signInDto.email, signInDto.password);
  }

  @Get('profile')
  @UseGuards(JwtAuthGuard)
  getProfile(@Request() req: ExpressRequest): LoggedUser {
    const user = req.user;
    if (!user) throw new UserRequestNotFoundException();
    return user;
  }
}
