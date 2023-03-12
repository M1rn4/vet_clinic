/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  date_of_birth DATE,
  escape_attempts INT,
  neutered BOOLEAN,
  weight_kg DECIMAL
);

ALTER TABLE animals ADD species VARCHAR(100);

CREATE TABLE owners (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT,
  age INTEGER
);

CREATE TABLE species (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT
);

ALTER TABLE animals
ADD COLUMN species_id INTEGER,
ADD COLUMN owner_id INTEGER;

CREATE TABLE vets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    age INTEGER,
    date_of_graduation DATE
);

CREATE TABLE specializations (
  vet_id INTEGER REFERENCES vets(id),
  species_id INTEGER REFERENCES species(id),
  PRIMARY KEY (vet_id, species_id)
);

CREATE TABLE visits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  animal_id INTEGER NOT NULL,
  vet_id INTEGER NOT NULL,
  visit_date DATE,
  FOREIGN KEY (animal_id) REFERENCES animals(id),
  FOREIGN KEY (vet_id) REFERENCES vets(id)
);