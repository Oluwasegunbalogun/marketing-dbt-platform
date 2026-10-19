# Marketing Data Platform with Databricks & dbt

## 1. Project Overview

I built this project to bring Facebook Ads and Snapchat Ads data into one place so that advertising performance can be analysed and compared more easily.

The two platforms organise their data differently, so I used Databricks and dbt to clean the source data, standardise the fields, and combine the relevant information into a single marketing performance fact table.

The final model makes it possible to analyse advertising spend, impressions, clicks, and derived performance metrics across both platforms. I also added data quality tests, model documentation, and Elementary monitoring to make the transformations easier to validate and maintain.

## 2. What I Wanted to Achieve

The main goals of the project were to:

- Bring Facebook and Snapchat advertising data into a common analytical structure.
- Standardise the source fields and data types.
- Make it easier to analyse advertising performance over time and compare the two platforms.
- Add data quality checks to catch potential issues in the transformed data.
- Document the models and show how the data moves from the source tables to the final fact table.
- Use Elementary to monitor dbt runs and data quality results.

## 3. Tools Used

| Tool | How I used it |
|---|---|
| Databricks | Stored the source data and ran the SQL transformations. |
| dbt Core | Built the models, organised the transformation logic, ran tests, and generated documentation. |
| dbt-databricks | Connected dbt to Databricks. |
| Elementary | Built monitoring models and supported data quality monitoring. |
| Python and uv | Managed the local development environment and ran the project commands. |
| PowerShell | Executed commands from my Windows development environment. |

## 4. How the Data Flows Through the Platform

I organised the project into Bronze, Silver, and Gold layers. This separates the original source data from the transformations and the final reporting model.

| Layer | Development | Production | Purpose |
|---|---|---|---|
| Bronze | `ads.bronze` | `ads.bronze` | Original source datasets |
| Silver | `ads.silver` | `marketing_prod.silver` | Cleaned and standardised data |
| Gold | `ads.gold` | `marketing_prod.gold` | Final marketing performance fact table |
| Elementary | `ads.dev_marketing_elementary` | `marketing_prod.elementary` | Monitoring models and related artifacts |

### Bronze: Source Data

I kept the supplied Facebook and Snapchat datasets in the Bronze schema. These include the available account, campaign, ad group, ad, and advertising statistics tables.

Keeping the original datasets separate makes it easier to trace the transformed records back to their respective platforms.

### Silver: Cleaning and Transformation

The Silver layer contains the staging and intermediate models.

The staging models, which use the `stg_` prefix, clean up the source fields, standardise naming, and convert values into appropriate data types. For example, some numeric fields contain the literal text `"null"` instead of an actual SQL `NULL`. I handled these values during staging so they would not be incorrectly treated as valid numbers.

The intermediate models, which use the `int_` prefix, organise the transformation and integration logic needed to bring the two platforms into a common structure.

### Gold: Final Reporting Model

The Gold layer contains the final fact table, `fct_marketing_ad_performance`.

- Development: `ads.gold.fct_marketing_ad_performance`
- Production: `marketing_prod.gold.fct_marketing_ad_performance`

This is the main table intended for downstream reporting and analysis. It brings the relevant advertising dimensions and performance measures together so that Facebook and Snapchat can be analysed using a consistent structure.

### Why I Chose These Materialisations

I used views for the staging and intermediate models because they allow me to organise the SQL logic without unnecessarily persisting every transformation. I used a table for the final fact model so the reporting output is stored and ready for repeated analytical queries.

Elementary has its own schema so that monitoring artifacts remain separate from the main reporting models.

## 5. Data Modelling Decisions

### Bringing Both Platforms into One Model

Facebook and Snapchat have different source structures. Rather than trying to make their original tables identical, I standardised the relevant fields during transformation and combined them in the final analytical model.

### Defining the Grain

I designed the fact table around advertising date, platform, campaign, and ad, while retaining country and currency where needed to distinguish records.

The composite key used by the model is tested for uniqueness. This helps prevent duplicate records at the intended level of detail.

### Keeping the Original Currencies

I retained the currencies supplied by the source data instead of converting everything into a single currency using an assumed exchange rate.

This means the spend values remain traceable to the source. However, monetary comparisons between records in different currencies need to account for those differences.

### Handling Account Inconsistencies

I chose to flag account inconsistencies for investigation rather than automatically matching accounts. This avoids making assumptions about which accounts should be treated as equivalent.

### Handling Missing Values

I did not replace missing impressions or clicks with zero automatically. A missing value does not necessarily mean that no activity occurred; it could also reflect an issue with the source data or extraction.

