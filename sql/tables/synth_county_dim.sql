-- Table: synth_ma.synth_county_dim

-- DROP TABLE synth_ma.synth_county_dim;

CREATE TABLE synth_ma.synth_county_dim
(
  ct_name character varying(100),
  ct_fips character varying(3) NOT NULL,
  sq_mi double precision,
  ct_poly geometry(MultiPolygon,4269),
  ct_pnt geometry,
  CONSTRAINT pk_synth_county_dim PRIMARY KEY (ct_fips)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE synth_ma.synth_county_dim
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_county_dim TO synth_ma;