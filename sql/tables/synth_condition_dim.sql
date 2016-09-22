-- Table: synth_ma.synth_condition_dim

-- DROP TABLE synth_ma.synth_condition_dim;

CREATE TABLE synth_ma.synth_condition_dim
(
  condition_id serial PRIMARY KEY,
  disease_id integer,
  condition_name character varying(100),
  code_system character varying(100),
  code character varying(20),
  CONSTRAINT synth_condition_code_dim UNIQUE (condition_name, code_system, code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE synth_ma.synth_condition_dim
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_condition_dim TO synth_ma;

