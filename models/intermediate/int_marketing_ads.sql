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
    data_quality_status
FROM {{ ref('int_facebook_ad_performance') }}

UNION ALL

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
    'OK' AS data_quality_status
FROM {{ ref('int_snapchat_ad_performance') }}