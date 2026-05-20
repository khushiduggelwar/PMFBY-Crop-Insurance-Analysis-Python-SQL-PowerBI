--create table
CREATE TABLE pmfby (
    year INT,
    season VARCHAR(50),
    state VARCHAR(100),
    district VARCHAR(100),
    crop VARCHAR(100),
    crop_category VARCHAR(100),
    crop_type VARCHAR(50),
    unit VARCHAR(50),
    sum_insured NUMERIC,
    premium_rate NUMERIC,
    farmer_share_pct NUMERIC,
    state_share_pct NUMERIC,
    goi_share_pct NUMERIC,
    farmer_share_value NUMERIC,
    state_share_value NUMERIC,
    goi_share_value NUMERIC,
    indemnity_level NUMERIC,
    insurance_company VARCHAR(200),
    total_subsidy NUMERIC,
    total_premium NUMERIC,
    gov_subsidy_pct NUMERIC,
    premium_to_insured_pct NUMERIC
);
SELECT COUNT(*) FROM pmfby;
SELECT season, COUNT(*) FROM pmfby GROUP BY season;
SELECT * FROM pmfby LIMIT 5;

--Q1 — Which states have the highest sum insured?
SELECT state, SUM(sum_insured) AS total_sum_insured FROM pmfby
GROUP BY state
ORDER BY total_sum_insured DESC
LIMIT 5;

--Q2 — Which crops have the highest insurance coverage?
SELECT crop, SUM(sum_insured) AS total_sum_insured FROM pmfby
GROUP BY crop
ORDER BY total_sum_insured DESC
LIMIT 5;

--Q3 — Which season has the highest insured amount?
SELECT season, SUM(sum_insured) AS total_sum_insured FROM pmfby 
GROUP BY season
ORDER BY total_sum_insured DESC;

--Q4 — Which states receive the highest government subsidy?
SELECT state, SUM(total_subsidy) AS total_gov_subsidy FROM pmfby
GROUP BY state
ORDER BY total_gov_subsidy DESC
LIMIT 10;

UPDATE pmfby
SET state = INITCAP(LOWER(state));

SELECT DISTINCT state FROM pmfby
GROUP BY state;

SELECT state, SUM(total_subsidy) AS total_gov_subsidy FROM pmfby
GROUP BY state
ORDER BY total_gov_subsidy DESC
LIMIT 10;

--Q5 — Which states have the highest farmer premium burden?
SELECT state, SUM(farmer_share_value) AS total_farmer_preminum,
SUM(total_premium) AS total_premium,
ROUND(SUM(farmer_share_value)*100.0/NULLIF(SUM(total_premium),0),2)
AS farmer_burden_percentage FROM pmfby
GROUP BY state
ORDER BY farmer_burden_percentage DESC
LIMIT 10;

--Q6 — Which crop categories are most dependent on govt subsidy?
SELECT crop_category, SUM(total_subsidy) AS total_subsidy,
SUM(total_premium) AS total_premium,
ROUND(SUM(total_subsidy)*100.0/NULLIF(SUM(total_premium),0),2)
AS subsidy_dependency_pct FROM pmfby
GROUP BY crop_category
ORDER BY subsidy_dependency_pct DESC
LIMIT 10;

--Q7 — Which insurance companies manage the highest insured value?
SELECT insurance_company, SUM(sum_insured) AS total_insured,
COUNT(*) AS total_records FROM pmfby
GROUP BY insurance_company
ORDER BY total_insured DESC
LIMIT 10;

--Q8 — Which districts show highest insurance exposure?
SELECT state, district, SUM(sum_insured) AS total_insured FROM pmfby
GROUP BY state, district
ORDER BY total_insured DESC
LIMIT 10;

--Q9 — How has coverage changed year over year?
WITH yearly AS(
SELECT year,SUM(sum_insured) AS total_sum_insured FROM pmfby
GROUP BY year
)
SELECT year, total_sum_insured, 
LAG(total_sum_insured) OVER (ORDER BY year) AS prev_year_insured,
ROUND((total_sum_insured-LAG(total_sum_insured) OVER (ORDER BY year))
*100.0/NULLIF(LAG(total_sum_insured) OVER (ORDER BY year),0),2
) AS yoy_growth_pct
FROM yearly
ORDER BY year;

--Q10 — Which states show unusually high premium-to-sum-insured ratio?
SELECT state, SUM(total_premium) AS total_premium, 
SUM(sum_insured) AS total_sum_insured,
ROUND(
SUM(total_premium)*100.0/NULLIF(SUM(sum_insured),0),2
) AS premium_to_insured_pct
FROM pmfby
GROUP BY state
ORDER BY premium_to_insured_pct DESC
LIMIT 10;

--Q11 — Which season-state combinations show highest concentration?
SELECT season, state, SUM(sum_insured) AS total_sum_insured FROM pmfby
GROUP BY season, state
ORDER BY total_sum_insured DESC
LIMIT 10;

--Q12 — Which crops dominate insured value across India?
SELECT crop, SUM(sum_insured) AS total_sum_insured,
ROUND(SUM(sum_insured)*100.0/(SELECT SUM(sum_insured) FROM pmfby),2
) AS pct_of_total
FROM pmfby
GROUP BY crop
ORDER BY total_sum_insured DESC
LIMIT 10;