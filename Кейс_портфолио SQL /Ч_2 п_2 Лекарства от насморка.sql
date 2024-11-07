-- Шаг 1: Создаем временную таблицу для расчета суммы продаж по каждому препарату и аптеке
WITH pharma_drug AS (
  SELECT 
    pharmacy_name, 
    drug, 
    SUM(price * count) AS order_amnt 
  FROM 
    pharma_orders 
  WHERE 
    LOWER(drug) LIKE '%аква%' 
  GROUP BY 
    pharmacy_name, 
    drug
), 
-- Шаг 2: Создаем временную таблицу для расчета общей суммы продаж по каждой аптеке
pharma_total_sales AS (
  SELECT 
    pharmacy_name, 
    SUM(price * count) AS total_namepharmacy_sales 
  FROM 
    pharma_orders 
  GROUP BY 
    pharmacy_name
) -- Шаг 3: Основной запрос для объединения данных из временных таблиц и расчета долей продаж
SELECT 
  pharma_drug.pharmacy_name, 
  pharma_drug.drug, 
  ROW_NUMBER () OVER (
    PARTITION BY pharma_drug.pharmacy_name 
    ORDER BY 
      pharma_drug.order_amnt DESC
  ) AS drug_rang, 
  pharma_drug.order_amnt, 
  pharma_total_sales.total_namepharmacy_sales, 
  ROUND(
    (
      pharma_drug.order_amnt :: NUMERIC * 100 / pharma_total_sales.total_namepharmacy_sales :: NUMERIC
    ), 
    1
  ) AS drug_in_pharmacy_share 
FROM 
  pharma_drug 
  INNER JOIN pharma_total_sales ON pharma_drug.pharmacy_name = pharma_total_sales.pharmacy_name 
ORDER BY 
  pharma_drug.pharmacy_name, 
  pharma_drug.order_amnt DESC;
