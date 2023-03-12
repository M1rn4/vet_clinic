/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2017-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name='Agumon' OR name='Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 and weight_kg <= 17.4;

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
SELECT * FROM animals;
UPDATE animals SET species = 'pokemon' WHERE NOT name LIKE '%mon';
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT del_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals;
ROLLBACK TO SAVEPOINT del_savepoint;
SELECT * FROM animals;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MAX(weight_kg), MIN(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01'and '2000-12-31' GROUP BY species;

-- 1. ¿Qué animales pertenecen a Melody Pond?
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- 2. Lista de todos los animales que son Pokemon.
SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- 3. Lista de todos los propietarios y sus animales, incluyendo aquellos que no tienen animales.
SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

-- 4. ¿Cuántos animales hay por especie?
SELECT species.name, COUNT(animals.id) AS num_animals
FROM species
LEFT JOIN animals ON species.id = animals.species_id
GROUP BY species.name;

-- 5. Lista de todos los Digimon propiedad de Jennifer Orwell.
SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
JOIN owners ON animals.owner_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

-- 6. Lista de todos los animales propiedad de Dean Winchester que no han intentado escapar.
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
LEFT JOIN escapes ON animals.id = escapes.animal_id
WHERE owners.full_name = 'Dean Winchester' AND escapes.animal_id IS NULL;

-- 7. ¿Quién tiene la mayoría de los animales?
SELECT owners.full_name, COUNT(animals.id) AS num_animals
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name
ORDER BY num_animals DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT * FROM visits
WHERE vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher' ORDER BY id DESC LIMIT 1)
ORDER BY date_of_visit DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animal_id) FROM visits
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');

--List all vets and their specialties, including vets with no specialties.
SELECT vets.*, specialties.name AS specialty
FROM vets LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species AS specialties ON specializations.species_id = specialties.id;

--List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.*
FROM visits INNER JOIN animals ON visits.animal_id = animals.id
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez')
AND date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

--What animal has the most visits to vets?
SELECT animals.*, COUNT(*) as visit_count
FROM visits INNER JOIN animals ON visits.animal_id = animals.id
GROUP BY animals.id
ORDER BY visit_count DESC LIMIT 1;

--Who was Maisy Smith's first visit?
SELECT vets.*, visits.date_of_visit
FROM visits INNER JOIN vets ON visits.vet_id = vets.id
WHERE animal_id = (SELECT id FROM animals WHERE name = 'Pikachu' ORDER BY id LIMIT 1)
AND vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith' ORDER BY id LIMIT 1)
ORDER BY visits.date_of_visit ASC LIMIT 1;

--Details for most recent visit: animal information, vet information, aSELECT animals.*, vets.*, visits.date_of_visit
FROM visits INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
ORDER BY visits.date_of_visit DESC LIMIT 1;
--How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*)
FROM visits INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN specializations ON vets.id = specializations.vet_id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE specializations.species_id != animals.species_id;
--What specialty should Maisy Smith consider getting? Look for the species she gets the most. 
SELECT species.name, COUNT(*) as visit_count
FROM visits INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN specializations ON animals.species_id = specializations.species_id
INNER JOIN species ON specializations.species_id = species.id
WHERE visits.vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith' ORDER BY id LIMIT 1)
GROUP BY species.id
ORDER BY visit_count DESC LIMIT 1;


