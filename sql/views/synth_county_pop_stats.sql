DROP VIEW IF EXISTS synth_ma.synth_county_pop_stats CASCADE;

CREATE VIEW synth_ma.synth_county_pop_stats AS

SELECT ct_dim.ct_fips
	, ct_dim.ct_name
	, ct_dim.sq_mi
	, ct_dim.ct_poly
	, ct_dim.ct_pnt
	, CASE WHEN SUM(f.pop) > 0 THEN SUM(f.pop) ELSE 0 END AS pop
	, CASE WHEN SUM(f.pop_male) > 0 THEN SUM(f.pop_male) ELSE 0 END AS pop_male
	, CASE WHEN SUM(f.pop_female) > 0 THEN SUM(f.pop_female) ELSE 0 END AS pop_female
	, CASE WHEN SUM(f.pop) > 0 THEN SUM(f.pop) / ct_dim.sq_mi ELSE 0 END AS pop_sm
	
FROM synth_ma.synth_county_dim AS ct_dim

LEFT JOIN synth_ma.synth_cousub_dim AS cs_dim
	ON ct_dim.ct_fips = cs_dim.ct_fips
	
LEFT JOIN synth_ma.synth_pop_facts AS f
	ON cs_dim.cs_fips = f.cs_fips
	
GROUP BY ct_dim.ct_fips
	, ct_dim.ct_name
	, ct_dim.sq_mi
	, ct_dim.ct_poly
	, ct_dim.ct_pnt
;
ALTER TABLE synth_ma.synth_county_pop_stats
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_county_pop_stats TO synth_ma;
