SELECT 
    drug, 
    SUM(price * count) AS total_sales
FROM 
    pharma_orders
GROUP BY 
    drug
ORDER BY 
    total_sales DESC
LIMIT 3;
