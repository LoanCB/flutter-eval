import { MigrationInterface, QueryRunner } from 'typeorm';

export class ReservationModule1748264527210 implements MigrationInterface {
  name = 'ReservationModule1748264527210';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
        CREATE TABLE "table" (
            "id" SERIAL NOT NULL,
            "capacity" smallint NOT NULL,
            "table_number" character varying NOT NULL,
            CONSTRAINT "PK_28914b55c485fc2d7a101b1b2a4" PRIMARY KEY ("id")
        )
    `);
    await queryRunner.query(`
        CREATE TABLE "time_slot" (
            "id" SERIAL NOT NULL,
            "start" TIMESTAMP WITH TIME ZONE NOT NULL,
            "end" TIMESTAMP WITH TIME ZONE NOT NULL,
            "available_seats" smallint NOT NULL,
            CONSTRAINT "PK_03f782f8c4af029253f6ad5bacf" PRIMARY KEY ("id")
        )
    `);
    await queryRunner.query(`
        CREATE TYPE "public"."reservation_status_enum" AS ENUM('PENDING', 'CONFIRMED', 'CANCELED')
    `);
    await queryRunner.query(`
        CREATE TABLE "reservation" (
            "id" SERIAL NOT NULL,
            "created_at" TIMESTAMP NOT NULL DEFAULT now(),
            "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
            "name" character varying NOT NULL,
            "phone" character varying NOT NULL,
            "number_of_guests" smallint NOT NULL,
            "reservation_date" TIMESTAMP WITH TIME ZONE NOT NULL,
            "status" "public"."reservation_status_enum" NOT NULL DEFAULT 'PENDING',
            "user_id" integer NOT NULL,
            "table_id" integer,
            "time_slot_id" integer NOT NULL,
            CONSTRAINT "REL_27946d68ea9576710cdb689669" UNIQUE ("time_slot_id"),
            CONSTRAINT "PK_48b1f9922368359ab88e8bfa525" PRIMARY KEY ("id")
        )
    `);
    await queryRunner.query(`
        ALTER TABLE "reservation"
        ADD CONSTRAINT "FK_e219b0a4ff01b85072bfadf3fd7" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
    `);
    await queryRunner.query(`
        ALTER TABLE "reservation"
        ADD CONSTRAINT "FK_d3321fc44e70fd7e803491513d6" FOREIGN KEY ("table_id") REFERENCES "table"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
    `);
    await queryRunner.query(`
        ALTER TABLE "reservation"
        ADD CONSTRAINT "FK_27946d68ea9576710cdb689669c" FOREIGN KEY ("time_slot_id") REFERENCES "time_slot"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
        ALTER TABLE "reservation" DROP CONSTRAINT "FK_27946d68ea9576710cdb689669c"
    `);
    await queryRunner.query(`
        ALTER TABLE "reservation" DROP CONSTRAINT "FK_d3321fc44e70fd7e803491513d6"
    `);
    await queryRunner.query(`
        ALTER TABLE "reservation" DROP CONSTRAINT "FK_e219b0a4ff01b85072bfadf3fd7"
    `);
    await queryRunner.query(`
        DROP TABLE "reservation"
    `);
    await queryRunner.query(`
        DROP TYPE "public"."reservation_status_enum"
    `);
    await queryRunner.query(`
        DROP TABLE "time_slot"
    `);
    await queryRunner.query(`
        DROP TABLE "table"
    `);
  }
}
