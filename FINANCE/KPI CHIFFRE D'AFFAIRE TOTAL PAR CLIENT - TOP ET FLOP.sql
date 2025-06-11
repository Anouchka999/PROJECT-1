USE toys_and_models;
-- KPI CHIFFRE D'AFFAIRE TOTAL PAR CLIENT - TOP ET FLOP
SELECT 
	c.customerName,
	SUM(od.priceEach*od.quantityOrdered) AS total_rev_by_customer
FROM customers c
JOIN
	orders o
	ON o.customerNumber = c.customerNumber
JOIN orderdetails od
	ON od.orderNumber = o.orderNumber
GROUP BY 
	c.customerName	
ORDER BY total_rev_by_customer
LIMIT 5;


