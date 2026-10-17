SELECT
    TRIM(campaign_id) AS campaign_id,
    TRIM(campaign_name) AS campaign_name,

    TRY_CAST(
        NULLIF(LOWER(TRIM(campaign_updated_at)), 'null')
        AS TIMESTAMP
    ) AS campaign_updated_at

FROM {{ source('facebook', 'facebook_campaigns') }}