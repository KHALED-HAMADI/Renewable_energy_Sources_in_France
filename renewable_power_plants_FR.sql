-- Retrive data
SELECT * FROM renewable_power_plants_fr; 

-- Delete not needed columns
ALTER TABLE renewable_power_plants_fr
DROP COLUMN data_source,
DROP COLUMN nuts_2_region,
DROP COLUMN nuts_2_region,
DROP COLUMN nuts_3_region,
DROP COLUMN as_of_year,
DROP COLUMN region,
DROP COLUMN region_code,
DROP COLUMN departement, 
DROP COLUMN departement_code,
DROP COLUMN municipality_group,
DROP COLUMN municipality_group_code
;

-- total electrical capacity--
SELECT SUM(electrical_capacity) AS Total_electrical_capacity
FROM renewable_power_plants_FR;

-- total electrical capacity per energy source level 2--
SELECT 
	energy_source_level_2,
    ROUND(SUM(electrical_capacity),2) total_electrical_capacity,
    'MW' AS Unit
FROM renewable_power_plants_FR
GROUP BY energy_source_level_2
ORDER BY total_electrical_capacity DESC;

SELECT 
	energy_source_level_2,
	energy_source_level_3,
    ROUND(SUM(electrical_capacity),2) AS total_electrical_capacity
FROM renewable_power_plants_FR
GROUP BY 
	energy_source_level_2,
	energy_source_level_3
ORDER BY total_electrical_capacity DESC;

-- AVG electrical capacity per energy_source_level_2 --
SELECT 
	energy_source_level_2,
	ROUND(AVG(electrical_capacity),2) Average_electrical_capacity
FROM renewable_power_plants_fr
GROUP BY energy_source_level_2
ORDER BY Average_electrical_capacity DESC;

-- AVG electrical capacity per energy_source_level_3 --
SELECT 
	energy_source_level_2,
	energy_source_level_3,
    ROUND(AVG(electrical_capacity),2) AS average_electrical_capacity
FROM renewable_power_plants_EU
GROUP BY 
	energy_source_level_2,
	energy_source_level_3
ORDER BY average_electrical_capacity DESC;

-- attributes of energy source level 2--
SELECT 
	energy_source_level_2,
    COUNT(energy_source_level_2) number_of_sources,
    ROUND(AVG(electrical_capacity),2) average_electrical_capacity,
    ROUND(SUM(electrical_capacity),2) total_electrical_capacity
FROM renewable_power_plants_fr
GROUP BY energy_source_level_2
ORDER BY number_of_sources DESC;

-- attributes of energy source level 3--
SELECT 
	energy_source_level_2,
	energy_source_level_3,
    COUNT(energy_source_level_3) number_of_sources,
    ROUND(AVG(electrical_capacity),2) average_electrical_capacity,
    ROUND(SUM(electrical_capacity),2) total_electrical_capacity
FROM renewable_power_plants_fr
GROUP BY 
	energy_source_level_2,
	energy_source_level_3
ORDER BY number_of_sources DESC;

-- contribution of energy source level 2 to the total electrical capacity--
SELECT 
	energy_source_level_2,
    COUNT(energy_source_level_2) number_of_sources,
    ROUND(AVG(electrical_capacity),2) average_electrical_capacity,
    ROUND(SUM(electrical_capacity),2) total_electrical_capacity
FROM renewable_power_plants_eu
GROUP BY energy_source_level_2
ORDER BY number_of_sources DESC;

-- contribution of level 2 energy sources to total electrical capacity--
-- Create a temporary table
CREATE TEMPORARY TABLE temp_renewable_stats AS
SELECT 
    energy_source_level_2,
    COUNT(energy_source_level_2) AS number_of_sources,
    ROUND(AVG(electrical_capacity), 2) AS average_electrical_capacity,
    ROUND(SUM(electrical_capacity), 2) AS total_electrical_capacity
FROM renewable_power_plants_fr
GROUP BY energy_source_level_2
ORDER BY number_of_sources DESC;

SELECT * FROM temp_renewable_stats;

SELECT 
	*,
    CONCAT(total_electrical_capacity,' ','MW') AS total_electrical_capacity,
	CONCAT(ROUND(total_electrical_capacity/SUM(total_electrical_capacity) OVER() * 100,2),' ','%') AS Percent_of_grand_total,
	CONCAT(ROUND(SUM(total_electrical_capacity) OVER(),2) ,' MW') AS Grand_total_electrical_capacity
FROM temp_renewable_stats;


