DROP VIEW IF EXISTS synth_ma.synth_cousub_condition_stats;

CREATE VIEW synth_ma.synth_cousub_condition_stats AS

WITH cd AS (
    SELECT cs_dim.cs_fips, cs_dim.cs_name, cond_dim.condition_name, cond_dim.condition_id
    FROM synth_ma.synth_cousub_dim cs_dim
    CROSS JOIN synth_ma.synth_condition_dim cond_dim
    WHERE cs_dim.cs_fips != '00000'
)
SELECT cd.cs_fips
    , cd.cs_name
    , cd.condition_name
    , CASE WHEN f.pop > 0 THEN f.pop ELSE 0 END AS pop
    , CASE WHEN f.pop_male > 0 THEN f.pop_male ELSE 0 END AS pop_male
    , CASE WHEN f.pop_female > 0 THEN f.pop_female ELSE 0 END AS pop_female
    , CASE WHEN cs_view.pop = 0 THEN 0 WHEN f.pop > 0 THEN f.pop / cs_view.pop ELSE 0 END AS rate
FROM cd AS cd
LEFT JOIN synth_ma.synth_condition_facts AS f
    ON f.cs_fips = cd.cs_fips AND f.condition_id = cd.condition_id
LEFT JOIN synth_ma.synth_cousub_pop_stats AS cs_view
    ON cs_view.cs_fips = cd.cs_fips
    
ORDER BY cd.cs_fips;

ALTER TABLE synth_ma.synth_cousub_condition_stats
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_cousub_condition_stats TO synth_ma;
    