The transformations preserve the available records and clean up invalid numeric representations without inventing missing daily observations.

## 6. Marketing Metrics

The final model supports advertising spend, impressions, clicks, and the following derived metrics:

- **Click-through rate (CTR):** Clicks divided by impressions.
- **Cost per click (CPC):** Spend divided by clicks.
- **Cost per thousand impressions (CPM):** Spend multiplied by 1,000 and divided by impressions.

When the denominator is zero or unavailable, the relevant metric returns `NULL` rather than producing an invalid calculation.

Spend remains in the original reporting currency. The model does not perform currency conversion, so comparisons of spend across different currencies should be made carefully.

## 7. Data Quality and Testing

I used dbt tests to check the quality and consistency of the transformed data. These tests cover required fields, accepted platform values, the uniqueness of the fact table's composite key, and the validity of marketing metrics.

I also included checks to ensure that applicable metrics are not negative and that clicks do not exceed impressions where the relevant values are available.

### Results from My Latest Successful Runs

| Check | Result |
|---|---|
| Development build | 84 successful operations |
| Development build errors | 0 |
| Production model deployment | 15 successful operations |
| Production deployment errors | 0 |
| Production fact-table data tests | All 8 passed |
| Production Elementary build | 32 successful operations |
| Production fact-table row count | 95,109 |
| Distinct ad IDs | 2,883 |
| Advertising platforms represented | 2 |

I also checked the production fact table after deployment. It returned 95,109 rows and contained records from both Facebook and Snapchat. The row count matched the previously validated development output.

These results reflect my latest successful runs. Counts and test results may change when the underlying source data is updated.

## 8. Source Data Coverage and Limitations

The supplied datasets do not have identical coverage, which is important when interpreting the results.

- The Facebook source statistics contain 92,300 rows.
- The Snapchat source statistics contain 2,809 rows.
- Facebook data includes both USD and EUR records.
- Snapchat performance data is recorded in EUR.
- The two platforms cover different historical periods.

Because of these differences, a direct comparison between the platforms may not always be meaningful without considering the reporting period and currency.

I have therefore kept the original currencies and available records rather than introducing assumptions about missing dates, zero activity, or account relationships. These limitations should be considered when using the final model for business decisions.

## 9. Documentation and Monitoring

### dbt Documentation

I generated the dbt documentation using:

```powershell
uv run dbt docs generate --target prod
```

This generated the documentation artifacts, including `target/catalog.json`, which contains the catalog information gathered during the documentation process.

To view the documentation locally, I ran:

```powershell
uv run dbt docs serve --host 127.0.0.1
```

The documentation site provides a way to inspect the available models, their descriptions, and the relationships between source tables and downstream transformations.

### Elementary

I used Elementary to build the project's monitoring models and support the collection and review of dbt data quality information.

The production Elementary models were built successfully in `marketing_prod.elementary`. This provides a separate location for monitoring artifacts rather than mixing them with the main analytical tables.

## 10. Project Structure

The main project files and directories are organised as follows:

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
└── README.md
```

The project also uses a dbt profile stored outside the project directory to connect to Databricks.

## 11. Running the Project

The following commands can be run from the dbt project directory.

### Install dependencies

```powershell
uv run dbt deps
```

### Check the Databricks connection

```powershell
uv run dbt debug --target dev
```

### Build the development models and run their tests

```powershell
uv run dbt build --target dev
```

### Deploy the production models

```powershell
uv run dbt run --target prod --select +fct_marketing_ad_performance
```

### Test the production fact table

```powershell
uv run dbt test --target prod --select fct_marketing_ad_performance
```

### Build the production Elementary models

```powershell
uv run dbt run --target prod --select elementary
```

### Generate the documentation

```powershell
uv run dbt docs generate --target prod
```

The project uses separate development and production targets. A working Databricks connection, the appropriate permissions, and the required local environment configuration are needed to run these commands.

I configured the Databricks connection locally using my dbt profile and an environment variable for the access token. This keeps my credentials separate from the project code.

## 12. Conclusion

This project brings Facebook and Snapchat advertising data into a common analytical model using Databricks and dbt. I separated the source data, transformation logic, and final reporting output into distinct layers to make the solution easier to understand and maintain.

The production fact table contains 95,109 rows across the two advertising platforms, and the deployment and data quality checks completed successfully in my latest runs. The project also includes dbt documentation and Elementary monitoring to support traceability and ongoing validation.

There are still important considerations when interpreting the results, particularly the different source coverage periods, missing values, and currency differences. Keeping these limitations explicit makes the model more useful as a foundation for reliable marketing analysis.