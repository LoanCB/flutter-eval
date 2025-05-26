import { MigrationInterface, QueryRunner } from 'typeorm';

export class SeedCleanMenuItems1748270002000 implements MigrationInterface {
  name = 'SeedCleanMenuItems1748270002000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      INSERT INTO "menu_item" ("name", "description", "price", "image_url", "category", "is_available", "created_at", "updated_at") VALUES
      ('Spaghetti Carbonara', 'Pâtes traditionnelles italiennes aux œufs, fromage et pancetta', 1450, 'https://images.unsplash.com/photo-1551892589-865f69869476?w=500', 'Plats principaux', true, now(), now()),
      ('Pizza Margherita', 'Pizza classique avec tomate, mozzarella et basilic frais', 1250, 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500', 'Plats principaux', true, now(), now()),
      ('Salade César', 'Salade romaine, croûtons, parmesan et sauce César', 950, 'https://images.unsplash.com/photo-1551248429-40975aa4de74?w=500', 'Entrées', true, now(), now()),
      ('Soupe de tomates', 'Soupe de tomates fraîches avec basilic et crème', 650, 'https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500', 'Entrées', true, now(), now()),
      ('Risotto aux champignons', 'Risotto crémeux aux champignons porcini', 1350, 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=500', 'Plats principaux', true, now(), now()),
      ('Tiramisu', 'Dessert italien traditionnel au café et mascarpone', 750, 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=500', 'Desserts', true, now(), now()),
      ('Panna Cotta', 'Dessert italien à la vanille avec coulis de fruits rouges', 650, 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500', 'Desserts', true, now(), now()),
      ('Bruschetta', 'Pain grillé avec tomates, ail et basilic', 550, 'https://images.unsplash.com/photo-1572441713132-51c75654db73?w=500', 'Entrées', true, now(), now()),
      ('Lasagnes', 'Lasagnes traditionnelles à la bolognaise', 1550, 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=500', 'Plats principaux', true, now(), now()),
      ('Gelato Vanille', 'Glace artisanale à la vanille', 450, 'https://images.unsplash.com/photo-1567206563064-6f60f40a2b57?w=500', 'Desserts', true, now(), now()),
      ('Carpaccio de bœuf', 'Fines lamelles de bœuf avec roquette et parmesan', 1100, 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500', 'Entrées', true, now(), now()),
      ('Escalope Milanaise', 'Escalope de veau panée à la milanaise avec spaghetti', 1650, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500', 'Plats principaux', true, now(), now())
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DELETE FROM "menu_item"`);
  }
}
