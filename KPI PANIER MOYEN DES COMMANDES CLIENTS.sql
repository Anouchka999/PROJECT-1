USE toys_and_models;
-- KPI PANIER MOYEN DES COMMANDES CLIENTS
SELECT 
    CONCAT(YEAR(orderDate), ' Q', QUARTER(orderDate)) AS quarter,
    SUM(quantityOrdered * priceEach) AS ca,
    CASE
        WHEN off.territory = 'EMEA' THEN 'Europe, Moyen Orient, Afrique'
        WHEN off.territory = 'NA' THEN 'Amerique du Nord'
        WHEN off.territory = 'APAC' THEN 'Asie Pacific'
        WHEN off.territory = 'JAPAN' THEN 'Japon' 
        ELSE 'Other'
    END AS territory ,
    ROUND(SUM(quantityOrdered * priceEach) / COUNT(DISTINCT od.orderNumber), 2) AS panier_moy
FROM orderdetails AS od
INNER JOIN orders AS o ON od.orderNumber = o.orderNumber
LEFT JOIN customers AS c ON c.customerNumber = o.customerNumber 
INNER JOIN employees AS e ON e.employeeNumber = c.salesRepEmployeeNumber
INNER JOIN offices AS off ON off.officeCode = e.officeCode
INNER JOIN products AS p ON od.productCode = p.productCode
GROUP BY quarter, territory
ORDER BY quarter;