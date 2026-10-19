SELECT *
FROM {{ ref('fct_marketing_ad_performance') }}
WHERE clicks > impressions