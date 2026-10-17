SELECT
    TRIM(ad_id) AS ad_id,
    TRIM(ad_group_id) AS ad_group_id,
    TRIM(ad_name) AS ad_name,

    TRY_CAST(
        NULLIF(LOWER(TRIM(ad_detail_updated_at)), 'null')
        AS TIMESTAMP
    ) AS ad_detail_updated_at

FROM {{ source('snapchat', 'snapchat_ads') }}