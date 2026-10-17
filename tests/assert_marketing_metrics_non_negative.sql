
SELECT *
FROM {{ ref('fct_marketing_ad_performance') }}
WHERE spend < 0
   OR impressions < 0
   OR clicks < 0
