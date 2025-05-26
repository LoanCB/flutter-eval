import { MigrationInterface, QueryRunner } from 'typeorm';

export class UpdateUser1748277080000 implements MigrationInterface {
  name = 'UpdateUser1748277080000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
        ALTER TABLE "reservation" DROP COLUMN "name"
    `);
    await queryRunner.query(`
        ALTER TABLE "reservation" DROP COLUMN "phone"
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
        ALTER TABLE "reservation"
        ADD "phone" character varying NOT NULL
    `);
    await queryRunner.query(`
        ALTER TABLE "reservation"
        ADD "name" character varying NOT NULL
    `);
  }
}
