import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsString, Min } from 'class-validator';

export class CreateTableDto {
  @ApiProperty({
    description: 'Number of seats available at the table',
    example: 4,
    minimum: 1,
  })
  @IsNumber()
  @Min(1)
  capacity: number;

  @ApiProperty({
    description: 'Unique identifier for the table',
    example: 'T1',
  })
  @IsString()
  tableNumber: string;
}
