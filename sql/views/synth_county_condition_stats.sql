DROP VIEW IF EXISTS synth_ma.synth_county_condition_stats;

CREATE VIEW synth_ma.synth_county_condition_stats AS

SELECT cs_dim.ct_fips
    , cond_dim.condition_name
    , CASE WHEN SUM(f.pop) > 0 THEN SUM(f.pop) ELSE 0 END AS pop
    , CASE WHEN SUM(f.pop_male) > 0 THEN SUM(f.pop_male) ELSE 0 END AS pop_male
    , CASE WHEN SUM(f.pop_female) > 0 THEN SUM(f.pop_female) ELSE 0 END AS pop_female
    , CASE WHEN MIN(county_v.pop) = 0 THEN 0 WHEN SUM(f.pop) > 0 THEN SUM(f.pop) / MIN(county_v.pop) ELSE 0 END AS rate
    
FROM synth_ma.synth_cousub_dim AS cs_dim
    
LEFT JOIN synth_ma.synth_disease_facts AS f
    ON cs_dim.cs_fips = f.cs_fips

INNER JOIN synth_ma.synth_condition_dim AS cond_dim
    ON f.condition_id = cond_dim.condition_id

LEFT JOIN synth_ma.synth_county_pop_stats AS county_v
    ON cs_dim.ct_fips = county_v.ct_fips
    
GROUP BY cs_dim.ct_fips
    , cond_dim.condition_name
;
    