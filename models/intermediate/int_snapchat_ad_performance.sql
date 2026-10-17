
WITH ad_performance AS (

    SELECT
        stats.ad_date,
        'Snapchat' AS platform,
        ads.ad_id,
        ads.ad_group_id,
        ad_groups.campaign_id,
        campaigns.account_id,
        stats.country,
        stats.currency_code,
        stats.spend,
        stats.impressions,
        stats.clicks,campaigns.campaign_name,
ad_groups.ad_group_name

    FROM {{ ref('stg_snapchat_ads_stats') }} AS stats

    LEFT JOIN {{ ref('stg_snapchat_ads') }} AS ads
        ON stats.ad_id = ads.ad_id

    LEFT JOIN {{ ref('stg_snapchat_ad_groups') }} AS ad_groups
        ON ads.ad_group_id = ad_groups.ad_group_id

    LEFT JOIN {{ ref('stg_snapchat_campaigns') }} AS campaigns
        ON ad_groups.campaign_id = campaigns.campaign_id

)

SELECT *
FROM ad_performance
