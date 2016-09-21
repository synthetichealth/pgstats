-- Table: synth_ma.synth_facts

-- DROP TABLE synth_ma.synth_facts;

CREATE TABLE synth_ma.synth_facts
(
  cs_fips character varying(5) NOT NULL,
  condition_id integer,
  age_id integer,
  pop numeric,
  pop_male numeric,
  pop_female numeric,
  CONSTRAINT pk_synth_facts PRIMARY KEY (cs_fips, condition_id, age_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE synth_ma.synth_facts
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_facts TO synth_ma;
