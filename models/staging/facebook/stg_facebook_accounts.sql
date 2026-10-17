SELECT
    TRIM(account_id) AS account_id,
    TRIM(account_name) AS account_name,
    UPPER(TRIM(ad_currency_code)) AS currency_code,

    TRY_CAST(
        NULLIF(LOWER(TRIM(account_created_at)), 'null')
        AS DATE
    ) AS account_created_at,

    TRY_CAST(
        NULLIF(LOWER(TRIM(account_updated_at)), 'null')
        AS TIMESTAMP
    ) AS account_updated_at

FROM {{ source('facebook', 'facebook_accounts') }}
