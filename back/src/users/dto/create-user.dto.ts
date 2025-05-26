import { ApiProperty, OmitType } from '@nestjs/swagger';
import { Match } from '@src/common/decorators/match-fields.decorator';
import { IsEmail, IsEnum, IsNotEmpty, IsString, IsStrongPassword } from 'class-validator';
import { RoleType } from '../types/role.types';
import { Role } from '../entities/role.entity';

export class CreateUserDto {
  @ApiProperty({ example: 'John' })
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty({ example: 'Doe' })
  @IsString()
  @IsNotEmpty()
  lastName: string;

  @ApiProperty({ example: 'john-doe@example.com' })
  @IsEmail({}, { message: 'Invalid email' })
  @IsNotEmpty({ message: 'Email is required' })
  email: string;

  @ApiProperty({ example: 'azerty123' })
  @IsStrongPassword()
  @IsNotEmpty({ message: 'password is required' })
  password: string;

  @ApiProperty({ example: 'azerty123' })
  @IsNotEmpty({ message: 'confirmPassword is required' })
  @Match('password')
  confirmPassword: string;

  @ApiProperty({ description: 'Role of the user', enum: RoleType, example: RoleType.ADMINISTRATOR })
  @IsEnum(RoleType)
  @IsNotEmpty()
  role: RoleType;
}

export class FormattedCreatedUserDto extends OmitType(CreateUserDto, ['role', 'password', 'confirmPassword']) {
  role: Role | null;
}
