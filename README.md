
SoCal Air Quality & Regulatory Risk Engine

Reproducible R analytical workflow evaluating SoCal particulate matter ($PM_{2.5}$) and EPA compliance standards.

Executive Summary

Engineered a reproducible R analytical workflow using tidyverse and ggplot2 to process public health and environmental sensor datasets, evaluating county-level fine particulate matter ($PM_{2.5}$) concentrations against U.S. EPA health-based standards across Southern California and the broader United States.

Business & Regulatory Context

In environmental engineering, compliance and risk assessment hinge on identifying municipal areas exceeding statutory air quality thresholds. This project automates the extraction and filtering of CDC National Environmental Public Health Tracking Network datasets to isolate counties exceeding the EPA primary annual standard ($9.0\ \mu g/m^3$). 

For regional engineering consultants and municipal planners in the Los Angeles basin, these workflows mirror the data processing required for CEQA/NEPA environmental impact reports and South Coast Air Quality Management District (AQMD) compliance monitoring.

Key Findings & Visual Intelligence

Statewide Exposure Risk: Approximately 37 million people (94.4%) in California reside in counties where fine particulate matter exceeds health-based standards ($PM_{2.5} \ge 9.0\ \mu g/m^3$).

Comparative Burden: California's population exposure rate is significantly HIGH compared to the U.S. national average (38%).

Top Polluted Counties (2020 Baseline): Mono County ($39.1\ \mu g/m^3$), Mariposa County ($21.3\ \mu g/m^3$), and Kern County ($21.1\ \mu g/m^3$) recorded the highest annual average concentrations in the state.

KEY BUSINESS INSIGHTS DERIVED FROM THIS ANALYSIS:

1. Industrial Permitting & Regulatory Risk Mapping
The Insight: By isolating counties exceeding the EPA annual standard (9.0 µg/m³), the pipeline identifies high-risk non-compliance zones where industrial operations, logistics facilities, and manufacturing plants face severe regulatory friction.

Commercial Value: Environmental engineering consultancies assist corporate clients with South Coast AQMD permit applications and CEQA/NEPA environmental impact reports. This data model provides a rapid screening tool to flag sites requiring rigorous emissions mitigation before project deployment.

2. Targeted Municipal Mitigation & Infrastructure Allocation
The Insight: Pinpointing outlier counties—such as Mono County (39.1 µg/m³), Mariposa County (21.3 µg/m³), and Kern County (21.1 µg/m³)—highlights geographic areas where particulate matter concentration heavily exceeds baseline standards due to localized topography, industrial density, or wildfire activity.

Commercial Value: Municipal planners and public health agencies use these analytical workflows to optimize the deployment of air-monitoring stations, mobile particulate scrubbers, and emergency public health advisories for vulnerable populations.

3. Corporate ESG & Health Equity Assessment
The Insight: Quantifying that 94.4% of California's population resides in areas exceeding health-based standards provides an empirical baseline for environmental justice and public health risk assessments.

Commercial Value: Corporate sustainability teams and ESG analysts rely on population-exposure metrics to evaluate community health burdens, assess supply chain climate risks, and fulfill mandatory corporate social responsibility disclosures.


Tech Stack & ArchitectureProgramming Language: R (version 4.6.1+)

Core Libraries: tidyverse (data manipulation, filtering, joins), ggplot2 (custom data visualization), scales (numerical formatting)

Data Sources: CDC National Environmental Public Health Tracking Network Data Explorer (2020) and U.S. Census Bureau FIPS county reference files.
