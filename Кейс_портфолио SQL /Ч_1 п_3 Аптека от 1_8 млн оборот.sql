-- 1. Выбираем название аптеки и считаем сумму продаж (price * count) для каждой аптеки
SELECT 
  pharmacy_name, 
  SUM(price * count) AS total_sales 
FROM 
  pharma_orders -- 2. Группируем данные по аптекам, чтобы суммировать продажи каждой аптеки
GROUP BY 
  pharmacy_name -- 3. Фильтруем только те аптеки, у которых общая сумма продаж превышает 1.8 млн
HAVING 
  SUM(price * count) > 1800000 -- 4. Сортируем результат по названию аптеки
ORDER BY 
  pharmacy_name;
