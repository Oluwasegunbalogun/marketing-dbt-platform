
WITH ad_performance AS (

    SELECT
        stats.ad_date,
        'Facebook' AS platform,
        stats.ad_id,
        ads.ad_group_id,
        ads.campaign_id,
        stats.account_id,
        'NOT_REPORTED' AS country,
        accounts.currency_code,
        stats.spend,
        stats.impressions,
        stats.clicks,
        campaigns.campaign_name,
ad_groups.ad_group_name,
        CASE
            WHEN ads.ad_id IS NULL THEN 'UNMATCHED_AD'
            WHEN ads.account_id <> stats.account_id
                OR ads.account_id IS NULL
                THEN 'ACCOUNT_MISMATCH'
            ELSE 'OK'
        END AS data_quality_status

    FROM {{ ref('stg_facebook_ads_stats') }} AS stats

    LEFT JOIN {{ ref('stg_facebook_ads') }} AS ads
        ON stats.ad_id = ads.ad_id

    LEFT JOIN {{ ref('stg_facebook_campaigns') }} AS campaigns
        ON ads.campaign_id = campaigns.campaign_id

    LEFT JOIN {{ ref('stg_facebook_ad_groups') }} AS ad_groups
        ON ads.ad_group_id = ad_groups.ad_group_id

    LEFT JOIN {{ ref('stg_facebook_accounts') }} AS accounts
        ON stats.account_id = accounts.account_id

)

SELECT *
FROM ad_performance
