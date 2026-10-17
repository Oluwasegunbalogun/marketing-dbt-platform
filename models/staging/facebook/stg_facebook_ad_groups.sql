SELECT
    TRIM(ad_group_id) AS ad_group_id,
    TRIM(ad_group_name) AS ad_group_name,

    TRY_CAST(
        NULLIF(LOWER(TRIM(ad_group_updated_at)), 'null')
        AS TIMESTAMP
    ) AS ad_group_updated_at

FROM {{ source('facebook', 'facebook_ad_groups') }}