USE toys_and_models;
-- KPI CLIENTS EN RECOUVREMENT - MONTANT TOTAL DU/CLIENT
WITH CA_ordered_by_cust AS 
	(SELECT c.customerName,
			c.customerNumber,
			priceEach,
			quantityOrdered,
            creditLimit,
			SUM(amount) AS total_payment_by_customer
	FROM customers c
		JOIN orders o
			USING(customerNumber)
	JOIN orderdetails od
			USING(orderNumber)
	JOIN payments
			USING(customerNumber)
	WHERE amount IS NOT null AND (year(o.orderDate) BETWEEN YEAR(now())-3 AND year(now())-1)
        GROUP BY c.customerName, c.customerNumber,priceEach,
			quantityOrdered)
        
SELECT customerName AS Client,
	-- SUM(priceEach*quantityOrdered) AS Total_CA_par_client, 
    creditLimit,
	SUM(priceEach*quantityOrdered) - total_payment_by_customer as Difference, --
    round(100*(SUM(priceEach*quantityOrdered) - total_payment_by_customer) / creditLimit,2) AS Taux_rec
FROM CA_ordered_by_cust ca
GROUP BY customerName, total_payment_by_customer, creditLimit
HAVING Difference > 0
ORDER BY Difference DESC; 

