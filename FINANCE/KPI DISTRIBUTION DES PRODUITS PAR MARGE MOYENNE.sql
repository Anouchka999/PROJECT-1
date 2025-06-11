USE toys_and_models;
-- KPI DISTRIBUTION DES PRODUITS PAR MARGE MOYENNE
SELECT 
	productCode,productName,

	productline,
	SUM(priceEach*quantityOrdered) AS CA_par_produit,
	SUM((priceEach -buyprice)*quantityOrdered) as Benefice,
	round(100*SUM((priceEach -buyprice)*quantityOrdered) / SUM(priceEach*quantityOrdered),2) as Taux_Marge,
	round(AVG(priceEach) - buyprice,2) as marge_moyenne_produit, 
	NTILE(5) OVER(PARTITION BY productLine ORDER BY round(AVG(priceEach) - buyprice,2)) ntileValue_avg_marge
FROM infos_CA
GROUP BY productCode, productline
ORDER BY ntileValue_avg_marge; 
