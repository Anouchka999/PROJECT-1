USE toys_and_models;
-- KPI CROISSANCE DES VENTES PAR TRIMESTRE 
WITH cte AS (SELECT country, SUM(priceEach *quantityOrdered) AS CA_total,
CASE
	-- WHEN MONTH(orderdate) BETWEEN 1 and 3 THEN 'Q1', -- YEAR(date)
    WHEN MONTH(orderdate) BETWEEN 1 and 3 THEN CONCAT(YEAR(orderdate)," ","Q1")
	WHEN MONTH(orderdate) BETWEEN 4 and 6 THEN CONCAT(YEAR(orderdate)," ","Q2")
	WHEN MONTH(orderdate) BETWEEN 7 and 9 THEN CONCAT(YEAR(orderdate)," ","Q3")
	WHEN MONTH(orderdate) BETWEEN 10 and 12 THEN CONCAT(YEAR(orderdate), " ","Q4")
 END AS Croissance_par_trimestre
 FROM infos_payments
 group by country, Croissance_par_trimestre)
 
-- Croissance des ventes par trimestre 
 SELECT cte.country, SUM(cte.CA_total) AS Total_CA_pays, Croissance_par_trimestre
 FROM cte
 GROUP BY  cte.country, Croissance_par_trimestre
 ORDER BY Croissance_par_trimestre DESC;
