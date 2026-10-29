SAVEPOINT "UNDOPOINT";
SAVEPOINT "RESTOREPOINT";
SELECT
    product_name || ', ' ||
    product_size || ' (' ||
    product_qty_type || ')'
FROM product LIMIT 49999 OFFSET 0;
RELEASE "RESTOREPOINT";
RELEASE "UNDOPOINT";
SAVEPOINT "UNDOPOINT";
SAVEPOINT "RESTOREPOINT";
SELECT
    product_name || ', ' ||
    COALESCE(product_size, '') || ' (' ||
    COALESCE(product_qty_type, 'unit') || ')'
FROM product LIMIT 49999 OFFSET 0;
RELEASE "RESTOREPOINT";
RELEASE "UNDOPOINT";
SAVEPOINT "UNDOPOINT";
SAVEPOINT "RESTOREPOINT";
SELECT
    customer_id,
    market_date,
    DENSE_RANK() OVER (
        PARTITION BY customer_id
        ORDER BY market_date
    ) AS visit_number
FROM customer_purchases
WHERE market_date < '2022-04-29' LIMIT 49999 OFFSET 0;
RELEASE "RESTOREPOINT";
RELEASE "UNDOPOINT";
SAVEPOINT "UNDOPOINT";
SAVEPOINT "RESTOREPOINT";
SELECT
    customer_id,
    market_date
FROM (
    SELECT
        customer_id,
        market_date,
        DENSE_RANK() OVER (
            PARTITION BY customer_id
            ORDER BY market_date DESC
        ) AS visit_number
    FROM customer_purchases
)
WHERE visit_number = 1 LIMIT 49999 OFFSET 0;
RELEASE "RESTOREPOINT";
RELEASE "UNDOPOINT";
SAVEPOINT "UNDOPOINT";
SAVEPOINT "RESTOREPOINT";
SELECT
    customer_id,
    product_id,
    market_date,
    COUNT(*) OVER (
        PARTITION BY customer_id, product_id
        ORDER BY market_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS purchase_count
FROM customer_purchases
WHERE market_date < '2022-04-29' LIMIT 49999 OFFSET 0;
RELEASE "RESTOREPOINT";
RELEASE "UNDOPOINT";
SAVEPOINT "UNDOPOINT";
SAVEPOINT "RESTOREPOINT";
SELECT
    product_name,
    CASE
        WHEN INSTR(product_name, '-') > 0
        THEN TRIM(
            SUBSTR(
                product_name,
                INSTR(product_name, '-') + 1
            )
        )
        ELSE NULL
    END AS product_description
FROM product LIMIT 49999 OFFSET 0;
RELEASE "RESTOREPOINT";
RELEASE "UNDOPOINT";
SAVEPOINT "UNDOPOINT";
SAVEPOINT "RESTOREPOINT";
SELECT
    product_name,
    CASE
        WHEN INSTR(product_name, '-') > 0
        THEN TRIM(
            SUBSTR(
                product_name,
                INSTR(product_name, '-') + 1
            )
        )
        ELSE NULL
    END AS product_description
FROM product LIMIT 49999 OFFSET 0;
RELEASE "RESTOREPOINT";
RELEASE "UNDOPOINT";
SAVEPOINT "UNDOPOINT";
SAVEPOINT "RESTOREPOINT";
WITH daily_sales AS (
    SELECT
        market_date,
        SUM(quantity * cost_per_quantity) AS total_sales
    FROM customer_purchases
    GROUP BY market_date
),
ranked_sales AS (
    SELECT
        market_date,
        total_sales,
        RANK() OVER (
            ORDER BY total_sales DESC
        ) AS highest_rank,
        RANK() OVER (
            ORDER BY total_sales ASC
        ) AS lowest_rank
    FROM daily_sales
)
SELECT
    market_date,
    total_sales,
    'Highest sales' AS sales_category
FROM ranked_sales
WHERE highest_rank = 1
UNION
SELECT
    market_date,
    total_sales,
    'Lowest sales' AS sales_category
FROM ranked_sales
WHERE lowest_rank = 1
RELEASE "RESTOREPOINT";
RELEASE "UNDOPOINT";
SAVEPOINT "UNDOPOINT";
SAVEPOINT "RESTOREPOINT";
RELEASE "RESTOREPOINT";
RELEASE "UNDOPOINT";
