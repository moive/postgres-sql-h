

-- Tarea con countryLanguage

-- Crear la tabla de language

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS language_code_seq;


-- Table Definition
CREATE TABLE "public"."language" (
    "code" int4 NOT NULL DEFAULT 	nextval('language_code_seq'::regclass),
    "name" text NOT NULL,
    PRIMARY KEY ("code")
);

-- Crear una columna en countrylanguage
ALTER TABLE countrylanguage
ADD COLUMN languagecode varchar(3);

-- Insert data to language table
INSERT INTO "language"("name")
SELECT DISTINCT language FROM countrylanguage ORDER BY "language" ASC;
SELECT * FROM LANGUAGE;

-- Empezar con el select para confirmar lo que vamos a actualizar
SELECT
  "language",
  (
    SELECT
      code
    FROM
      "language" b
    WHERE
      a."language" = b."name"
  )
FROM
  countrylanguage a;

-- Actualizar todos los registros
UPDATE countrylanguage a
SET
  languagecode = (
    SELECT
      code
    FROM
      "language" b
    WHERE
      a."language" = b."name"
  );

SELECT * FROM countrylanguage;

-- Cambiar tipo de dato en countrylanguage - languagecode por int4
ALTER TABLE countrylanguage
ALTER COLUMN languagecode TYPE int4
USING languagecode::integer;

-- Crear el forening key y constraints de no nulo el language_code
ALTER TABLE countrylanguage
ALTER COLUMN languagecode SET NOT NULL;

ALTER TABLE countrylanguage
ADD CONSTRAINT fk_countrylanguage_language
FOREIGN KEY (languagecode)
REFERENCES language(code);

SELECT * FROM countrylanguage;

-- Revisar lo creado