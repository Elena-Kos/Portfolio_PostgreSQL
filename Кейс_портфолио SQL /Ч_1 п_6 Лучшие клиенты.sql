-- Шаг 1: Соединяем таблицы заказов и клиентов
WITH customer_orders AS (
  SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.second_name, 
    o.price * o.count AS order_amount -- Вычисляем сумму заказа
  FROM 
    pharma_orders o 
    INNER JOIN customers c ON o.customer_id = c.customer_id
), 
-- Шаг 2: Суммируем заказы для каждого клиента
customer_totals AS (
  SELECT 
    customer_id, 
    CONCAT(
      last_name, ', ', first_name, ' ', second_name
    ) AS full_name, 
    -- Формируем ФИО
    SUM(order_amount) AS total_amount -- Суммируем сумму заказов для каждого клиента
  FROM 
    customer_orders 
  GROUP BY 
    customer_id, 
    full_name
), 
-- Шаг 3: Присваиваем ранг каждому клиенту по убыванию суммы заказов
ranked_customers AS (
  SELECT 
    customer_id, 
    full_name, 
    total_amount, 
    ROW_NUMBER() OVER (
      ORDER BY 
        total_amount DESC
    ) AS rank -- Присваиваем ранг клиентам
  FROM 
    customer_totals
) -- Шаг 4: Выбираем топ-10 клиентов
SELECT 
  rank, 
  full_name, 
  total_amount 
FROM 
  ranked_customers 
WHERE 
  rank <= 10 -- Оставляем только топ-10 клиентов
ORDER BY 
  rank;
