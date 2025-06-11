USE toys_and_models;
-- KPI RATIO DE COMMANDES/PAIEMENTS PAR REPRESENTANT COMMERCIAL
with cte as (
SELECT sum(p.amount) as paiement_representant,c.contactLastName
FROM customers as c
inner join payments as p on p.customerNumber = c.customerNumber
group by c.contactLastName),
commande as (select c.contactLastName,sum((od.quantityOrdered)*(od.priceEach)) as ca_commande
FROM orderdetails AS od
INNER JOIN orders as o ON o.orderNumber = od.orderNumber
inner join customers as c on o.customerNumber = c.customerNumber
group by c.contactLastName)
select cte.contactLastName,(paiement_representant * 100 / ca_commande) as taux_payment,
case when (paiement_representant * 100 / ca_commande) = 100 THEN 'Réglé'
     when (paiement_representant * 100 / ca_commande)> 90 THEN 'En retard'
     when (paiement_representant * 100 / ca_commande) < 89 THEN 'Non réglé'
     end as etat_paiement
from cte
 join commande using(contactLastName)
order by taux_payment desc;