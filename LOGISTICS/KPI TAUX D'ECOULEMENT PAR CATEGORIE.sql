USE toys_and_models;
-- KPI TAUX D'ECOULEMENT PAR CATEGORIE
with seuil_critique as (
SELECT	p.productLine, 
        od.orderDate,
        SUM(o.quantityOrdered) as TotalOrder,
        SUM(p.quantityInStock) as TotalStock
FROM orders AS od
INNER JOIN orderdetails AS o
ON o.orderNumber = od.orderNumber
inner join products AS p
ON p.productCode=o.productCode
GROUP BY p.productLine,od.orderDate)
select s.productLine, 
        s.orderDate,
         s.TotalOrder,
        s.TotalStock,
        round(TotalStock /TotalOrder, 2) as ratio_stock_order,
        case when TotalStock < TotalOrder *0.5 THEN "urgent"
        when TotalStock < TotalOrder*0.8 THEN "à_surveiller"
        else "leger" end as etat_seuil_critique
from seuil_critique s
ORDER BY TotalOrder desc;