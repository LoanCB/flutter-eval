import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MenuItem } from '../entities/menu-item.entity';

@Injectable()
export class MenuService {
  constructor(
    @InjectRepository(MenuItem)
    private readonly menuItemRepository: Repository<MenuItem>,
  ) {}

  async findAll(): Promise<MenuItem[]> {
    return this.menuItemRepository.find({
      where: { isAvailable: true },
      order: { category: 'ASC', name: 'ASC' },
    });
  }

  async findByCategory(category: string): Promise<MenuItem[]> {
    return this.menuItemRepository.find({
      where: { category, isAvailable: true },
      order: { name: 'ASC' },
    });
  }

  async findById(id: number): Promise<MenuItem | null> {
    return this.menuItemRepository.findOne({
      where: { id, isAvailable: true },
    });
  }
}
