-- Table: synth_ma.synth_cousub_dim

-- DROP TABLE synth_ma.synth_cousub_dim;

CREATE TABLE synth_ma.synth_cousub_dim
(
  cs_name character varying(100),
  cs_fips character varying(5) NOT NULL,
  ct_fips character varying(3) NOT NULL,
  sq_mi double precision,
  cs_poly geometry(MultiPolygon,4269),
  cs_pnt geometry,
  CONSTRAINT pk_synth_cousub_dim PRIMARY KEY (ct_fips, cs_fips)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE synth_ma.synth_cousub_dim
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_cousub_dim TO synth_ma;
