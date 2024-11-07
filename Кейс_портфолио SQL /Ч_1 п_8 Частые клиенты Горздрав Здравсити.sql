WITH gorzdrav_customers AS (
  -- Временная таблица для аптеки Горздрав
  SELECT 
    c.customer_id, 
    CONCAT(
      COALESCE(c.last_name, ''), 
      ' ', 
      COALESCE(c.first_name, ''), 
      ' ', 
      COALESCE(c.second_name, '')
    ) AS full_name, 
    COUNT(o.order_id) AS order_count 
  FROM 
    pharma_orders o 
    INNER JOIN customers c ON o.customer_id = c.customer_id 
  WHERE 
    o.pharmacy_name = 'Горздрав' 
  GROUP BY 
    c.customer_id, 
    c.last_name, 
    c.first_name, 
    c.second_name 
  ORDER BY 
    order_count DESC 
  LIMIT 
    10
), zdravsiti_customers AS (
  -- Временная таблица для аптеки Здравсити
  SELECT 
    c.customer_id, 
    CONCAT(
      COALESCE(c.last_name, ''), 
      ' ', 
      COALESCE(c.first_name, ''), 
      ' ', 
      COALESCE(c.second_name, '')
    ) AS full_name, 
    COUNT(o.order_id) AS order_count 
  FROM 
    pharma_orders o 
    INNER JOIN customers c ON o.customer_id = c.customer_id 
  WHERE 
    o.pharmacy_name = 'Здравсити' 
  GROUP BY 
    c.customer_id, 
    c.last_name, 
    c.first_name, 
    c.second_name 
  ORDER BY 
    order_count DESC 
  LIMIT 
    10
) -- Объединяем данные из обеих аптек
SELECT 
  'Горздрав' AS pharmacy_name, 
  full_name, 
  order_count 
FROM 
  gorzdrav_customers 
UNION ALL 
SELECT 
  'Здравсити' AS pharmacy_name, 
  full_name, 
  order_count 
FROM 
  zdravsiti_customers 
ORDER BY 
  pharmacy_name, 
  order_count DESC;

