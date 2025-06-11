USE toys_and_models;
-- KPI CONSOMMATION DES STOCKS PAR MOIS 
WITH stock_par_mois AS (
SELECT p.productLine, o.shippedDate, 
sum(od.quantityOrdered) as commande_total,sum(p.quantityInStock) AS total_stock, sum(od.quantityOrdered)/AVG(p.quantityInStock) AS taux_ecoulement
FROM orders AS o
INNER JOIN orderdetails AS od
ON o.orderNumber= od.orderNumber
INNER JOIN products AS p
ON od.productCode = p.productCode
group by p.productLine,o.shippedDate 
ORDER BY total_stock asc)
select productLine, shippedDate,
total_stock,round(lag(commande_total) over(order by shippedDate)) as commandes_precedentes,
round(lag(total_stock) over(order by shippedDate)) as stock_precedent,commande_total,
round((commande_total - lag(commande_total) over(order by shippedDate))*100 /NULLIF(lag(commande_total) over(order by shippedDate),0)) as variation_relative_commande, 
round((total_stock- lag(total_stock) over(order by shippedDate)) *100 /NULLIF(lag(total_stock) over(order by shippedDate),0))  as variation_relative_stock
from stock_par_mois
where shippedDate like '%2023%';
