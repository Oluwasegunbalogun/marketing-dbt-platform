SELECT
    TRIM(campaign_id) AS campaign_id,
    TRIM(account_id) AS account_id,
    TRIM(campaign_name) AS campaign_name
FROM {{ source('snapchat', 'snapchat_campaigns') }}