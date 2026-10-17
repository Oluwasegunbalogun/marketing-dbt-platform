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
    clicks
FROM {{ ref('int_facebook_ad_performance') }}
WHERE data_quality_status = 'OK'

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
    clicks
FROM {{ ref('int_snapchat_ad_performance') }}