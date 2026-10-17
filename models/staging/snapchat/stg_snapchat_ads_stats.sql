WITH source_data AS (

    SELECT *
    FROM {{ source('snapchat', 'snapchat_ads_stats') }}

),

cleaned AS (

    SELECT
        TRIM(ad_detail_id) AS ad_id,
        UPPER(TRIM(ad_currency_code)) AS currency_code,
        LOWER(TRIM(ad_country)) AS country,

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

        TRY_CAST(TRIM(ad_date) AS DATE) AS ad_date,

        TRIM(data_src) AS data_source

    FROM source_data

)

SELECT *
FROM cleaned