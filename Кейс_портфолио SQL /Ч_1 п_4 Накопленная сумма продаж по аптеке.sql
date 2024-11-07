- 1. Выбираем название аптеки и считаем сумму продаж для каждой строки заказа
SELECT 
  pharmacy_name, 
  report_date, 
  SUM(price * count) AS daily_sales, 
  -- Считаем дневные продажи
  -- 2. Используем оконную функцию для вычисления накопленной суммы продаж по каждой аптеке
  SUM(
    SUM(price * count)
  ) OVER (
    PARTITION BY pharmacy_name 
    ORDER BY 
      report_date ASC
  ) AS cumulative_sales 
FROM 
  pharma_orders -- 3. Группируем данные по аптеке и дате отчета, чтобы получить сумму продаж за день
GROUP BY 
  pharmacy_name, 
  report_date -- 4. Сортируем данные для корректного отображения накопленной суммы
ORDER BY 
  pharmacy_name, 
  report_date;
