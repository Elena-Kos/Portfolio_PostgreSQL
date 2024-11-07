-- Шаг 1: Объединяем таблицы заказов и клиентов
WITH customer_counts AS (
    SELECT
        p.pharmacy_name,  -- Имя аптеки
        COUNT(DISTINCT p.customer_id) AS unique_customers  -- Количество уникальных клиентов
    FROM
        pharma_orders p
    INNER JOIN
        customers c
    ON
        p.customer_id = c.customer_id  -- Соединяем по ID клиента
    GROUP BY
        p.pharmacy_name  -- Группируем по аптекам
)

-- Шаг 2: Выводим результат с количеством уникальных клиентов, отсортированным по убыванию
SELECT
    pharmacy_name,
    unique_customers
FROM
    customer_counts
ORDER BY
    unique_customers DESC;  -- Сортировка по количеству клиентов в убывающем порядке
