USE toys_and_models;
-- KPI TAUX D'ECOULEMENT DES STOCKS
SELECT productLine, 
               productVendor, 
               shippedDate, 
               sum(od.quantityOrdered) as somme_commande,
               sum(quantityInStock) AS quantite_stock,          
               sum(od.quantityOrdered)/AVG(quantityInStock) AS taux_ecoulement
FROM orders AS o
        INNER JOIN orderdetails AS od
ON  o.orderNumber= od.orderNumber
        INNER JOIN products AS p
ON od.productCode = p.productCode
WHERE shippedDate like '2023%'
group by productLine,
productVendor,
shippedDate 
ORDER BY quantite_stock asc ;
