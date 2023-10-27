CREATE TYPE request_status_enum AS ENUM (
 'DECLINED',
 'ON_CHEKING',
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
CREATE TABLE IF NOT EXISTS company_ specialisation(
  company_specialisation_id INT PRIMARY KEY,
  company_specialisation_name VARCHAR(100)
);
CREATE TABLE IF NOT EXISTS science_lab(
  science_lab_id INT PRIMARY KEY,
  sector VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS lab_request(
  staff_request_id INT,
  science_lab_id INT
);
CREATE TABLE IF NOT EXISTS company_request(
  company_request_id INT PRIMARY KEY ,
  status “request_status”
);
CREATE TABLE IF NOT EXISTS company(
  company_id INT PRIMARY KEY ,
  name VARCHAR(255),
  company_specialisation_id INT
);
CREATE TABLE IF NOT EXISTS staff_request(
  staff_request_id INT PRIMARY KEY ,
  status “request_status”,
  name VARCHAR(100),
  user_request_id INT
);
CREATE TABLE IF NOT EXISTS staff(
  staff_id INT PRIMARY KEY ,
  specialisation VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS user_request(
  user_request_id INT PRIMARY KEY ,
  user_spacesuit_data_id INT
);
CREATE TABLE IF NOT EXISTS fabric_texture(
  fabric_texture_id INT PRIMARY KEY ,
  fabric_texture_name VARCHAR(100)
);
CREATE TABLE IF NOT EXISTS user_spacesuit_data(
  user_spacesuit_data_id INT PRIMARY KEY ,
  head INT,
  chest INT,
  waist INT,
  hips INT,
  foot_size INT,
  height INT,
  fabric_texture_id INT
);
CREATE TABLE IF NOT EXISTS user(
  user_id INT PRIMARY KEY ,
  user_spacesuit_data_id INT ,
user_data_id INT,
name VARCHAR(100)
);
CREATE TABLE IF NOT EXISTS additional_char(
  user_id INT,
    user_data_id INT,
    value_name VARCHAR(255),
    value VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS user_data(
  user_data_id INT PRIMARY KEY,
age INT,
sex “sex”,
weight INT,
height INT,
hair_color VARCHAR(255),
location location_enum
);

