#!/bin/bash
# Resets synthetic statistics facts in the synth_ma schema

echo "Resetting synthetic statistics facts..."

psql -d fhir <<EOF

-- Drop all facts in the synth_*_facts tables
-- All views should update automatically to reflect
-- this change.
TRUNCATE synth_ma.synth_pop_facts;
TRUNCATE synth_ma.synth_condition_facts;
TRUNCATE synth_ma.synth_disease_facts;
EOF

echo "Synthetic statistics facts reset."
