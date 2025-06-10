USE toys_and_models;
-- KPI CHIFFRE D'AFFAIRES PAR BUREAU
SELECT 
    offices.officeCode,
    offices.city,
    SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS officeRevenue,
    CONCAT(YEAR(orders.orderDate),' Q', QUARTER(orders.orderDate)) AS quarter_year
FROM 
    offices
JOIN 
    employees ON offices.officeCode = employees.officeCode
JOIN 
    customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
JOIN 
    orders ON orders.customerNumber = customers.customerNumber
JOIN 
    orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY 
    offices.officeCode, offices.city, quarter_year 
    ORDER BY 
    quarter_year ASC, officeRevenue DESC;