import { Controller, Get, Param, ParseIntPipe, Query, Version } from '@nestjs/common';
import { ApiOperation, ApiParam, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { MenuItemResponseDto } from '../dto/menu-item-response.dto';
import { MenuService } from '../services/menu.service';

@ApiTags('Menu')
@Controller('menu')
export class MenuController {
  constructor(private readonly menuService: MenuService) {}

  @Get()
  @Version('1')
  @ApiOperation({ summary: 'Get all menu items' })
  @ApiQuery({ name: 'category', required: false, description: 'Filter by category' })
  @ApiResponse({
    status: 200,
    description: 'List of menu items retrieved successfully',
    type: [MenuItemResponseDto],
  })
  async getMenuItems(@Query('category') category?: string): Promise<MenuItemResponseDto[]> {
    if (category) {
      return this.menuService.findByCategory(category);
    }
    return this.menuService.findAll();
  }

  @Get(':id')
  @Version('1')
  @ApiOperation({ summary: 'Get a specific menu item by ID' })
  @ApiParam({ name: 'id', description: 'Menu item ID' })
  @ApiResponse({
    status: 200,
    description: 'Menu item retrieved successfully',
    type: MenuItemResponseDto,
  })
  @ApiResponse({
    status: 404,
    description: 'Menu item not found',
  })
  async getMenuItem(@Param('id', ParseIntPipe) id: number): Promise<MenuItemResponseDto | null> {
    return this.menuService.findById(id);
  }
}
