USE toys_and_models;
-- KPI CHIFFRE D'AFFAIRE PAR EMPLOYE 
SELECT employees.employeeNumber, employees.lastName, employees.firstName, employees.jobTitle, SUM(quantityOrdered*priceEach) AS CA, ROUND(SUM(quantityOrdered*priceEach)*100/(SELECT SUM(quantityOrdered*priceEach)
	FROM employees
		JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
		JOIN orders USING(customerNumber) 
		JOIN orderdetails USING(orderNumber)
WHERE orders.status = 'Shipped')) AS Perc_CA_par_Employee, COUNT(customers.customerNumber) AS Nbr_client, MAX(orders.orderDate) AS Derniere_commande
FROM employees
	LEFT JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
	LEFT JOIN orders USING(customerNumber)
	LEFT JOIN orderdetails USING(orderNumber)
WHERE orders.status = 'Shipped' OR salesRepEmployeeNumber IS NULL AND jobTitle = 'Sales Rep'
GROUP BY employees.employeeNumber
ORDER BY SUM(quantityOrdered*priceEach) DESC;
