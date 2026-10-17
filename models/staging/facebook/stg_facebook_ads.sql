SELECT
    TRIM(ad_id) AS ad_id,
    TRIM(campaign_id) AS campaign_id,
    TRIM(ad_group_id) AS ad_group_id,
    TRIM(account_id) AS account_id,
    TRIM(ad_name) AS ad_name,
    UPPER(TRIM(ad_status)) AS ad_status,

    TRY_CAST(
        NULLIF(LOWER(TRIM(ad_updated_at)), 'null')
        AS TIMESTAMP
    ) AS ad_updated_at

FROM {{ source('facebook', 'facebook_ads') }}