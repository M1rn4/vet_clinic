INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
  (1, 'Agumon', '2020-02-03', 0, true, 10.23),
  (2, 'Gabumon', '2018-11-15', 2, true, 8),
  (3, 'Pikachu', '2021-01-07', 1, false, 15.04),
  (4, 'Devimon', '2017-05-12', 5, true, 11);


INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts, species)
VALUES ('Charmander', '2020-02-08', -11, false, 0, 'unspecified'),
       ('Plantmon', '2021-11-15', -5.7, true, 2, 'unspecified'),
       ('Squirtle', '1993-04-02', -12.13, false, 3, 'unspecified'),
       ('Angemon', '2005-06-12', -45, true, 1, 'unspecified'),
       ('Boarmon', '2005-06-07', 20.4, true, 7, 'unspecified'),
       ('Blossom', '1998-10-13', 17, true, 3, 'unspecified'),
       ('Ditto', '2022-05-14', 22, true, 4, 'unspecified');


BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals; -- verificar que se haya hecho el cambio
ROLLBACK;
SELECT * FROM animals; -- verificar que el cambio se haya revertido

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species = 'unspecified';
COMMIT;
SELECT * FROM animals; -- verificar que el cambio se haya hecho y persista después de la transacción

BEGIN TRANSACTION;
DELETE FROM animals;
ROLLBACK;


BEGIN TRANSACTION;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT my_savepoint;
UPDATE animals
SET weight_kg = weight_kg * -1;
ROLLBACK TO my_savepoint;
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight < 0;
COMMIT TRANSACTION;
