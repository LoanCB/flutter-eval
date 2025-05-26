import { ApiProperty } from '@nestjs/swagger';
import { TimestampEntity } from '@src/common/entities/timestamp.entity';
import { Column, Entity } from 'typeorm';

@Entity()
export class MenuItem extends TimestampEntity {
  @ApiProperty({ description: 'Name of the menu item', example: 'Spaghetti Carbonara' })
  @Column()
  name: string;

  @ApiProperty({
    description: 'Description of the menu item',
    example: 'Traditional Italian pasta with eggs, cheese, and pancetta',
  })
  @Column('text')
  description: string;

  @ApiProperty({ description: 'Price of the menu item in cents', example: 1250 })
  @Column()
  price: number;

  @ApiProperty({
    description: 'Image URL of the menu item',
    example: 'https://example.com/images/spaghetti-carbonara.jpg',
  })
  @Column()
  imageUrl: string;

  @ApiProperty({ description: 'Category of the menu item', example: 'Main Course' })
  @Column()
  category: string;

  @ApiProperty({ description: 'Whether the menu item is available', example: true })
  @Column({ default: true })
  isAvailable: boolean;
}
