CREATE TYPE request_status_enum  AS ENUM (
 'DECLINED',
 'ON_CHECKING',
 'IN_PROGRESS',
 'ACCEPTED'
);

CREATE TYPE sex_enum AS ENUM (
 'MEN',
 'WOMEN'
);

CREATE TYPE location_enum AS ENUM (
 'EARTH',
 'MARS'
);

CREATE TABLE IF NOT EXISTS company_specialisation (
  company_specialisation_id serial PRIMARY KEY,
  company_specialisation_name VARCHAR(100) NOT NULL,
  CONSTRAINT unique_company_specialisation_name UNIQUE (company_specialisation_name)
);

CREATE TABLE IF NOT EXISTS science_lab (
  science_lab_id serial PRIMARY KEY,
  sector VARCHAR(255) NOT NULL,
  CONSTRAINT unique_science_lab_sector UNIQUE (sector)
);

CREATE TABLE IF NOT EXISTS lab_request (
  staff_request_id serial PRIMARY KEY,
  science_lab_id INT NOT NULL,
  CONSTRAINT fk_lab_request_science_lab FOREIGN KEY (science_lab_id) REFERENCES science_lab(science_lab_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS company_request (
  company_request_id serial PRIMARY KEY,
  status request_status_enum NOT NULL
);

CREATE TABLE IF NOT EXISTS company (
  company_id serial PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  company_specialisation_id INT NOT NULL,
  CONSTRAINT fk_company_company_specialisation FOREIGN KEY (company_specialisation_id) REFERENCES company_specialisation(company_specialisation_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS fabric_texture (
  fabric_texture_id serial PRIMARY KEY,
  fabric_texture_name VARCHAR(100) NOT NULL,
  CONSTRAINT unique_fabric_texture_name UNIQUE (fabric_texture_name)
);

CREATE TABLE IF NOT EXISTS user_spacesuit_data (
  user_spacesuit_data_id serial PRIMARY KEY,
  head INT NOT NULL CHECK (head > 0),
  chest INT NOT NULL CHECK (chest > 0),
  waist INT NOT NULL CHECK (waist > 0),
  hips INT NOT NULL CHECK (hips > 0),
  foot_size INT NOT NULL CHECK (foot_size > 0),
  height INT NOT NULL CHECK (height > 0 AND height <= 300),
  fabric_texture_id INT NOT NULL,
  CONSTRAINT fk_user_spacesuit_data_fabric_texture FOREIGN KEY (fabric_texture_id) REFERENCES fabric_texture(fabric_texture_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS user_request (
  user_request_id serial PRIMARY KEY,
  user_spacesuit_data_id INT NOT NULL,
  CONSTRAINT fk_user_request_user_spacesuit_data FOREIGN KEY (user_spacesuit_data_id) REFERENCES user_spacesuit_data(user_spacesuit_data_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS staff_request (
  staff_request_id serial PRIMARY KEY,
  status request_status_enum NOT NULL,
  name VARCHAR(100) NOT NULL,
  user_request_id INT,
  CONSTRAINT fk_staff_request_user_request FOREIGN KEY (user_request_id) REFERENCES user_request(user_request_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS staff (
  staff_id serial PRIMARY KEY,
  specialisation VARCHAR(255) NOT NULL
);




CREATE TABLE IF NOT EXISTS user_data (
  user_data_id serial PRIMARY KEY,
  age INT NOT NULL CHECK (age >= 18),
  sex sex_enum NOT NULL,
  weight INT NOT NULL CHECK (weight > 0),
  height INT NOT NULL CHECK (height > 0 AND height <= 300),
  hair_color VARCHAR(255) NOT NULL,
  location location_enum NOT NULL CHECK (location IN ('EARTH', 'MARS'))
);

CREATE TABLE IF NOT EXISTS users (
  user_id serial PRIMARY KEY,
  user_spacesuit_data_id INT NOT NULL,
  user_data_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  CONSTRAINT fk_user_user_spacesuit_data FOREIGN KEY (user_spacesuit_data_id) REFERENCES user_spacesuit_data(user_spacesuit_data_id) ON DELETE CASCADE,
  CONSTRAINT fk_user_user_data FOREIGN KEY (user_data_id) REFERENCES user_data(user_data_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS additional_char (
  user_id INT NOT NULL,
  user_data_id INT NOT NULL,
  value_name VARCHAR(255) NOT NULL,
  value VARCHAR(255) NOT NULL,
  CONSTRAINT fk_additional_char_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  CONSTRAINT fk_additional_char_user_data FOREIGN KEY (user_data_id) REFERENCES user_data(user_data_id) ON DELETE CASCADE,
  CONSTRAINT unique_additional_char UNIQUE (user_id, user_data_id, value_name)
);


