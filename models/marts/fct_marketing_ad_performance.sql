SELECT
    ad_date,
    platform,
    account_id,
    campaign_id,
    ad_group_id,
    ad_id,
    campaign_name,
    ad_group_name,
    country,
    currency_code,
    spend,
    impressions,
    clicks,
    CASE
        WHEN clicks IS NOT NULL AND clicks > 0
            THEN spend / clicks
        ELSE NULL
    END AS cost_per_click,
    CASE
        WHEN impressions IS NOT NULL AND impressions > 0
            THEN spend * 1000 / impressions
        ELSE NULL
    END AS cost_per_mille
FROM {{ ref('int_marketing_ads') }}