USE toys_and_models;
-- KPI  TAUX D'EVOLUTION PAR CATEGORIE ET PAR TERRITOIRE
WITH evolution AS (
    SELECT 
        p.productLine,
          CONCAT(YEAR(o.orderDate),' Q', QUARTER(o.orderDate)) AS quarter_year,
       --  DATE_FORMAT(o.orderDate, '%Y-%m') AS mois,
        SUM(od.priceEach * od.quantityOrdered) AS total_ventes,
        LAG(SUM(od.priceEach * od.quantityOrdered)) OVER (
            PARTITION BY p.productLine 
        ) AS ventes_precedentes
    FROM 
        orders o
    JOIN 
        orderdetails od ON o.orderNumber = od.orderNumber
    JOIN 
        products p ON od.productCode = p.productCode
    GROUP BY 
        p.productLine, quarter_year
)

SELECT 
    productLine,
    quarter_year,
    total_ventes,
    ROUND(
        (total_ventes - ventes_precedentes) / NULLIF(ventes_precedentes, 0) * 100, 2
    ) AS taux_evolution
FROM evolution
ORDER BY productLine, quarter_year;