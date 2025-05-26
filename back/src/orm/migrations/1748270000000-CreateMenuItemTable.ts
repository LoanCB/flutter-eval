import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateMenuItemTable1748270000000 implements MigrationInterface {
  name = 'CreateMenuItemTable1748270000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "menu_item" (
        "id" SERIAL NOT NULL,
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
        "name" character varying NOT NULL,
        "description" text NOT NULL,
        "price" integer NOT NULL,
        "image_url" character varying NOT NULL,
        "category" character varying NOT NULL,
        "is_available" boolean NOT NULL DEFAULT true,
        CONSTRAINT "PK_c3ac1c33365213a052a0bd0df5b" PRIMARY KEY ("id")
      )
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "menu_item"`);
  }
}
