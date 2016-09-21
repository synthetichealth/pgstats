#!/bin/bash
# Resets synthetic statistics in the synth_ma schema

echo "Resetting synthetic statistics..."

psql -d fhir <<EOF

-- Drop all facts in the synth_facts table
-- All views should update automatically to reflect
-- this change.
TRUNCATE synth_ma.synth_facts;
EOF

echo "Synthetic statistics reset."
