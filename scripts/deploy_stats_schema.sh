#!/bin/bash
# Deploys the complete synth_ma synthetic statistics schema.
# This assumes that the database "fhir" and role "synth_ma"
# already exist.

echo "---------------------------------------------"
echo "DEPLOYING SYNTHETIC STATISTICS SCHEMA [START]"
echo "---------------------------------------------"
echo "Removing old stats schema, if it exists..."

psql -d fhir <<EOF
-- Clear the views
DROP VIEW IF EXISTS synth_ma.synth_county_disease_stats CASCADE;
DROP VIEW IF EXISTS synth_ma.synth_cousub_disease_stats CASCADE;
DROP VIEW IF EXISTS synth_ma.synth_county_condition_stats CASCADE;
DROP VIEW IF EXISTS synth_ma.synth_cousub_condition_stats CASCADE;
DROP VIEW IF EXISTS synth_ma.synth_county_pop_stats CASCADE;
DROP VIEW IF EXISTS synth_ma.synth_cousub_pop_stats CASCADE;

-- Clear the old fact tables
DROP TABLE IF EXISTS synth_ma.synth_disease_facts;
DROP TABLE IF EXISTS synth_ma.synth_condition_facts;
DROP TABLE IF EXISTS synth_ma.synth_pop_facts;

-- Clear the old dim tables
DROP TABLE IF EXISTS synth_ma.synth_condition_dim;
DROP TABLE IF EXISTS synth_ma.synth_disease_dim;
DROP TABLE IF EXISTS synth_ma.synth_age_range_dim;
DROP TABLE IF EXISTS synth_ma.synth_cousub_dim;
DROP TABLE IF EXISTS synth_ma.synth_county_dim;
EOF

echo "Creating dimension tables..."
psql -d fhir -f ../sql/tables/synth_county_dim.sql
psql -d fhir -f ../sql/tables/synth_cousub_dim.sql
psql -d fhir -f ../sql/tables/synth_age_range_dim.sql
psql -d fhir -f ../sql/tables/synth_disease_dim.sql
psql -d fhir -f ../sql/tables/synth_condition_dim.sql

echo "Populating dimension tables..."
cat ../data/synth_county_dim.csv | psql -d fhir -c "\COPY synth_ma.synth_county_dim (ct_name, ct_fips, sq_mi, ct_poly, ct_pnt) FROM STDIN (DELIMITER ',', QUOTE '\"', HEADER TRUE, FORMAT CSV)"
cat ../data/synth_cousub_dim.csv | psql -d fhir -c "\COPY synth_ma.synth_cousub_dim (cs_name, cs_fips, ct_fips, sq_mi, cs_poly, cs_pnt) FROM STDIN (DELIMITER ',', QUOTE '\"', HEADER TRUE, FORMAT CSV)"
cat ../data/synth_age_range_dim.csv | psql -d fhir -c "\COPY synth_ma.synth_age_range_dim (age_range_id, display_name, min_age, max_age) FROM STDIN (DELIMITER ',', QUOTE '\"', HEADER TRUE, FORMAT CSV)"
cat ../data/synth_disease_dim.csv | psql -d fhir -c "\COPY synth_ma.synth_disease_dim (disease_id, disease_name) FROM STDIN (DELIMITER ',', QUOTE '\"', HEADER TRUE, FORMAT CSV)"
cat ../data/synth_condition_dim.csv | psql -d fhir -c "\COPY synth_ma.synth_condition_dim (condition_id, disease_id, condition_name, code_system, code) FROM STDIN (DELIMITER ',', QUOTE '\"', HEADER TRUE, FORMAT CSV)"

echo "Creating fact tables..."
psql -d fhir -f ../sql/tables/synth_pop_facts.sql
psql -d fhir -f ../sql/tables/synth_condition_facts.sql
psql -d fhir -f ../sql/tables/synth_disease_facts.sql

echo "Creating views..."
psql -d fhir -f ../sql/views/synth_county_pop_stats.sql
psql -d fhir -f ../sql/views/synth_cousub_pop_stats.sql
psql -d fhir -f ../sql/views/synth_county_condition_stats.sql
psql -d fhir -f ../sql/views/synth_cousub_condition_stats.sql
psql -d fhir -f ../sql/views/synth_county_disease_stats.sql
psql -d fhir -f ../sql/views/synth_cousub_disease_stats.sql

echo "Cleaning up..."
psql -d fhir <<EOF
VACUUM ANALYZE synth_ma.synth_county_dim;
VACUUM ANALYZE synth_ma.synth_cousub_dim;
VACUUM ANALYZE synth_ma.synth_age_range_dim;
VACUUM ANALYZE synth_ma.synth_condition_dim;
VACUUM ANALYZE synth_ma.synth_disease_dim;
EOF

echo "---------------------------------------------"
echo "DEPLOYING SYNTHETIC STATISTICS SCHEMA  [DONE]"
echo "---------------------------------------------"
