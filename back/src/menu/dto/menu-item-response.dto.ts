import { ApiProperty } from '@nestjs/swagger';

export class MenuItemResponseDto {
  @ApiProperty({ description: 'ID of the menu item', example: 1 })
  id: number;

  @ApiProperty({ description: 'Name of the menu item', example: 'Spaghetti Carbonara' })
  name: string;

  @ApiProperty({
    description: 'Description of the menu item',
    example: 'Traditional Italian pasta with eggs, cheese, and pancetta',
  })
  description: string;

  @ApiProperty({ description: 'Price of the menu item in cents', example: 1250 })
  price: number;

  @ApiProperty({
    description: 'Image URL of the menu item',
    example: 'https://example.com/images/spaghetti-carbonara.jpg',
  })
  imageUrl: string;

  @ApiProperty({ description: 'Category of the menu item', example: 'Main Course' })
  category: string;

  @ApiProperty({ description: 'Whether the menu item is available', example: true })
  isAvailable: boolean;

  @ApiProperty({ description: 'Creation date', example: '2025-04-17T08:00:00.303Z' })
  createdAt: Date;

  @ApiProperty({ description: 'Last update date', example: '2025-04-17T10:00:00.303Z' })
  updatedAt: Date;
}
