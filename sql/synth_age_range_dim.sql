-- Table: synth_ma.synth_age_range_dim

-- DROP TABLE synth_ma.synth_age_range_dim;

CREATE TABLE synth_ma.synth_age_range_dim
(
  age_range_id serial PRIMARY KEY,
  display_name character varying(50),
  min_age integer,
  max_age integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE synth_ma.synth_age_range_dim
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_age_range_dim TO synth_ma;
