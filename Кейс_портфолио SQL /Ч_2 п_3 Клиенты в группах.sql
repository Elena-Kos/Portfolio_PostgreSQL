-- Временная таблица для распределения по группам покупателей
WITH customer_ages AS (
  SELECT 
    customer_id, 
    gender, 
    -- Превращаем в возраст (текущая дата минус дата рождения)
    EXTRACT(
      YEAR 
      FROM 
        AGE(date_of_birth :: DATE)
    ) AS customer_age, 
    -- Группы покупателей
    CASE WHEN gender = 'муж' 
    AND EXTRACT(
      YEAR 
      FROM 
        AGE(date_of_birth :: DATE)
    ) < 30 THEN 'Мужчины младше 30' WHEN gender = 'муж' 
    AND EXTRACT(
      YEAR 
      FROM 
        AGE(date_of_birth :: DATE)
    ) BETWEEN 30 
    AND 45 THEN 'Мужчины 30-45' WHEN gender = 'муж' 
    AND EXTRACT(
      YEAR 
      FROM 
        AGE(date_of_birth :: DATE)
    ) > 45 THEN 'Мужчины 45+' WHEN gender = 'жен' 
    AND EXTRACT(
      YEAR 
      FROM 
        AGE(date_of_birth :: DATE)
    ) < 30 THEN 'Женщины младше 30' WHEN gender = 'жен' 
    AND EXTRACT(
      YEAR 
      FROM 
        AGE(date_of_birth :: DATE)
    ) BETWEEN 30 
    AND 45 THEN 'Женщины 30-45' WHEN gender = 'жен' 
    AND EXTRACT(
      YEAR 
      FROM 
        AGE(date_of_birth :: DATE)
    ) > 45 THEN 'Женщины 45+' ELSE 'Другая группа' END AS customer_group 
  FROM 
    customers
), 
--количество уникальных клиентов и общая сумма покупок по каждой группе
customer_groups AS (
  SELECT 
    customer_group, 
    COUNT(DISTINCT c_a.customer_id) AS cust_in_group_cnt, 
    SUM(p_o.price * p_o.count) AS costr_group_amnt 
  FROM 
    customer_ages AS c_a 
    INNER JOIN pharma_orders AS p_o USING (customer_id) 
  GROUP BY 
    customer_group
), 
--общая сумма продаж по всем заказам
total_sales AS (
  SELECT 
    SUM(price * count) AS total_sales 
  FROM 
    pharma_orders
) -- основной запрос
SELECT 
  customer_group, 
  cust_in_group_cnt, 
  costr_group_amnt, 
  total_sales.total_sales, 
  ROUND(
    (
      costr_group_amnt :: NUMERIC * 100 / total_sales.total_sales :: NUMERIC
    ), 
    1
  ) AS costr_group_share 
FROM 
  customer_groups CROSS 
  JOIN total_sales;
