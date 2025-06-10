USE toys_and_models;
-- KPI CHIFFRE D'AFFAIRES PAR TRIMESTRE ET PAR TERRITOIRE + TAUX D'EVOLUTION 
SELECT 
    CONCAT( YEAR(STR_TO_DATE(CONCAT(ca1.year_and_month, '-01'), '%Y-%m-%d')), ' Q', QUARTER(STR_TO_DATE(CONCAT(ca1.year_and_month, '-01'), '%Y-%m-%d'))) AS quarter_year,
    ca1.ca,
      CASE
        WHEN ca1.territory = 'EMEA' THEN 'Europe, Moyen Orient, Afrique'
        WHEN ca1.territory = 'NA' THEN 'Amerique du Nord'
        WHEN ca1.territory = 'APAC' THEN 'Asie Pacific'
        WHEN ca1.territory = 'JAPAN' THEN 'Japon' 
        ELSE 'Other'
    END AS territory,
  --   ca2.ca AS vs_prev_month,
    ifnull(ROUND(((ca1.ca - ca2.ca) / NULLIF(ca2.ca, 0)) * 100, 0) ,0) AS evolution_rate
FROM (
   SELECT SUM(od.priceEach * od.quantityOrdered) AS ca, off.territory,
       DATE_FORMAT(date(o.orderdate), '%Y-%m') AS year_and_month
       FROM orders as o
       INNER JOIN orderdetails AS od
       ON od.orderNumber = o.orderNumber
       INNER JOIN customers as c
       ON c.customerNumber = o.customerNumber 
       INNER JOIN employees AS e
       ON e.employeeNumber = c.salesRepEmployeeNumber
       INNER JOIN offices AS off
       ON off.officeCode = e.officeCode
       GROUP BY year_and_month, off.territory
       ORDER BY year_and_month ASC
) 
AS ca1
LEFT JOIN (
     SELECT SUM(od.priceEach * od.quantityOrdered) AS ca, off.territory, 
        DATE_FORMAT(DATE_ADD(o.orderDate, INTERVAL 1 MONTH), '%Y-%m') AS year_and_month
       FROM orders as o
       INNER JOIN orderdetails AS od
       ON od.orderNumber = o.orderNumber
       INNER JOIN customers as c
       ON c.customerNumber = o.customerNumber 
       INNER JOIN employees AS e
       ON e.employeeNumber = c.salesRepEmployeeNumber
       INNER JOIN offices AS off
       ON off.officeCode = e.officeCode
       GROUP BY year_and_month, off.territory
       ORDER BY year_and_month ASC
) 
AS ca2 
ON ca1.territory = ca2.territory
AND ca1.year_and_month = ca2.year_and_month
ORDER BY ca1.territory ASC, ca1.year_and_month ASC;