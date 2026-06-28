-- Funnel users by stage
CREATE TABLE analytics.funnel_metrics AS
WITH funnel AS (
    SELECT
        stage,
        COUNT(*) AS users
    FROM clean.user_funnel
    GROUP BY stage
)
SELECT
    stage,
    users,
    ROUND(
        users * 100.0 / FIRST_VALUE(users) OVER (
            ORDER BY CASE stage
                WHEN 'homepage' THEN 1
                WHEN 'product_page' THEN 2
                WHEN 'cart' THEN 3
                WHEN 'checkout' THEN 4
                WHEN 'purchase' THEN 5
            END
        ),
        2
    ) AS conversion_from_homepage
FROM funnel
ORDER BY CASE stage
    WHEN 'homepage' THEN 1
    WHEN 'product_page' THEN 2
    WHEN 'cart' THEN 3
    WHEN 'checkout' THEN 4
    WHEN 'purchase' THEN 5
END;
