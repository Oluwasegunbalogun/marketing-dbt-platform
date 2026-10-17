WITH source_data AS (

    SELECT *
    FROM {{ source('facebook', 'facebook_ads_stats') }}

),

cleaned AS (

    SELECT
        TRIM(ad_id) AS ad_id,
        TRIM(account_id) AS account_id,

        TRY_CAST(
            NULLIF(LOWER(TRIM(ad_spend)), 'null')
            AS DECIMAL(18, 2)
        ) AS spend,

        TRY_CAST(
            NULLIF(LOWER(TRIM(ad_impressions)), 'null')
            AS BIGINT
        ) AS impressions,

        TRY_CAST(
            NULLIF(LOWER(TRIM(ad_clicks)), 'null')
            AS BIGINT
        ) AS clicks,

        TRY_CAST(
            TRIM(ad_date)
            AS DATE
        ) AS ad_date

    FROM source_data

)

SELECT *
FROM cleaned