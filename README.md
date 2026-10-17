# Marketing Data Platform with Databricks & dbt

## 1. Project Overview

This project builds a unified marketing analytics data platform using **Databricks and dbt**. It consolidates paid advertising performance data from Facebook Ads and Snapchat Ads into a consistent analytical model for reporting, trend analysis, and cross-platform comparison.

The platform transforms source data into a documented, tested, and reusable data model while preserving the original reporting currencies and available source records.

## 2. Objectives

- Consolidate Facebook and Snapchat advertising performance data.
- Standardise platform-specific data into a common analytical structure.
- Enable analysis of advertising spend, impressions, and clicks over time.
- Apply data quality tests to improve trust in reporting outputs.
- Document data models and dependencies to support maintainability.
- Use Elementary to monitor dbt test results and project data quality.

## 3. Technology Stack

- **Databricks:** data storage and SQL processing.
- **dbt Core:** SQL transformations, testing, and documentation.
- **Databricks dbt adapter:** connectivity between dbt and Databricks.
- **Elementary:** data quality monitoring and reporting.
- **PowerShell and Python:** local development environment and command execution.

## 4. Data Architecture

The project follows a medallion-style architecture.

| Layer | Schema | Purpose |
|---|---|---|
| Bronze | `ads.bronze` | Source advertising datasets loaded into Databricks. |
| Silver | `ads.silver` | Staging and intermediate models that clean, standardise, and combine source data. |
| Gold | `ads.gold` | Final analytical fact table for reporting and analysis. |
| Monitoring | `ads.dev_marketing_elementary` | Elementary monitoring and test-result tables. |

### Bronze: Source Data

The Bronze layer contains the supplied Facebook and Snapchat datasets, including account, campaign, ad group, ad, and advertising statistics data where available.

### Silver: Transformation

The Silver layer contains staging models prefixed with `stg_` and intermediate models prefixed with `int_`.

Staging models standardise source fields and data types. Intermediate models combine advertising performance with the relevant platform-specific identifiers and descriptive attributes.

### Gold: Analytics

The Gold layer contains the final fact table:

`ads.gold.fct_marketing_ad_performance`

The intended grain is **one row per date, platform, campaign, and ad**. The table provides a common structure for analysing advertising performance across the two platforms.

## 5. Key Data Modelling Decisions

- **Common analytical structure:** Facebook and Snapchat performance data are brought into a consistent model.
- **Defined grain:** the final fact table is designed around date, platform, campaign, and ad.
- **Currency preservation:** source currencies are retained rather than converted using an assumed exchange rate.
- **Account mismatch handling:** account inconsistencies are flagged for investigation rather than automatically matched.
- **Source fidelity:** the transformations preserve available source records and do not manufacture missing daily observations.

## 6. Data Quality and Validation

The project uses dbt data tests to validate the transformed datasets and final analytical output.

The latest successful `dbt build` completed with:

- **83 successful build steps**
- **38 data tests passed**
- **0 warnings**
- **0 errors**
- **0 skipped steps**

These results reflect the latest recorded build execution.

The project also includes a singular test, `assert_marketing_metrics_non_negative.sql`, to check that applicable marketing performance metrics are not negative.

## 7. Source Coverage Considerations

The supplied source datasets have different coverage periods and currencies.

- Facebook source statistics contain 92,300 rows across the supplied extract.
- Snapchat source statistics contain 2,809 rows.
- Facebook performance data includes USD and EUR records.
- Snapchat performance data is recorded in EUR.
- The available Facebook EUR and USD records have different date coverage, while Snapchat data covers a separate historical period.

Differences in date coverage can affect direct comparisons between platforms. Missing records should not automatically be interpreted as zero activity; they may reflect inactivity, incomplete extraction, or other source-system behaviour. The project preserves the supplied data and makes these limitations explicit.

## 8. Elementary Monitoring

Elementary is used to generate a report based on the dbt project and its monitoring data.

The generated HTML report is:

`elementary_report.html`

The report is available in the project root after successful generation. It can be opened in a web browser to inspect the monitoring information collected by Elementary.

## 9. Project Structure

The principal project components are organised as follows:

```text
marketing_dbt/
├── analyses/
├── macros/
├── models/
│   ├── staging/
│   │   ├── facebook/
│   │   └── snapchat/
│   ├── intermediate/
│   └── marts/
├── tests/
├── dbt_project.yml
├── packages.yml
├── README.md
└── elementary_report.html
```

The project also uses a local dbt profile configured outside the repository to connect to Databricks.

## 10. Running the Project

Run the following commands from the dbt project directory.

### Install dependencies

```powershell
uv run dbt deps
```

### Validate the connection

```powershell
uv run dbt debug
```

### Run all models and tests

```powershell
uv run dbt build
```

### Generate dbt documentation artifacts

```powershell
uv run dbt docs generate
```

The documentation artifacts can be used to inspect model descriptions and transformation dependencies.

### Generate the Elementary report

Run the configured Elementary report command using the local CLI and the project's dbt profile. The resulting report is written to `elementary_report.html`.

## 11. Security and Configuration

Databricks connection details and credentials should be configured locally through the dbt profile and environment variables.

Do not commit access tokens, passwords, private credentials, or other secrets to source control. If sharing this project, verify that local environment files and credentials are excluded.

## 12. Conclusion

The project delivers a tested and structured foundation for unified Facebook and Snapchat advertising analytics. Its layered architecture separates source data from transformations and reporting models, while dbt testing and Elementary monitoring support data quality and maintainability. The final fact table provides a consistent starting point for marketing performance analysis, subject to the coverage and currency limitations of the supplied datasets.
