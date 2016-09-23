DROP VIEW IF EXISTS synth_ma.synth_county_disease_stats;

CREATE VIEW synth_ma.synth_county_disease_stats AS

WITH cd AS (
	SELECT cs_dim.ct_fips, ct_dim.ct_name, cs_dim.cs_fips, disease_dim.disease_name
	FROM synth_ma.synth_cousub_dim cs_dim
	INNER JOIN synth_ma.synth_county_dim ct_dim
		ON ct_dim.ct_fips = cs_dim.ct_fips
	CROSS JOIN synth_ma.synth_disease_dim disease_dim
)
SELECT cd.ct_fips
	, cd.ct_name
	, cd.disease_name
	, CASE WHEN SUM(f.pop) > 0 THEN SUM(f.pop) ELSE 0 END AS pop
	, CASE WHEN SUM(f.pop_male) > 0 THEN SUM(f.pop_male) ELSE 0 END AS pop_male
	, CASE WHEN SUM(f.pop_female) > 0 THEN SUM(f.pop_female) ELSE 0 END AS pop_female
	, CASE WHEN MIN(ct_view.pop) = 0 THEN 0 WHEN SUM(f.pop) > 0 THEN SUM(f.pop) / MIN(ct_view.pop) ELSE 0 END AS rate
FROM cd AS cd
LEFT JOIN synth_ma.synth_disease_facts AS f
	ON f.cs_fips = cd.cs_fips
LEFT JOIN synth_ma.synth_county_pop_stats AS ct_view
	ON ct_view.ct_fips = cd.ct_fips
GROUP BY cd.ct_fips, cd.ct_name, cd.disease_name
ORDER BY cd.ct_fips;

ALTER TABLE synth_ma.synth_county_disease_stats
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_county_disease_stats TO synth_ma;
