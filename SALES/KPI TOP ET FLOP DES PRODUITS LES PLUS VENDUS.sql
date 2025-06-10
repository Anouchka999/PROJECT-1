USE toys_and_models;
-- REQUETE TOP AND FLOP DES PRODUITS VENDUS 
SELECT 
   productName,
   productLine,
   CASE
        WHEN off.territory = 'EMEA' THEN 'Europe, Moyen Orient, Afrique'
        WHEN off.territory = 'NA' THEN 'Amerique du Nord'
        WHEN off.territory = 'APAC' THEN 'Asie Pacific'
        WHEN off.territory = 'JAPAN' THEN 'Japon' 
        ELSE 'Other'
    END AS territory,
    SUM(quantityordered) AS total_sold,
    CONCAT(YEAR(o.orderdate), ' Q', QUARTER(o.orderdate)) AS year_quarter
    FROM Products as p 
    INNER JOIN orderdetails as od
        USING(productcode)
    INNER JOIN orders as o
       USING(ordernumber)
    INNER JOIN customers as c
       USING(customerNumber)
    INNER JOIN employees as e
        ON c.salesRepEmployeeNumber = e.employeeNumber
    INNER JOIN offices as off
        USING(officeCode)
GROUP BY year_quarter, productline, productName, territory;