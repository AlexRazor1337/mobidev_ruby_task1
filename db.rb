require 'pg'

conn = PG.connect(dbname: 'task1', user: 'ruby')
conn.exec('DROP TABLE fixtures;
    DROP TABLE materials;
    DROP TABLE rooms;
    DROP TABLE offices;

    DROP TYPE fixture_type;
    DROP TYPE material_type;
    DROP TYPE office_type;
    DROP TYPE zone_type;
')
conn.exec('CREATE TYPE "office_type" AS ENUM (
        \'Office\',
        \'ATM\'
    );
    
    CREATE TYPE "zone_type" AS ENUM (
        \'Staff\',
        \'Lobby\',
        \'Private\',
        \'Exterrior\',
        \'Safe\'
    );
    
    CREATE TYPE "fixture_type" AS ENUM (
        \'Standingd_desk\',
        \'Door\',
        \'Window\',
        \'Wall_poster\',
        \'Table\',
        \'ATM_Wall\',
        \'Flag\'
    );
    
    CREATE TYPE "material_type" AS ENUM (
        \'Brochure\',
        \'Poster\',
        \'Sticker\',
        \'Print\',
        \'Flag\'
    );
    
    CREATE TABLE "offices" (
        "id" SERIAL UNIQUE,
        "title" varchar NOT NULL,
        "address" varchar NOT NULL,
        "city" varchar NOT NULL,
        "state" varchar NOT NULL,
        "phone" varchar NOT NULL,
        "lob" varchar NOT NULL,
        "type" office_type NOT NULL,
        PRIMARY KEY ("title", "address")
    );
    
    CREATE TABLE "rooms" (
        "id" SERIAL PRIMARY KEY,
        "office_id" int NOT NULL,
        "zone" zone_type NOT NULL,
        "name" varchar NOT NULL,
        "area" int NOT NULL,
        "max_people" int NOT NULL
    );
    
    CREATE TABLE "fixtures" (
        "id" SERIAL PRIMARY KEY,
        "room_id" int NOT NULL,
        "name" varchar NOT NULL,
        "material_id" int NOT NULL,
        "type" fixture_type NOT NULL
    );
    
    CREATE TABLE "materials" (
        "id" SERIAL PRIMARY KEY,
        "name" varchar NOT NULL,
        "cost" int NOT NULL,
        "type" material_type NOT NULL
    );
    
    ALTER TABLE "rooms" ADD FOREIGN KEY ("office_id") REFERENCES "offices" ("id");
    
    ALTER TABLE "fixtures" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("id");
    
    ALTER TABLE "fixtures" ADD FOREIGN KEY ("material_id") REFERENCES "materials" ("id");
')
