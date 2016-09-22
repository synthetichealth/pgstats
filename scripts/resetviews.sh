#!/bin/bash
# Resets synthetic statistics views in the synth_ma schema

echo "Resetting synthetic statistics views..."

psql -d fhir -f ../sql/views/synth_county_pop_stats.sql
psql -d fhir -f ../sql/views/synth_cousub_pop_stats.sql
psql -d fhir -f ../sql/views/synth_county_condition_stats.sql
psql -d fhir -f ../sql/views/synth_cousub_condition_stats.sql
psql -d fhir -f ../sql/views/synth_county_disease_stats.sql
psql -d fhir -f ../sql/views/synth_cousub_disease_stats.sql

echo "Synthetic statistics views reset."
