USE toys_and_models;
-- KPI CHIFFRE D'AFFAIRE MOYEN PAR CLIENT
WITH avg_payment AS (
	SELECT 
		AVG(amount) AS moyenne_entreprise
    FROM payments
),
montant_by_client  AS(
	SELECT
    customerName, SUM(amount) AS Total_client
	FROM
    payments 
    JOIN 
	customers USING (customerNumber)
    GROUP BY 
		customerName)
SELECT
	customerName AS Client,
	Total_client,
	round(moyenne_entreprise,2) AS Moyenne_Entreprise,
	round(moyenne_entreprise,2)- Total_client as Difference,
    100*(round((moyenne_entreprise- Total_client)/moyenne_entreprise,2)) AS Taux
FROM
	montant_by_client, avg_payment
WHERE 
	total_client < moyenne_entreprise;
