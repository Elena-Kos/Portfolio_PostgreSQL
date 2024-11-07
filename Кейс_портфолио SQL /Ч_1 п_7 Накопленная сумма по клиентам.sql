WITH customer_orders AS (
  -- Соединяем таблицы заказов и клиентов
  SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.second_name, 
    CONCAT(
      COALESCE(c.last_name, ''), 
      ' ', 
      COALESCE(c.first_name, ''), 
      ' ', 
      COALESCE(c.second_name, '')
    ) AS full_name, 
    -- Объединяем ФИО в одно поле
    o.report_date, 
    o.price * o.count AS order_amount -- Рассчитываем сумму заказа
  FROM 
    pharma_orders o 
    INNER JOIN customers c ON o.customer_id = c.customer_id
), 
cumulative_sales AS (
  -- Рассчитываем накопленную сумму по каждому клиенту по датам
  SELECT 
    customer_id, 
    full_name, 
    report_date, 
    order_amount, 
    SUM(order_amount) OVER (
      PARTITION BY customer_id 
      ORDER BY 
        report_date ASC
    ) AS cumulative_amount -- Накопленная сумма по клиенту
  FROM 
    customer_orders
) 
SELECT 
  ROW_NUMBER() OVER (
    PARTITION BY customer_id 
    ORDER BY 
      report_date ASC
  ) AS order_rank, 
  -- Присваиваем порядковый номер заказа клиента по дате
  customer_id, 
  full_name, 
  report_date, 
  order_amount, 
  cumulative_amount 
FROM 
  cumulative_sales 
ORDER BY 
  customer_id, 
  report_date ASC;
