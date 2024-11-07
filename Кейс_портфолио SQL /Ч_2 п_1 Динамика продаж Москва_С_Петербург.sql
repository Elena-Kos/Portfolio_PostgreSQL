-- Определяем суммарные продажи по месяцам для Москвы
WITH sales_moscow AS (
  SELECT 
    pharmacy_name, 
    TO_CHAR(
      DATE_TRUNC('day', report_date :: DATE), 
      'YYYY.MM'
    ) AS day, 
    -- Форматируем дату
    SUM(price * count) AS total_sales 
  FROM 
    pharma_orders 
  WHERE 
    city = 'Москва' 
  GROUP BY 
    pharmacy_name, 
    day
), 
-- Определяем суммарные продажи по месяцам для Санкт-Петербурга
sales_spb AS (
  SELECT 
    pharmacy_name, 
    TO_CHAR(
      DATE_TRUNC('day', report_date :: DATE), 
      'YYYY.MM'
    ) AS day, 
    -- Форматируем дату
    SUM(price * count) AS total_sales 
  FROM 
    pharma_orders 
  WHERE 
    city = 'Санкт-Петербург' 
  GROUP BY 
    pharmacy_name, 
    day
), 
-- Объединяем данные по продажам для Москвы и Санкт-Петербурга
sales_comparison AS (
  SELECT 
    m.pharmacy_name, 
    m.day AS m_day, 
    m.total_sales AS m_sales, 
    COALESCE(s.total_sales, 0) AS spb_sales -- Заменяем NULL на 0
  FROM 
    sales_moscow m 
    LEFT JOIN sales_spb s ON m.pharmacy_name = s.pharmacy_name 
    AND m.day = s.day
) -- Вычисляем разницу в продажах по месяцам в процентах
SELECT 
  pharmacy_name, 
  m_day, 
  m_sales, 
  spb_sales, 
  CASE WHEN spb_sales = 0 THEN NULL ELSE ROUND(
    (
      (m_sales - spb_sales) / NULLIF(spb_sales, 0):: NUMERIC
    ) * 100, 
    2
  ) END AS sales_difference_percentage 
FROM 
  sales_comparison 
ORDER BY 
  pharmacy_name, 
  m_day;
