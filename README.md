Synthetic Patient Statistics Using Postgres
===========================================
This repository contains all documentation, data, and setup scripts for synthetic patient statistics stored in Postgres. Current the scripts in this repository only work on Unix-like platforms (e.g. Ubuntu, Mac OS).

Database Schema
---------------
The current schema for the synthetic statistics is document as a UML diagram. See [synth\_ma\_schema.pdf](./docs/synth_ma_schema.pdf). This diagram was generated using [Star UML](http://staruml.io/). The `.mdj` file created by Star UML is also in this repository and can be edited for future schema revisions. 

Most data that are used by the Synthetic Mass UI are exposed as Postgres views. These views are typically less granular but provide more useful statistics than the underlying data.

Views
-----

* `synth_county_pop_stats` - **total** population stats at the county level
* `synth_cousub_pop_stats` - **total** population stats at the subdivision level
* `synth_county_condition_stats` - **condition-specific** stats at the county level
* `synth_cousub_condition_stats` - **condition-specific** stats at the subdivision level
* `synth_county_disease_stats` - **disease-specific** stats at the county level
* `synth_cousub_disease_stats` - **disease-specific** stats at the subdivision level

The tables underlying these views have higher granularity and are generally updated with the most recent stats. They are rarely queried directly and are exposed through the views mentioned above.

We interpret **"conditions"** to mean a unique condition with a unique SNOMED code, for example "myocardial\_infarction".

We interpret **"diseases"** to be high-level statistics that may include one or more conditions. For example, the disease "food\_allergy" may include the conditions "food\_allergy\_peanuts", "food\_allergy\_tree\_nuts", and "food\_allergy\_shellfish".

For all county-level statistics we simply aggregate the subdivision statistics.

Tables
-----

* `synth_county_dim` - immutable county data
* `synth_cousub_dim` - immutable subdivision data
* `synth_condition_dim` - conditions we track
* `synth_disease_dim` - diseases we track
* `synth_age_range_dim` - age ranges we track
* `synth_pop_facts` - **total** population stats at the **subdivision** level
* `synth_condition_facts` - **condition-specific** population stats at the **subdivision** level
* `synth_disease_facts` - **disease-specific** population stats at the **subdivision** level

Note: the "_dim" suffix means "dimension". These tables contain data that rarely changes.

Resetting Statistics
--------------------
Run the script `resetfacts.sh` as user `postgres`. This does the following:

1. Drops all rows in the `synth_*_facts` tables in the `synth_ma` schema.

This will cause all views to automatically update with zero-valued stats. We interpret null rows in the `synth_*_facts` tables as "zero".

Updating Views
--------------
If the view logic changes (for example, to add additional computed statistics like rates) all views can be updated by running `resetviews.sh` as user `postgres`. This does the following:

1. Drops (cascading) all `synth_*_*_stats` views in the `synth_ma` schema.
2. Rebuilds the views using the updated SQL files. 

Adding or Updating Statistics
-----------------------------
Facts should be added to the facts tables using **"upserts"**. In each of the fact tables each fact is uniquely identified by a composite key. If an attempted insert into any of the `synth_*_facts` table violates these keys an update of the existing row should be performed instead.

License
-------

Copyright 2016 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.