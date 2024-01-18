-- Retrieve data
SELECT * FROM renewable_power_plants_fr;

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

-- total electrical capacity per energy source level 2_3--
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
FROM renewable_power_plants_FR
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
WITH energy_source_lv2_count_avg_sum AS (
SELECT 
    energy_source_level_2,
    COUNT(energy_source_level_2) AS number_of_sources,
    ROUND(AVG(electrical_capacity), 2) AS average_electrical_capacity,
    ROUND(SUM(electrical_capacity), 2) AS total_electrical_capacity
FROM renewable_power_plants_fr
GROUP BY energy_source_level_2
ORDER BY number_of_sources DESC
),

sum_electrical_capacity AS (
SELECT 
	SUM(total_electrical_capacity) grand_total
 FROM energy_source_lv2_count_avg_sum
 )
 
 SELECT 
	energy_source_level_2,
    (total_electrical_capacity/grand_total)*100 "source_contribution_to_grand_total_output (%)"
 FROM energy_source_lv2_count_avg_sum
 CROSS JOIN sum_electrical_capacity;
 
 -- Creating Views --
 
 -- 1. number of power plants and sum and average of output of level 2 sources --
 CREATE VIEW lvl2_count_avg_sum AS
 SELECT 
	energy_source_level_2,
    COUNT(energy_source_level_2) number_of_sources,
    ROUND(AVG(electrical_capacity),2) average_electrical_capacity,
    ROUND(SUM(electrical_capacity),2) total_electrical_capacity
FROM renewable_power_plants_fr
GROUP BY energy_source_level_2
ORDER BY number_of_sources DESC;
 
 -- 2. number of power plants and sum and average of output of level 2 sources --
  CREATE VIEW lvl3_count_avg_sum AS
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

-- 3. the contribution of each level 2 energy source type to the total output --

CREATE VIEW lvl2_contribution_to_total_output AS
WITH energy_source_lv2_count_avg_sum AS (
SELECT 
    energy_source_level_2,
    COUNT(energy_source_level_2) AS number_of_sources,
    ROUND(AVG(electrical_capacity), 2) AS average_electrical_capacity,
    ROUND(SUM(electrical_capacity), 2) AS total_electrical_capacity
FROM renewable_power_plants_fr
GROUP BY energy_source_level_2
ORDER BY number_of_sources DESC
),

sum_electrical_capacity AS (
SELECT 
	SUM(total_electrical_capacity) grand_total
 FROM energy_source_lv2_count_avg_sum
 )
 
 SELECT 
	energy_source_level_2,
    (total_electrical_capacity/grand_total)*100 "source_contribution_to_grand_total_output (%)"
 FROM energy_source_lv2_count_avg_sum
 CROSS JOIN sum_electrical_capacity;
 
 SELECT * FROM lvl2_contribution_to_total_output;


 
 
 




