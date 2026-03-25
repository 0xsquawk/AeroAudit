--Creating a new database
CREATE DATABASE airlines;

--Creating tables before importing the data
CREATE TABLE routes
(
    airline_code VARCHAR(255),
    airline_id NUMERIC,
    source_airport VARCHAR(255),
    source_airport_id NUMERIC,
    destination_airport VARCHAR(255),
    destination_airport_id NUMERIC,
    codeshare TEXT,
    stops NUMERIC,
    equipment VARCHAR(255)
)
;

CREATE TABLE planes
(
    name_aircraft VARCHAR(255),
    iata_code VARCHAR(255),
    icao_code VARCHAR(255)
)
;


-- Importing the data into tables
COPY routes FROM 'C:\public\Practice Datasets\Airline Data\routes.dat'
WITH (FORMAT csv, DELIMITER ',', NULL '\N');

COPY planes FROM 'C:\public\Practice Datasets\Airline Data\planes.dat'
WITH (FORMAT csv, DELIMITER ',', NULL '\N');


--Adding a new column as an array
ALTER TABLE routes ADD COLUMN equipment_list TEXT[];


--Using the string_to_array function to extract the aircraft/equipment and putting them into seperate rows/array
UPDATE routes
SET equipment_list = regexp_split_to_array(trim(routes.equipment), '\s+')
;


--Extracting the Routes and the full aircraft body and model names after joining the tables
SELECT
    r.source_airport,
    r.destination_airport,
    eq.code AS aircraft_iata_code,
    --Provides the full name, or a helpful 'Unknown' tag if the join fails
    COALESCE(p.name_aircraft, 'Unknown Aircraft (' || eq.code || ')') AS aircraft_name
FROM routes AS r
    --Explode the array column (text[]) into individual rows
CROSS JOIN LATERAL unnest(r.equipment_list) AS eq(code)
    --Using the LEFT JOIN to avoid losing the routes with missing aircraft names
LEFT JOIN planes AS p
    ON eq.code = p.iata_code
    --Filtering out any empty strings caused by extra spaces
WHERE eq.code <> '' AND eq.code IS NOT NULL
;


--Creating a permanent view to avoid using the long query for re-querying the cleaned data
CREATE VIEW simplified_routes AS
SELECT
    r.airline_code, r.source_airport, r.destination_airport,
    eq.code AS aircraft_iata,
    COALESCE(p.name_aircraft, 'Unknown (' || eq.code || ')') AS aircraft_full_name
FROM routes r
CROSS JOIN LATERAL unnest(r.equipment_list) AS eq(code)
LEFT JOIN planes p ON p.iata_code = eq.code
;


--The end result is now easily accessible using a simple select statement
SELECT *
FROM simplified_routes
;


--Query to find out the most popular plane
SELECT s.aircraft_full_name, count(*)
FROM simplified_routes AS s
GROUP BY aircraft_full_name
ORDER BY count(*) DESC
;

