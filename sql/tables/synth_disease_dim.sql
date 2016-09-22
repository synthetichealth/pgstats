-- Table: synth_ma.synth_disease_dim

-- DROP TABLE synth_ma.synth_disease_dim;

CREATE TABLE synth_ma.synth_disease_dim
(
  disease_id serial PRIMARY KEY,
  disease_name character varying(100),
  CONSTRAINT synth_disease_dim_name UNIQUE (disease_name)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE synth_ma.synth_disease_dim
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_disease_dim TO synth_ma;

