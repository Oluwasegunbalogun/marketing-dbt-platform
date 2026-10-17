WITH source_data AS (

    SELECT
        TRIM(_surrogate_key) AS surrogate_key,
        TRIM(ad_group_id) AS ad_group_id,
        TRIM(campaign_id) AS campaign_id,
        TRIM(ad_group_name) AS ad_group_name,

        TRY_CAST(
            NULLIF(LOWER(TRIM(ad_group_updated_at)), 'null')
            AS TIMESTAMP
        ) AS ad_group_updated_at

    FROM {{ source('snapchat', 'snapchat_ad_groups') }}

),

ranked AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY ad_group_id
            ORDER BY
                ad_group_updated_at DESC NULLS LAST,
                surrogate_key DESC
        ) AS record_rank

    FROM source_data

)

SELECT
    surrogate_key,
    ad_group_id,
    campaign_id,
    ad_group_name,
    ad_group_updated_at

FROM ranked
WHERE record_rank = 1