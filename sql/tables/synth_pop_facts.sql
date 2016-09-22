-- Table: synth_ma.synth_pop_facts

-- DROP TABLE synth_ma.synth_pop_facts;

CREATE TABLE synth_ma.synth_pop_facts
(
  cs_fips character varying(5) NOT NULL,
  age_id integer,
  pop numeric,
  pop_male numeric,
  pop_female numeric,
  CONSTRAINT pk_synth_pop_facts PRIMARY KEY (cs_fips, age_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE synth_ma.synth_pop_facts
  OWNER TO synth_ma;
GRANT ALL ON TABLE synth_ma.synth_pop_facts TO synth_ma;
