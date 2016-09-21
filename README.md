Synthetic Patient Statistics Using Postgres
===========================================
This repository contains all documentation, data, and setup scripts for synthetic patient statistics stored in Postgres. Current the scripts in this repository only work on Unix-like platforms (e.g. Ubuntu, Mac OS).

Database Schema
---------------
The current schema for the synthetic statistics is document as a UML diagram. See [synth\_ma\_schema.pdf](./docs/synth_ma_schema.pdf). This diagram was generated using [Star UML](http://staruml.io/). The `.mdj` file created by Star UML is also in this repository and can be edited for future schema revisions. 

Most data that are used by the Synthetic Mass UI are exposed as Postgres views. These views are typically less granular but provide more useful statistics than the underlying data.

**Views:**

* `synth_county_stats` - **total** population stats at the county level
* `synth_cousub_stats` - **total** population stats at the subdivision level
* `synth_county_facts` - **disease-specific** stats at the county level
* `synth_cousub_facts` - **disease-specific** stats at the subdivision level

The tables underlying these views have higher granularity and are generally updated with the most recent stats. They are rarely queried directly and are exposed through the views mentioned above.

**Tables:**

* `synth_county_dim` - immutable county data
* `synth_cousub_dim` - immutable subdivision data
* `synth_condition_dim` - conditions/facts we track
* `synth_age_dim` - age ranges we track
* `synth_facts` - **condition-specific** stats at the **subdivision** level

Note: the "_dim" suffix means "dimension".

For all county-level statistics we simply aggregate the subdivision statistics. Each "fact" we track (e.g. "cancer") may be made up of multiple conditions (e.g. "breast cancer", "lung cancer", and "colon cancer"). While we currently expose stats only at the fact granularity level, additional views can be added to expose stats at the condition or age-range granularity levels.

For persons without any diseases we track a "none" condition that helps us aggregate total population counts (total people with _and_ without diseases) at the county and subidivision levels.

Resetting Statistics
--------------------
Run the script `resetstats.sh` as user `postgres`. This does the following:

1. Drops all rows in the `synth_facts` table.

This will cause all views to automatically update with zero-valued stats. We interpret null rows in the `synth_facts` table as "zero".

Adding or Updating Statistics
-----------------------------
Facts should be added to this table using **"upserts"**. Each fact is uniquely identified by a composite key of `(cs_fips, condition_id, age_id)`. If an attempted insert into the `synth_facts` table violates this key an update of the existing row should be performed instead.

License
-------

Copyright 2016 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.