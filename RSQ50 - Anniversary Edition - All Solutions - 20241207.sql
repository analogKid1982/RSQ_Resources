/*

Excerpts from
Real SQL Queries: 50 Challenges
Third Edition (Anniversary Edition)
by Brian Cohen
© 2024 Belmont River Press, LLC
All rights reserved.

Additional resources available at RSQ50.com                     

-----------------------------------------------------------------------
-----------------------------------------------------------------------

╔═══╗─────╔╗─╔═══╦═══╦╗───╔═══╗
║╔═╗║─────║║─║╔═╗║╔═╗║║───║╔═╗║
║╚═╝╠══╦══╣║─║╚══╣║─║║║───║║─║╠╗╔╦══╦═╦╦══╦══╗
║╔╗╔╣║═╣╔╗║║─╚══╗║║─║║║─╔╗║║─║║║║║║═╣╔╬╣║═╣══╣
║║║╚╣║═╣╔╗║╚╗║╚═╝║╚═╝║╚═╝║║╚═╝║╚╝║║═╣║║║║═╬══║
╚╝╚═╩══╩╝╚╩═╝╚═══╩══╗╠═══╝╚══╗╠══╩══╩╝╚╩══╩══╝
────────────────────╚╝───────╚╝

The questions for these solutions are available by purchasing the book linked at RSQ50.com.  */

-----------------------------------------------------------------------
-----------------------------------------------------------------------

-- 1.  Solution to Challenge Question "Needy Accountant"

USE AdventureWorks2022;

SELECT
	Country =		c.[Name]			
	,MaxTaxRate =	MAX (s.TaxRate)
FROM Sales.SalesTaxRate AS s
INNER JOIN Person.StateProvince AS sp 
	ON s.StateProvinceID = sp.StateProvinceID
INNER JOIN Person.CountryRegion AS c 
	ON sp.CountryRegionCode = c.CountryRegionCode
GROUP BY c.[Name];
---------------------------------------------------------------------------
-- 2.  Solution 1 to Challenge Question "Illustrations Needed"

USE AdventureWorks2022;

SELECT p.ProductModelID, ProductModelName = p.[Name]
FROM Production.ProductModel AS p
LEFT JOIN Production.ProductModelIllustration AS i
	ON p.ProductModelID = i.ProductModelID
WHERE i.IllustrationID IS NULL
ORDER BY ProductModelID;
---------------------------------------------------------------------------
-- 2.  Solution 2 to Challenge Question "Illustrations Needed"

USE AdventureWorks2022;

SELECT p.ProductModelID, ProductModelName = p.[Name]
FROM Production.ProductModel AS p
WHERE NOT EXISTS (SELECT 1 
				  FROM Production.ProductModelIllustration AS X1
				  WHERE p.ProductModelID = X1.ProductModelID
					AND X1.IllustrationID IS NOT NULL)
ORDER BY ProductModelID;
---------------------------------------------------------------------------
-- 3.  Solution to Challenge Question "Who Left That Review?"

USE AdventureWorks2022;

SELECT
	pr.ProductReviewID
	,pr.ProductID
	,ProductName =		p.[Name]
	,pr.ReviewerName
	,pr.Rating
	,ReviewerEmail =	   pr.EmailAddress
	,a.BusinessEntityID
FROM Production.ProductReview AS pr
LEFT JOIN Person.EmailAddress AS a 
	ON pr.EmailAddress = a.EmailAddress
LEFT JOIN Production.Product AS p 
	ON pr.ProductID = p.ProductID;

-- Execution returns each BusinessEntityID as NULL. It was not possible to locate sales orders related to product reviews because there were no matches.
---------------------------------------------------------------------------
-- 4.  Solution 1 to Challenge Question "Hire Dates for NDA"

USE AdventureWorks2022;

SELECT 
	p.FirstName
	,p.LastName
	,e.JobTitle
	,e.HireDate
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p 
	ON e.BusinessEntityID = p.BusinessEntityID
WHERE CurrentFlag = 1 AND YEAR (e.HireDate) NOT BETWEEN 2008 AND 2011 
ORDER BY HireDate;
---------------------------------------------------------------------------
-- 4.  Solution 2 to Challenge Question "Hire Dates for NDA"

USE AdventureWorks2022;

SELECT 
	p.FirstName
	,p.LastName
	,e.JobTitle
	,e.HireDate
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p 
	ON e.BusinessEntityID = p.BusinessEntityID
WHERE CurrentFlag = 1 AND (YEAR (e.HireDate) < 2008 OR YEAR (e.HireDate) > 2011)	  
ORDER BY HireDate;
---------------------------------------------------------------------------
-- 5.  Solution to Challenge Question "Products in Yellow?" 

USE AdventureWorks2022;

SELECT 
	ProductID
	,ProductName = [Name]
FROM Production.Product
WHERE FinishedGoodsFlag = 1
	AND Color = 'Yellow'; -- despite the red font.
---------------------------------------------------------------------------
-- 6.  Solution 1 to Challenge Question "Products and their Subcategories"

USE AdventureWorks2022;

SELECT
   p.ProductID
   ,SubCategory =  psc.[Name] 
   ,ProductName =  p.[Name] 
FROM Production.Product AS p
INNER JOIN Production.ProductSubcategory AS psc 
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
WHERE FinishedGoodsFlag = 1
ORDER BY SubCategory;
---------------------------------------------------------------------------
-- 6.  Solution 2 to Challenge Question "Products and their Subcategories"

USE AdventureWorks2022;

SELECT
    p.ProductID
	
    ,SubCategory = (SELECT TOP 1 [Name]
					 FROM Production.ProductSubcategory AS X1
					 WHERE p.ProductSubcategoryID = X1.ProductSubcategoryID)

	,ProductName =	 p.[Name] 
FROM Production.Product AS p
WHERE FinishedGoodsFlag = 1
ORDER BY SubCategory;
---------------------------------------------------------------------------
-- 7.  Solution to Challenge Question "Total Sales by Territory"

USE AdventureWorks2022;

SELECT
   st.TerritoryID
   ,TerritoryName =  st.[Name] 
   ,Country =		 st.CountryRegionCode  
   ,Sales =		     SUM (s.SubTotal)  
   ,Taxes =		     SUM (s.TaxAmt)     
FROM Sales.SalesOrderHeader AS s
INNER JOIN Sales.SalesTerritory AS st 
    ON s.TerritoryID = st.TerritoryID
GROUP BY st.TerritoryID, st.[Name], st.CountryRegionCode
ORDER BY TerritoryName;
---------------------------------------------------------------------------
-- 8.  Solution to Challenge Question "Email Marketing Campaign"

USE AdventureWorks2022;

SELECT
    c.CustomerID
    ,p.FirstName
    ,p.LastName
    ,e.EmailAddress
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p 
    ON c.PersonID = p.BusinessEntityID
INNER JOIN Person.EmailAddress AS e 
    ON p.BusinessEntityID = e.BusinessEntityID
ORDER BY LastName, FirstName;
---------------------------------------------------------------------------
-- 9.  Solution 1 to Challenge Question "Special Offers" 

USE AdventureWorks2022;

SELECT
	s.SpecialOfferID
	,s.[Description] 
	,s.EndDate
FROM Sales.SpecialOffer AS s
LEFT JOIN Sales.SpecialOfferProduct AS sp 
	ON s.SpecialOfferID = sp.SpecialOfferID
WHERE sp.SpecialOfferID IS NULL 
	AND s.DiscountPct > 0
	AND s.EndDate > '2014-01-01';
---------------------------------------------------------------------------
-- 9.  Solution 2 to Challenge Question "Special Offers" 

USE AdventureWorks2022;

SELECT
	SpecialOfferID
	,[Description] 
	,EndDate
FROM Sales.SpecialOffer AS s
WHERE s.DiscountPct > 0
	AND s.EndDate > '2014-01-01'
	AND NOT EXISTS (SELECT 1 
			        FROM Sales.SpecialOfferProduct AS X1
				    WHERE s.SpecialOfferID = X1.SpecialOfferID);
---------------------------------------------------------------------------
-- 9.  Solution 3 to Challenge Question "Special Offers" 

USE AdventureWorks2022;

SELECT
	s.SpecialOfferID
	,s.[Description]
	,s.EndDate
FROM Sales.SpecialOffer AS s
WHERE 1 = 1
	AND EndDate > '2014-01-01'
	AND SpecialOfferID NOT IN (SELECT SpecialOfferID FROM Sales.SpecialOfferProduct);
---------------------------------------------------------------------------
-- 10.  Solution to Challenge Question "Work Orders"        

USE AdventureWorks2022;

SELECT
	w.ProductID
	,ProductName = p.[Name]
	,WorkOrders =  COUNT (*)
FROM Production.WorkOrder AS w
INNER JOIN Production.Product AS p 
	ON w.ProductID = p.ProductID
GROUP BY w.ProductID, p.[Name]
ORDER BY WorkOrders DESC;
---------------------------------------------------------------------------
-- 11.  Solution to Challenge Question "The Translators"  

USE AdventureWorks2022;

SELECT 
	pdc.ProductModelID
	,ProductModel =		pm.[Name]
	,pd.[Description]
	,[Language] =		c.[Name]
FROM Production.ProductModelProductDescriptionCulture AS pdc
INNER JOIN Production.Culture AS c
	ON pdc.CultureID = c.CultureID
INNER JOIN Production.ProductDescription AS pd
	ON pdc.ProductDescriptionID = pd.ProductDescriptionID
INNER JOIN Production.ProductModel AS pm 
	ON pdc.ProductModelID = pm.ProductModelID
WHERE ISNULL (c.[Name], 'x') <> 'English';
---------------------------------------------------------------------------
-- 12.  Solution to Challenge Question "The 2/22 Promotion"

USE AdventureWorks2022;

-- Part I
DROP TABLE IF EXISTS #data;
GO

SELECT
	s.SalesOrderID
	,ShipToState =			sp.[Name]
	,OrderDate =			CAST (s.OrderDate AS DATE)
	,[HistoricalOrder$] =	s.SubTotal
	,HistoricalFreight =	s.Freight

	,PotentialPromoEffect =	
       CASE
           WHEN s.SubTotal > = 1700 AND s.SubTotal < 2000	
				    THEN 'INCREASE ORDER TO $2,000 & PAY 22 CENTS FREIGHT'
				WHEN s.Subtotal > = 2000						
					 THEN 'NO ORDER CHANGE AND PAY 22 CENTS FREIGHT'
				ELSE 'NO ORDER CHANGE & PAY HISTORICAL FREIGHT' 
		 END

	,PotentialOrderGain =	
       CASE 
          WHEN s.SubTotal > = 1700 AND s.SubTotal < 2000 
             THEN 2000 - s.SubTotal ELSE 0 
       END
	
   ,PotentialFreightLoss =	
       CASE WHEN s.SubTotal > =  1700 
              THEN 0.22 ELSE s.Freight END - s.Freight

	,[PromoNetGain/Loss] =	
       CASE WHEN s.SubTotal > = 1700 AND s.SubTotal < 2000 
               THEN 2000 - s.SubTotal ELSE 0 END 
			+ 
			
       CASE WHEN s.SubTotal > =  1700 
               THEN 0.22 ELSE s.Freight END - s.Freight 

INTO #data
FROM Sales.SalesOrderHeader AS s
INNER JOIN Person.BusinessEntityAddress AS ba 
	ON s.ShipToAddressID = ba.AddressID
INNER JOIN Person.[Address] a 
	ON ba.AddressID = a.AddressID
INNER JOIN Person.StateProvince sp 
	ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.[Name] = 'California' 
	AND YEAR (DATEADD (MONTH, 6, OrderDate)) = 2014;

SELECT * 
FROM #data;

--	Part II
SELECT 
    PotentialPromoEffect =		
       CASE 
          WHEN GROUPING_ID (PotentialPromoEffect) = 1 
              THEN 'Total' 
          ELSE PotentialPromoEffect 
        END

	,PotentialOrderGains =		SUM (PotentialOrderGain)
	,PotentialFreightLosses =	SUM (PotentialFreightLoss)
	,OverallNet =				SUM ([PromoNetGain/Loss])
FROM #data
GROUP BY ROLLUP (PotentialPromoEffect)
ORDER BY PotentialPromoEffect, OverallNet DESC;
---------------------------------------------------------------------------
-- 13.  Solution to Challenge Question "Vendor Credit Ratings"   

USE AdventureWorks2022;

SELECT 
	PreferredVendorStatus =		
      CASE 
         WHEN PreferredVendorStatus = 0 
            THEN 'Vendor Not Preferred' 
         ELSE 'Vendor Preferred' 
       END
	
   ,ActiveFlag =	
      CASE 
         WHEN ActiveFlag = 0 
            THEN 'Vendor Not Active' 
         ELSE 'Vendor Active' 
      END
	
,AvgCreditRating =	AVG (CONVERT (FLOAT, CreditRating))

FROM Purchasing.Vendor
GROUP BY 
	CASE 
         WHEN PreferredVendorStatus = 0 
            THEN 'Vendor Not Preferred' 
         ELSE 'Vendor Preferred' 
       END

  ,CASE 
         WHEN ActiveFlag = 0 
            THEN 'Vendor Not Active' 
         ELSE 'Vendor Active' 
      END;
---------------------------------------------------------------------------
-- 14.  Solution 1 for Challenge Question "Transaction History"

USE AdventureWorks2022;

SELECT
	[Table] = 'Transaction History Archive'
	,TransIDBegin =	MIN (TransactionID)
	,TransIDEnd =	MAX (TransactionID)
FROM Production.TransactionHistoryArchive

UNION 

SELECT
	[Table] = 'Transaction History'
	,TransIDBegin =	MIN (TransactionID)
	,TransIDEnd =	MAX (TransactionID)
FROM Production.TransactionHistory
ORDER BY [Table] DESC;
---------------------------------------------------------------------------
-- 14.  Solution 2 for Challenge Question "Transaction History"
USE AdventureWorks2022;

WITH Data1 AS 
	( SELECT [Table] = 'Transaction History Archive', TransactionID
	  FROM Production.TransactionHistoryArchive

	  UNION 

	  SELECT [Table] = 'Transaction History', TransactionID
	  FROM Production.TransactionHistory )

SELECT
	[Table]
	,TransIDStart = MIN (TransactionID)
	,TransIDEnd =	MAX (TransactionID)
FROM Data1
GROUP BY [Table]
ORDER BY [Table] DESC;
---------------------------------------------------------------------------
-- 14. Solution 3 for Challenge Question "Transaction History"
USE AdventureWorks2022;

SELECT 
	[Table] =		'Transaction History Archive'
   ,TransIDStart = (SELECT MIN (TransactionID) FROM Production.TransactionHistoryArchive)  
   ,TransIDEnd =	(SELECT MAX (TransactionID) FROM Production.TransactionHistoryArchive)
FROM Production.TransactionHistoryArchive

UNION 

SELECT 
	[Table] =       'Transaction History'
	,TransIDStart = (SELECT MIN (TransactionID) FROM Production.TransactionHistory)
	,TransIDEnd =	(SELECT MAX (TransactionID) FROM Production.TransactionHistory)
FROM Production.TransactionHistory
ORDER BY [Table] DESC;
---------------------------------------------------------------------------
-- 15.  Solution 1 to Challenge Question "Holiday Bonus"

USE AdventureWorks2022;

SELECT
	e.BusinessEntityID
	,p.FirstName
	,p.LastName
	,e.JobTitle

	,Bonus  =	(SELECT TOP 1 Rate	
				 FROM HumanResources.EmployeePayHistory X1
				 WHERE e.BusinessEntityID = X1.BusinessEntityID
				 ORDER BY RateChangeDate DESC) * 50

FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p 
	ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.SalariedFlag = 1
ORDER BY BusinessEntityID;
---------------------------------------------------------------------------
-- 15.  Solution 2 to Challenge Question "Holiday Bonus"

USE AdventureWorks2022;

SELECT
	e.BusinessEntityID
	,p.FirstName
	,p.LastName
	,e.JobTitle
	,Bonus  =	ph.Rate * 50
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p 
	ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory  AS ph 
	ON e.BusinessEntityID = ph.BusinessEntityID 
		AND ph.RateChangeDate = (SELECT MAX (RateChangeDate)
							     FROM HumanResources.EmployeePayHistory X1
							     WHERE e.BusinessEntityID = X1.BusinessEntityID)
WHERE e.SalariedFlag = 1;
---------------------------------------------------------------------------
-- 15.  Solution 3 to Challenge Question "Holiday Bonus"

USE AdventureWorks2022;

SELECT 
	e.BusinessEntityID
	,p.FirstName
	,p.LastName
	,e.JobTitle 
	,Bonus =	ph.Rate * 50
FROM HumanResources.Employee AS e

INNER JOIN Person.Person AS p 
	ON e.BusinessEntityID = p.BusinessEntityID

INNER JOIN (SELECT BusinessEntityID, MaxDate = MAX (RateChangeDate)
			FROM HumanResources.EmployeePayHistory
			GROUP BY BusinessEntityID) AS max_date
	ON e.BusinessEntityID = max_date.BusinessEntityID  

INNER JOIN HumanResources.EmployeePayHistory AS ph 
	ON max_date.MaxDate = ph.RateChangeDate
		AND max_date.BusinessEntityID = ph.BusinessEntityID

WHERE SalariedFlag = 1
ORDER BY BusinessEntityID;
---------------------------------------------------------------------------
-- 16.  Solution to Challenge Question "Commission Percentages"

USE AdventureWorks2022;

SELECT
	BusinessEntityID
	,CommissionPct
	,Bonus
	,[Rank] = DENSE_RANK () OVER (ORDER BY CommissionPct DESC, Bonus DESC)
FROM Sales.SalesPerson
WHERE CommissionPct > 0;
---------------------------------------------------------------------------
-- 17.  Solution 1 to Challenge Question "Domain\UserName Separation"

USE AdventureWorks2022;

SELECT
	BusinessEntityID
	,LoginID
	,Domain =		LEFT (LoginID, CHARINDEX ('\', LoginID, 1) - 1)
	,UserName =		RIGHT (LoginID, LEN (LoginID) - CHARINDEX ('\', LoginID, 1))
FROM HumanResources.Employee
ORDER BY BusinessEntityID;
---------------------------------------------------------------------------
-- 17.  Solution 2 to Challenge Question "Domain\UserName Separation"

USE AdventureWorks2022;

SELECT
    BusinessEntityID
    ,LoginID
    ,Domain =		SUBSTRING (LoginID, 1, CHARINDEX ('\', LoginID) - 1)
    ,UserName =		SUBSTRING (LoginID, CHARINDEX ('\', LoginID) + 1, LEN (LoginID))
FROM HumanResources.Employee
ORDER BY BusinessEntityID;
---------------------------------------------------------------------------
-- 17.  Solution 3 to Challenge Question "Domain\UserName Separation"

USE AdventureWorks2022;

WITH Data1 AS 
	( SELECT
		BusinessEntityID
		,LoginID
		,s.[value]
		,s.ordinal
	  FROM HumanResources.Employee AS e
	  CROSS APPLY STRING_SPLIT (LoginID, '\', 1) AS s  )

SELECT DISTINCT
	d1.BusinessEntityID
	,d1.LoginID
	,Domain =		domain.[value]
	,UserName =		username.[value]
FROM Data1 AS d1
LEFT JOIN Data1 AS domain 
	ON d1.BusinessEntityID = domain.BusinessEntityID
		AND domain.[value] LIKE 'adventure%'
LEFT JOIN Data1 AS username
	ON d1.BusinessEntityID = username.BusinessEntityID
		AND username.[value] NOT LIKE 'adventure%'
ORDER BY BusinessEntityID;
---------------------------------------------------------------------------
-- 18.  Solution 1 to Challange Question "Loyal Customers" 

USE AdventureWorks2022;

WITH Data1 AS 
	( SELECT CustomerID
      FROM Sales.SalesOrderHeader
	   WHERE SalesPersonID IS NOT NULL
	   GROUP BY CustomerID
	   HAVING COUNT(*) >= 10 
		   AND COUNT (DISTINCT SalesPersonID) = 1 )

SELECT 
    LoyalCustomers =	COUNT (DISTINCT d1.CustomerID) 
	,TotalCustomers =	COUNT (DISTINCT s.CustomerID) 
FROM Sales.SalesOrderHeader AS s
LEFT JOIN Data1 AS d1
	ON s.CustomerID = d1.CustomerID
WHERE s.SalesPersonID IS NOT NULL;
---------------------------------------------------------------------------
-- 18.  Solution 2 to Challange Question "Loyal Customers"  

USE AdventureWorks2022;

SELECT 
	LoyalCustomers =	   COUNT (*)

	,TotalCustomers =	(SELECT COUNT (DISTINCT CustomerID) 
	  					 FROM Sales.SalesOrderHeader
						 WHERE SalesPersonID IS NOT NULL)

FROM (SELECT CustomerID
	   FROM Sales.SalesOrderHeader
	   WHERE SalesPersonID IS NOT NULL
	   GROUP BY CustomerID
	   HAVING COUNT (*) >= 10 
		  AND COUNT (DISTINCT SalesPersonID) = 1) AS X1;
---------------------------------------------------------------------------
-- 18.  Solution 3 to Challange Question "Loyal Customers" 

USE AdventureWorks2022;

WITH 
	TotalCustomers AS  
		( SELECT DISTINCT CustomerID
		  FROM Sales.SalesOrderHeader
		 WHERE SalesPersonID IS NOT NULL)

	,LoyalCustomers AS 
		( SELECT CustomerID
		  FROM Sales.SalesOrderHeader
		  WHERE SalesPersonID IS NOT NULL
		  GROUP BY CustomerID
		  HAVING COUNT(*) >= 10 AND COUNT (DISTINCT SalesPersonID) = 1 )

SELECT 
    LoyalCustomers =  (SELECT COUNT (*) FROM LoyalCustomers)
    ,TotalCustomers = (SELECT COUNT (*) FROM TotalCustomers);

---------------------------------------------------------------------------
-- 19.  Solution 1 to Challenge Question "Revenue Ranges"

USE AdventureWorks2022;

SELECT
	SortID = CASE WHEN TotalDue < 100		   THEN 1
				      WHEN TotalDue < 500	   THEN 2
				      WHEN TotalDue < 1000	   THEN 3
				      WHEN TotalDue < 2500	   THEN 4
				      WHEN TotalDue < 5000	   THEN 5
				      WHEN TotalDue < 10000	   THEN 6			
				      WHEN TotalDue < 50000	   THEN 7
				      WHEN TotalDue < 100000	THEN 8
				      ELSE 9 END

	,SalesAmountCategory =	 CASE WHEN TotalDue < 100		THEN '0 - 100'
								         WHEN TotalDue < 500		THEN '100 - 500'
							  	         WHEN TotalDue < 1000	   THEN '500 - 1,000'
								         WHEN TotalDue < 2500	   THEN '1,000 - 2,500'
							 	         WHEN TotalDue < 5000	   THEN '2,500 - 5,000'
							 	         WHEN TotalDue < 10000	   THEN '5,000 - 10,000'
							 	         WHEN TotalDue < 50000	   THEN '10,000 - 50,000'
							 	         WHEN TotalDue < 100000	THEN '50,000 - 100,000'   
								         ELSE '> 100,000' END

	,Orders	=				COUNT (*)

FROM Sales.SalesOrderHeader
WHERE YEAR (OrderDate) = 2014
GROUP BY                                                                              
	CASE WHEN TotalDue < 100		          THEN 1
				      WHEN TotalDue < 500	  THEN 2
				      WHEN TotalDue < 1000	  THEN 3
				      WHEN TotalDue < 2500	  THEN 4
				      WHEN TotalDue < 5000	  THEN 5
				      WHEN TotalDue < 10000	  THEN 6			
				      WHEN TotalDue < 50000	  THEN 7
				      WHEN TotalDue < 100000  THEN 8
				      ELSE 9 END
	
	,CASE WHEN TotalDue < 100		THEN '0 - 100'
		   WHEN TotalDue < 500		   THEN '100 - 500'
			WHEN TotalDue < 1000	   THEN '500 - 1,000'
			WHEN TotalDue < 2500	   THEN '1,000 - 2,500'
			WHEN TotalDue < 5000	   THEN '2,500 - 5,000'
			WHEN TotalDue < 10000	   THEN '5,000 - 10,000'
			WHEN TotalDue < 50000	   THEN '10,000 - 50,000'
			WHEN TotalDue < 100000	   THEN '50,000 - 100,000'   
			ELSE '> 100,000' END
			
ORDER BY SortID;
---------------------------------------------------------------------------
-- 19.  Solution 2 to Challenge Question "Revenue Ranges"

USE AdventureWorks2022;

DECLARE @RevenueRange    TABLE 
	(SortID					   TINYINT IDENTITY (1,1)
	,SalesAmountCategory  VARCHAR (20)
	,TotalDue				   MONEY);

INSERT @RevenueRange (SalesAmountCategory, TotalDue)
	VALUES 
		('0 - 100',	 100)
		,('100 - 500', 500)
		,('500 - 1,000',	 1000)
		,('1,000 - 2,500', 2500)
		,('2,500 - 5,000', 5000)
		,('5,000 - 10,000',	 10000)
		,('10,000 - 50,000', 50000)
		,('50,000 - 100,000', 100000)
		,('> 100,000' ,1000000000);

SELECT
	r.SortID
	,r.SalesAmountCategory
	,Orders = COUNT (*)
FROM Sales.SalesOrderHeader AS s
INNER JOIN @RevenueRange AS r
	ON r.TotalDue = (SELECT MIN (TotalDue)
				     FROM @RevenueRange AS X1
					 WHERE s.TotalDue < X1.TotalDue)
WHERE OrderDate BETWEEN '2014-01-01' AND '2014-12-31'
GROUP BY r.SortID, r.SalesAmountCategory
ORDER BY SortID;
---------------------------------------------------------------------------
-- 20.  Solution to Challenge Question "Upsell Tuesdays"  

USE AdventureWorks2022;

SELECT 
	[DayofWeek] =		   DATENAME (WEEKDAY, OrderDate)
	,Revenue =			   SUM (Subtotal)
	,Orders =			   COUNT (*)
	,RevenuePerOrder =	   SUM (Subtotal) / COUNT (*)
FROM Sales.SalesOrderHeader
WHERE YEAR (OrderDate) = 2014 AND OnlineOrderFlag = 0
GROUP BY DATENAME (WEEKDAY, OrderDate)
ORDER BY RevenuePerOrder DESC;
---------------------------------------------------------------------------
-- 21.  Solution 1 to Challenge Question "Vacation Hours" 

USE AdventureWorks2022;

WITH MaxVacHrs AS 
	(SELECT MaxVacHrs = MAX (VacationHours) 
	 FROM HumanResources.Employee)

SELECT 
	NationalID =	RIGHT (e.NationalIDNumber, 4)
	,p.FirstName
	,p.LastName
	,e.JobTitle
	,e.VacationHours
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p 
	ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN MaxVacHrs AS m 
	ON e.VacationHours = m.MaxVacHrs
ORDER BY NationalID;
---------------------------------------------------------------------------
-- 21.  Solution 2 to Challenge Question "Vacation Hours"

USE AdventureWorks2022;

DECLARE @MaxVacHrs SMALLINT = (SELECT MAX (VacationHours) 
							   FROM HumanResources.Employee);

SELECT 
	NationalID =	
      SUBSTRING (e.NationalIDNumber, LEN (e.NationalIDNumber) - (4 - 1), 4)
	,p.FirstName
	,p.LastName
	,e.JobTitle
	,e.VacationHours
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p 
	ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.VacationHours = @MaxVacHrs
ORDER BY NationalID;
---------------------------------------------------------------------------
-- 21.  Solution 3 to Challenge Question "Vacation Hours"

USE AdventureWorks2022;

SELECT 
	NationalID =	RIGHT (e.NationalIDNumber, 4)
	,p.FirstName
	,p.LastName
	,e.JobTitle
	,e.VacationHours
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p 
	ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.VacationHours = (SELECT MAX (VacationHours)
				         FROM HumanResources.Employee)
ORDER BY NationalID;
---------------------------------------------------------------------------
-- 21.  Solution 4 to Challenge Question "Vacation Hours"

USE AdventureWorks2022;

SELECT
	X1.NationalID
	,X1.FirstName
	,X1.LastName
	,X1.JobTitle
	,X1.VacationHours
FROM ( SELECT 
         NationalID =	RIGHT (e.NationalIDNumber, 4)
        ,p.FirstName
        ,p.LastName
        ,e.JobTitle
        ,VacationHours

        ,MaxVacHrs = CASE WHEN e.VacationHours = MAX (VacationHours) OVER (ORDER BY VacationHours DESC) 
         THEN e.VacationHours END

	  FROM HumanResources.Employee AS e
	  INNER JOIN Person.Person AS p 
	     ON e.BusinessEntityID = p.BusinessEntityID ) AS X1
WHERE X1.MaxVacHrs IS NOT NULL
ORDER BY NationalID;
---------------------------------------------------------------------------
-- 21.  Solution 5 to Challenge Question "Vacation Hours" 

USE AdventureWorks2022;

DROP TABLE IF EXISTS #data;
GO

SELECT 
	NationalID =	RIGHT (NationalIDNumber, 4)
	,p.FirstName
	,p.LastName
	,e.JobTitle
	,e.VacationHours
	,VacHrsRank =	DENSE_RANK () OVER (ORDER BY VacationHours DESC)
INTO #data
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p 
	ON e.BusinessEntityID = p.BusinessEntityID;

SELECT
	NationalID
	,FirstName
	,LastName
	,JobTitle
	,VacationHours
FROM #data AS d
WHERE VacHrsRank = 1
ORDER BY NationalID;
---------------------------------------------------------------------------
-- 22.  Solution 1 to Challenge Question: "Two Free Bikes"  

USE AdventureWorks2022;

SELECT TOP 2
	p.FirstName
	,p.LastName
	,e.JobTitle
FROM HumanResources.Employee AS e
INNER JOIN Person.Person AS p 
	ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.OrganizationLevel = (SELECT MAX (OrganizationLevel) 
							 FROM HumanResources.Employee)
ORDER BY NEWID ();
---------------------------------------------------------------------------
-- 22.  Solution 2 to Challenge Question: "Two Free Bikes" 

USE AdventureWorks2022;

DECLARE @LeastSeniorLevel TINYINT = (SELECT MAX (OrganizationLevel) 
									 FROM HumanResources.Employee);
SELECT
	p.FirstName
	,p.LastName
	,X1.JobTitle
FROM (SELECT 
		BusinessEntityID
		,JobTitle
		,Random = ROW_NUMBER () OVER (ORDER BY NEWID ())
	  FROM HumanResources.Employee AS e
	  WHERE OrganizationLevel = @LeastSeniorLevel ) AS X1
INNER JOIN Person.Person AS p 
	ON X1.BusinessEntityID = p.BusinessEntityID
WHERE Random IN (1, 2);
---------------------------------------------------------------------------
-- 23.  Solution 1 to Challenge Question "Excess Inventory"     

USE AdventureWorks2022;

SELECT
	sp.SpecialOfferID
	,DiscountType =		[Type]
	,DiscountDescr =	[Description]
	,sp.Category
	,StartDate =		CAST (sp.StartDate AS DATE)
	,EndDate =			CAST (sp.EndDate AS DATE)
	,sp.DiscountPct
	,SalesOrders =		(SELECT COUNT (DISTINCT X1.SalesOrderID)
						 FROM Sales.SalesOrderDetail X1
						 WHERE sp.SpecialOfferID = X1.SpecialOfferID)

FROM Sales.SpecialOffer AS sp
WHERE sp.[Type] = 'Excess Inventory'; 
---------------------------------------------------------------------------
-- 23.  Solution 2 to Challenge Question "Excess Inventory"    

USE AdventureWorks2022;

SELECT
	sp.SpecialOfferID
	,DiscountType =		[Type]
	,DiscountDescr	=	[Description]
	,sp.Category
	,StartDate =		CAST (sp.StartDate AS DATE)
	,EndDate =			CAST (sp.EndDate AS DATE)	,sp.DiscountPct
	,SalesOrders =		COUNT (DISTINCT SalesOrderID)			
FROM Sales.SpecialOffer AS sp
LEFT JOIN Sales.SalesOrderDetail AS sod
	ON sp.SpecialOfferID = sod.SpecialOfferID
WHERE sp.[Type] = 'Excess Inventory'
GROUP BY 
	sp.SpecialOfferID
	,[Type]
	,[Description]
	,sp.Category
	,sp.StartDate
	,sp.EndDate
	,sp.DiscountPct;
---------------------------------------------------------------------------
-- 24.  Solution to Challenge Question "Months Since Last Order"

USE AdventureWorks2022;

WITH Stores AS
	( SELECT
		st.BusinessEntityID
		,s.CustomerID
		,c.StoreID 
		,StoreName =			st.[Name]
		,LastOrderDate =		CAST (MAX (s.OrderDate) AS DATE)
		,MonthsSinceLastOrder =	DATEDIFF (MONTH, MAX (s.OrderDate), '2014-10-07')
	FROM Sales.SalesOrderHeader AS s
	INNER JOIN Sales.Customer AS c 
		ON s.CustomerID = c.CustomerID
	INNER JOIN Sales.Store AS st 
		ON c.StoreID = st.BusinessEntityID
	GROUP BY st.BusinessEntityID, c.StoreID, s.CustomerID, st.[Name] )  

SELECT * 
FROM Stores
WHERE MonthsSinceLastOrder > = 12
ORDER BY MonthsSinceLastOrder DESC;
---------------------------------------------------------------------------
-- 25.  Solution to Challenge Question "Toronto" 

USE AdventureWorks2022;

SELECT  
	AddressType	=		atype.[Name]
	,StoreName =		s.[Name]
	,a.AddressLine1
	,a.AddressLine2
	,a.City
	,StateProvince =	sp.[Name]
	,a.PostalCode
FROM Person.BusinessEntityAddress AS bea
INNER JOIN Person.[Address] AS a 
	ON bea.AddressID = a.AddressID
INNER JOIN Person.AddressType AS atype
	ON bea.AddressTypeID = atype.AddressTypeID
INNER JOIN Sales.Store AS s 
	ON bea.BusinessEntityID = s.BusinessEntityID
INNER JOIN Person.StateProvince AS sp 
	ON a.StateProvinceID = sp.StateProvinceID
WHERE atype.[Name] = 'Main office' 
	AND a.City = 'Toronto';
---------------------------------------------------------------------------
-- 26.  Solution 1 to Challenge Question "Print Catalog"

USE AdventureWorks2022;

SELECT 
	p.ProductID
	,ProductName =	p.[Name]
	,p.Color
	,p.ListPrice
	,pinv.TotalQty
FROM Production.Product AS p
INNER JOIN ( SELECT ProductID, TotalQty = SUM (Quantity) 
			 FROM Production.ProductInventory 
			 GROUP BY ProductID ) AS pinv 
	ON p.ProductID = pinv.ProductID
WHERE p.SellEndDate IS NULL 
		AND pinv.TotalQty > = 150
		AND p.ListPrice > = 1500
		AND p.FinishedGoodsFlag = 1;
---------------------------------------------------------------------------
-- 26.  Solution 2 to Challenge Question "Print Catalog"

USE AdventureWorks2022;

WITH Data1 AS 
	(	SELECT pinv.ProductID, TotalQty = SUM (pinv.Quantity) 
	    FROM Production.ProductInventory AS pinv
		GROUP BY pinv.ProductID ) 

SELECT 
	p.ProductID
	,ProductName =	p.[Name]
	,p.Color
	,p.ListPrice
	,d1.TotalQty
FROM Production.Product AS p
INNER JOIN Data1 AS d1
	ON p.ProductID = d1.ProductID
WHERE p.SellEndDate IS NULL 
		AND d1.TotalQty > = 150
		AND p.ListPrice > = 1500
		AND p.FinishedGoodsFlag = 1;
---------------------------------------------------------------------------
-- 27.  Solution to Challenge Question "Label Mix-Up" 

USE AdventureWorks2022;

SELECT
	sh.SalesOrderID
	,OrderDate =		CAST (sh.OrderDate AS DATE)
	,ProductName =		pr.[Name]
	,p.FirstName
	,p.LastName
	,ph.PhoneNumber
	,e.EmailAddress
FROM Sales.SalesOrderDetail AS s
INNER JOIN Sales.SalesOrderHeader AS sh 
	ON s.SalesOrderID = sh.SalesOrderID
INNER JOIN Production.Product AS pr 
	ON s.ProductID = pr.ProductID
INNER JOIN Production.ProductSubcategory AS ps
	ON pr.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Sales.Customer AS c 
	ON sh.CustomerID = c.CustomerID
INNER JOIN Person.Person AS p 
	ON c.PersonID = p.BusinessEntityID
INNER JOIN Person.PersonPhone AS ph
	ON p.BusinessEntityID = ph.BusinessEntityID
INNER JOIN Person.EmailAddress AS e
	ON p.BusinessEntityID = e.BusinessEntityID
WHERE 1 = 1
	AND sh.OrderDate > '2013-07-07'
	AND sh.OnlineOrderFlag = 1
	AND ps.[Name] = 'Shorts'
	AND pr.Style = 'W'
ORDER BY s.SalesOrderID;
---------------------------------------------------------------------------
-- 28.  Solution 1 to Challenge Question "Phone Number Types"

USE AdventureWorks2022;

DECLARE @Total FLOAT = (SELECT COUNT (*) 
					    FROM Person.PersonPhone AS p 
						INNER JOIN Person.PhoneNumberType AS t 
						   ON p.PhoneNumberTypeID = t.PhoneNumberTypeID);
SELECT
	PhoneNumberType =	t.[Name]
	,[Count] =			COUNT (*) 
	,TotalAllTypes =	@Total
	,PercentTotal =		ROUND (COUNT (*) / @Total * 100, 1)
FROM Person.PersonPhone AS p 
INNER JOIN Person.PhoneNumberType AS t 
	ON p.PhoneNumberTypeID = t.PhoneNumberTypeID
GROUP BY t.[Name] 
ORDER BY [Count] DESC;
---------------------------------------------------------------------------
-- 28.  Solution 2 to Challenge Question "Phone Number Types"

USE AdventureWorks2022;

WITH Data1 AS 
	( SELECT Total = CONVERT (FLOAT, COUNT (*)) 
	  FROM Person.PersonPhone AS p 
	  INNER JOIN Person.PhoneNumberType AS t 
		  ON p.PhoneNumberTypeID = t.PhoneNumberTypeID )
SELECT
	PhoneNumberType =	t.[Name]
	,[Count] =			COUNT (*) 
	,TotalAllTypes =	(SELECT Total FROM Data1)
	,PercentTotal =		ROUND (COUNT (*) / (SELECT Total FROM Data1) * 100, 1)
FROM Person.PersonPhone AS p 
INNER JOIN Person.PhoneNumberType AS t 
	ON p.PhoneNumberTypeID = t.PhoneNumberTypeID
GROUP BY t.[Name] 
ORDER BY [Count] DESC;
---------------------------------------------------------------------------
-- 28.  Solution 3 to Challenge Question "Phone Number Types"

USE AdventureWorks2022;

SELECT
	PhoneNumberType =	t.[Name]
	,[Count] =			COUNT (*) 
	,TotalAllTypes =	SUM (COUNT (*)) OVER ()

	,PercentTotal =		ROUND (
                              COUNT (*) 
                              / 
                              CONVERT (FLOAT, SUM (COUNT (*)) OVER ()) * 100
                         , 1)

FROM Person.PersonPhone AS p 
INNER JOIN Person.PhoneNumberType AS t 
	ON p.PhoneNumberTypeID = t.PhoneNumberTypeID
GROUP BY t.[Name] 
ORDER BY [Count] DESC;
---------------------------------------------------------------------------
-- 29.  Solution 1 to Challenge Question "Revenue by State"

USE AdventureWorks2022;

SELECT
	[State] =		sp.[Name]
	,TotalSales =	SUM (s.TotalDue)
FROM Sales.SalesOrderHeader AS s
INNER JOIN Person.[Address] AS a 
	ON s.ShipToAddressID = a.AddressID
INNER JOIN Person.StateProvince AS sp 
	ON a.StateProvinceID = sp.StateProvinceID
WHERE YEAR (s.OrderDate) = 2013
	AND sp.CountryRegionCode = 'US'
GROUP BY sp.[Name]
ORDER BY TotalSales DESC;
---------------------------------------------------------------------------
-- 29.  Solution 2 to Challenge Question "Revenue by State"

USE AdventureWorks2022;

SELECT
	st.[State]
	,TotalDue = SUM (s.TotalDue)
FROM Sales.SalesOrderHeader AS s
CROSS APPLY ( SELECT 
				[State] = X2.[Name]
				,Country = X2.CountryRegionCode
			  FROM Person.[Address] AS X1
			  INNER JOIN Person.StateProvince AS X2
				ON X1.StateProvinceID = X2.StateProvinceID
			  WHERE s.ShipToAddressID = X1.AddressID ) AS st
WHERE s.OrderDate BETWEEN '2013-01-01' AND '2013-12-31'
	AND st.Country = 'US'

GROUP BY st.[State]
ORDER BY TotalDue DESC;
---------------------------------------------------------------------------
-- 30.  Solution to Challenge Question "Scrap Rate"

USE AdventureWorks2022;

SELECT TOP 10 PERCENT
	w.WorkOrderID
	,DueDate =			CAST (w.DueDate AS DATE)
	,ProdName =			p.[Name]
	,ScrapReason =		sr.[Name]
	,w.ScrappedQty
	,w.OrderQty
	,PercScrapped =	ROUND (w.ScrappedQty / CONVERT (FLOAT, w.OrderQty) * 100, 2)
FROM Production.WorkOrder AS w
INNER JOIN Production.ScrapReason AS sr 
	ON w.ScrapReasonID = sr.ScrapReasonID
INNER JOIN Production.Product AS p 
	ON w.ProductID = p.ProductID
WHERE w.ScrappedQty / CONVERT (FLOAT, w.OrderQty) >  0.03
ORDER BY PercScrapped DESC;
---------------------------------------------------------------------------
-- 31.  Solution to Challenge Question "Shift Coverage"

USE AdventureWorks2022;

SELECT
	DepartmentName	=	d.[Name]
	,ShiftName =		s.[Name]
	,Employees =		COUNT (*)
FROM HumanResources.EmployeeDepartmentHistory AS dh
INNER JOIN HumanResources.[Shift] AS s 
	ON dh.ShiftID = s.ShiftID
INNER JOIN HumanResources.Department AS d 
	ON dh.DepartmentID = d.DepartmentID
INNER JOIN HumanResources.Employee AS e
	ON dh.BusinessEntityID = e.BusinessEntityID
WHERE d.[Name] = 'Production'
	AND dh.EndDate IS NULL
GROUP BY d.[Name], s.[Name]
ORDER BY Employees DESC;
---------------------------------------------------------------------------
-- 32.  Solution to Challenge Question "The Classic Vest"

USE AdventureWorks2022;

SELECT  
	pod.ProductID
	,ProductName =		p.[Name]
	,poh.OrderDate
	,QuantityOrdered =	SUM (pod.OrderQty) 	 
FROM Purchasing.PurchaseOrderDetail AS pod
INNER JOIN Production.Product AS p 
	ON pod.ProductID = p.ProductID
INNER JOIN Purchasing.PurchaseOrderHeader AS poh 
	ON pod.PurchaseOrderID = poh.PurchaseOrderID
WHERE YEAR (poh.OrderDate) = 2014
	AND p.[Name] LIKE 'Classic Vest%'
GROUP BY pod.Productid, p.[Name], poh.OrderDate
ORDER BY QuantityOrdered DESC;
---------------------------------------------------------------------------
-- 33.  Solution 1 to Challenge Question "Ten Million Dollar Benchmark"   

USE AdventureWorks2022;

WITH 
	FY2013 AS  
		(SELECT
			FY =				2013
			,OrderDate =		CAST (OrderDate AS DATE)
			,[OrderNumber] =	ROW_NUMBER () OVER (ORDER BY SalesOrderID)
			,RunningTotal =		SUM (SubTotal) OVER (ORDER BY SalesOrderID ROWS UNBOUNDED PRECEDING)
			FROM Sales.SalesOrderHeader
			WHERE YEAR (DATEADD (MONTH, 6, OrderDate)) = 2013)

	,FY2014 AS 
		(SELECT
			FY =				2014
			,OrderDate =		CAST (OrderDate AS DATE)
			,[OrderNumber] =	ROW_NUMBER () OVER (ORDER BY SalesOrderID)
			,RunningTotal =		SUM (SubTotal) OVER (ORDER BY SalesOrderID ROWS UNBOUNDED PRECEDING) 
			FROM Sales.SalesOrderHeader
			WHERE YEAR (DATEADD (MONTH, 6, OrderDate)) = 2014)

SELECT TOP 1 * FROM FY2013 WHERE RunningTotal > = 10000000 
UNION
SELECT TOP 1 * FROM FY2014 WHERE RunningTotal > = 10000000 
ORDER BY FY;
---------------------------------------------------------------------------
-- 33.  Solution 2 to Challenge Question "Ten Million Dollar Benchmark" 

USE AdventureWorks2022;

WITH Data1 AS 
	( SELECT
		FY =			   YEAR (DATEADD (MONTH, 6, OrderDate))
		,OrderDate =	   CAST (OrderDate AS DATE)
		,[OrderNumber] = 
          ROW_NUMBER () OVER (PARTITION BY YEAR (DATEADD (MONTH, 6, OrderDate))                            
                               ORDER BY SalesOrderID)	

     ,RunningTotal =	
         SUM (SubTotal) OVER (PARTITION BY YEAR (DATEADD (MONTH, 6, OrderDate))   
                              ORDER BY SalesOrderID
										   ROWS UNBOUNDED PRECEDING)
 
	FROM Sales.SalesOrderHeader
	WHERE YEAR (DATEADD (MONTH, 6, OrderDate)) IN (2013, 2014) )


SELECT DISTINCT s.*
FROM Data1 AS d1
OUTER APPLY (SELECT TOP 1 * 
			 FROM Data1 AS X1
			 WHERE d1.FY = X1.FY
				AND RunningTotal > = 10000000 ) AS s
ORDER BY s.FY;
---------------------------------------------------------------------------
-- 33.  Solution 3 to Challenge Question "Ten Million Dollar Benchmark" 

USE AdventureWorks2022;

WITH Data1 AS
    ( SELECT
        FiscalYear = YEAR (DATEADD (MONTH, 6, OrderDate))
        ,OrderDate = CAST (OrderDate AS DATE)
        
		,OrderNumber = 
			ROW_NUMBER () OVER (PARTITION BY YEAR (DATEADD (MONTH, 6, OrderDate)) 
								ORDER BY SalesOrderID)

        ,RunningTotal = 
			SUM (SubTotal) OVER (PARTITION BY YEAR (DATEADD (MONTH, 6, OrderDate)) 
								 ORDER BY SalesOrderID ROWS UNBOUNDED PRECEDING)
    
	FROM Sales.SalesOrderHeader
    WHERE YEAR (DATEADD (MONTH, 6, OrderDate)) IN (2013, 2014) )

SELECT 
    FiscalYear 
    ,OrderDate 
    ,OrderNumber 
    ,RunningTotal
FROM Data1
WHERE RunningTotal >= 10000000
  AND OrderNumber = (SELECT MIN (OrderNumber) 
                     FROM Data1 AS cs 
                     WHERE cs.FiscalYear = Data1.FiscalYear 
                       AND cs.RunningTotal >= 10000000)
ORDER BY FiscalYear;
---------------------------------------------------------------------------
-- 33.  Solution 4 to Challenge Question "Ten Million Dollar Benchmark" 

USE AdventureWorks2022;

DROP TABLE IF EXISTS #Sales;

SELECT
	FiscalYear =	   YEAR (DATEADD (MONTH, 6, OrderDate))
	,OrderDate =	   CAST (OrderDate AS DATE)
	,OrderNumber =	
       ROW_NUMBER () OVER (PARTITION BY YEAR (DATEADD (MONTH, 6, OrderDate)) 
						    ORDER BY OrderDate)
	,SubTotal
	,RunningTotal =	CONVERT (FLOAT, NULL)
INTO #Sales
FROM Sales.SalesOrderHeader;

UPDATE s
SET RunningTotal =	(SELECT SUM (SubTotal)
					 FROM #Sales X1
					 WHERE s.FiscalYear = X1.FiscalYear
						AND X1.OrderNumber <= s.OrderNumber)
FROM #Sales AS s;

DROP TABLE IF EXISTS #FindOrder;

SELECT
	FiscalYear
	,OrderNumberOver10M =	(SELECT TOP 1 X1.OrderNumber
							 FROM #Sales X1
							 WHERE s.FiscalYear = X1.FiscalYear
							   AND X1.RunningTotal > = 10000000
							 ORDER BY X1.RunningTotal)
INTO #FindOrder
FROM #Sales AS s
GROUP BY FiscalYear;

SELECT
	f.FiscalYear
	,s.OrderDate
	,s.OrderNumber
	,s.RunningTotal
FROM #FindOrder AS f
INNER JOIN #Sales AS s 
	ON s.FiscalYear = f.FiscalYear
		AND f.OrderNumberOver10M = s.OrderNumber
WHERE s.FiscalYear IN (2013, 2014);
---------------------------------------------------------------------------
-- 34.  Solution to Challenge Question "The Mentors"

USE AdventureWorks2022;

WITH SalesGrouping AS
	( SELECT 
		SalesPersonID
		,SalesTotal =				SUM (SubTotal)
		,SalesRankSubTotalDESC =	ROW_NUMBER () OVER (ORDER BY SUM (Subtotal) DESC)
		,SalesRankSubTotalASC =		ROW_NUMBER () OVER (ORDER BY SUM (Subtotal))
	FROM Sales.SalesOrderHeader
	WHERE YEAR (OrderDate) = 2014 
		AND SalesPersonID IS NOT NULL
	GROUP BY SalesPersonID )

SELECT TOP 5
	SuccessSalesPersonID =		s.SalesPersonID
	,SuccessRevenue =			s.SalesTotal
	,UnsuccessSalesPersonID =	s2.SalesPersonID
	,UnsuccessRevenue =			s2.SalesTotal
FROM SalesGrouping s
INNER JOIN SalesGrouping s2 
	ON s.SalesRankSubTotalDESC = s2.SalesRankSubTotalASC
ORDER BY s.SalesRankSubTotalDESC;
---------------------------------------------------------------------------
-- 35.  Solution 1 to Challenge Question "Year-over-Year Comparisons"

USE AdventureWorks2022;

WITH Data1 AS 
	( SELECT 
		SalesPersonID
		,FY =			YEAR (DATEADD (MONTH, 6, OrderDate))
		,FQ =			DATEPART (QUARTER, DATEADD (MONTH, 6, OrderDate))
		,FQSales =		SUM (Subtotal)
	 FROM Sales.SalesOrderHeader
	 WHERE OnlineOrderFlag = 0
	 GROUP BY 
	 	SalesPersonID
	 	,YEAR (DATEADD (MONTH, 6, OrderDate))
	 	,DATEPART (QUARTER, DATEADD (MONTH, 6, OrderDate)) )   

SELECT
	p.LastName
	,d1.*
	,SalesSameFQLastYr = d2.FQSales
FROM Data1 AS d1
LEFT JOIN Data1 AS d2 
	ON d1.SalesPersonID = d2.SalesPersonID 
		AND d1.FQ = d2.FQ 
		AND d1.FY - 1 = d2.FY
INNER JOIN Person.Person p
	ON d1.SalesPersonID = p.BusinessEntityID
WHERE d1.FY = 2014
ORDER BY SalesPersonID, FY DESC, FQ DESC;
---------------------------------------------------------------------------
-- 35.  Solution 2 to Challenge Question "Year-over-Year Comparisons"

USE AdventureWorks2022;

DROP TABLE IF EXISTS #FY2013;
DROP TABLE IF EXISTS #FY2014;

SELECT 
	SalesPersonID
	,FY =			YEAR (DATEADD (MONTH, 6, OrderDate))
	,FQ =			DATEPART (QUARTER, DATEADD (MONTH, 6, OrderDate))
	,FQSales =		SUM (Subtotal)
INTO #FY2013
FROM Sales.SalesOrderHeader
WHERE OnlineOrderFlag = 0
	AND YEAR (DATEADD (MONTH, 6, OrderDate)) = 2013
GROUP BY 
	SalesPersonID
	,YEAR (DATEADD (MONTH, 6, OrderDate))
	,DATEPART (QUARTER, DATEADD (MONTH, 6, OrderDate)); 

SELECT 
	SalesPersonID
	,FY =			YEAR (DATEADD (MONTH, 6, OrderDate))
	,FQ =			DATEPART (QUARTER, DATEADD (MONTH, 6, OrderDate))
	,FQSales =		SUM (Subtotal)
INTO #FY2014
FROM Sales.SalesOrderHeader
WHERE OnlineOrderFlag = 0
	AND YEAR (DATEADD (MONTH, 6, OrderDate)) = 2014
GROUP BY 
	SalesPersonID
	,YEAR (DATEADD (MONTH, 6, OrderDate))
	,DATEPART (QUARTER, DATEADD (MONTH, 6, OrderDate)); 

SELECT
	p.LastName
	,cy.*
	,SalesSameFQLastYr = py.FQSales
FROM #FY2014 AS cy
LEFT JOIN #FY2013 AS py
	ON 1 = 1
		AND cy.SalesPersonID = py.SalesPersonID
		AND cy.FQ = py.FQ
		AND cy.FY - 1 = py.FY
INNER JOIN Person.Person AS p 
	ON cy.SalesPersonID = p.BusinessEntityID
ORDER BY cy.SalesPersonID, cy.FY DESC, cy.FQ DESC;
---------------------------------------------------------------------------
-- 35.  Solution 3 to Challenge Question "Year-over-Year Comparisons"

USE AdventureWorks2022;

WITH Data1 AS 
	(SELECT 
		d2.LastName
		,SalesPersonID
		,FY =			 YEAR (DATEADD (MONTH, 6, OrderDate))
		,FQ =			 DATEPART (QUARTER, DATEADD (MONTH, 6, OrderDate))
		,FQSales =		 SUM (Subtotal)


		,SalesSameFQLastYr =	
			LAG (SUM (Subtotal), 4) OVER (PARTITION BY SalesPersonID 
										  ORDER BY YEAR (DATEADD (MONTH, 6, OrderDate))
												,DATEPART (QUARTER, DATEADD (MONTH, 6, OrderDate)))
	FROM Sales.SalesOrderHeader AS d1
	INNER JOIN Person.Person AS d2 
		ON d1.SalesPersonID = d2.BusinessEntityID 
	WHERE d1.OnlineOrderFlag = 0 
	GROUP BY 
		d1.SalesPersonID
		,DATEPART (YEAR, DATEADD (MONTH, 6, d1.OrderDate))
		,DATEPART (QUARTER, DATEADD (MONTH, 6, d1.OrderDate))
		,d2.LastName)

SELECT * 
FROM Data1
WHERE FY = 2014
ORDER BY SalesPersonID, FY DESC, FQ DESC;
---------------------------------------------------------------------------
-- 36.  Solution 1 to Challenge Question "Date Range Gaps"

USE AdventureWorks2022;

WITH [Data] AS 
	( SELECT
		 ProductID
		,StartDate
		,EndDate
		,Days_to_Next_Start = 
			ISNULL (DATEDIFF (DAY, EndDate, 
				LEAD (StartDate) OVER (PARTITION BY ProductID ORDER BY StartDate)), 0)
	 FROM Production.ProductListPriceHistory )

SELECT ProductID 
FROM [Data] 
WHERE Days_to_Next_Start > 1
   AND EndDate IS NOT NULL;

-- No date range gaps exist.
---------------------------------------------------------------------------
-- 36.  Solution 2 to Challenge Question "Date Range Gaps"

USE AdventureWorks2022;

WITH 
	[Data] AS
		(SELECT
			ProductID
			,StartDate
			,EndDate
			
         ,Instance = ROW_NUMBER () OVER (PARTITION BY d.ProductID 
                                         ORDER BY d.StartDate)

		FROM Production.ProductListPriceHistory AS d)


	,[Data2] AS
		(SELECT
			d.*
			,Days_to_Next_Start = ISNULL (DATEDIFF (DAY, d.EndDate, d2.StartDate), 0)
		FROM [Data] AS d
		LEFT JOIN [Data] AS d2 
			ON d.ProductID = d2.ProductID 
				AND d2.Instance = d.Instance + 1
           AND d.EndDate IS NOT NULL)

SELECT ProductID
FROM [Data2]
WHERE Days_to_Next_Start > 1;

-- No date range gaps exist.
---------------------------------------------------------------------------
-- 37.  Solution 1 to Challenge Question "Company Picnic"   

USE AdventureWorks2022;

SELECT 
	p.BusinessEntityID
	,FullName =			FirstName + ' ' + LastName + ISNULL (', ' + Suffix, '')
	,Dept =				d.[Name]
FROM Person.Person AS p
INNER JOIN (SELECT 
				BusinessEntityID
				,MaxStart = MAX (StartDate) 
			FROM HumanResources.EmployeeDepartmentHistory
		  	WHERE EndDate IS NULL
			GROUP BY BusinessEntityID ) AS MaxDeptStart 
	ON p.BusinessEntityID = MaxDeptStart.BusinessEntityID
INNER JOIN HumanResources.EmployeeDepartmentHistory AS dh 
	ON MaxDeptStart.MaxStart = dh.StartDate 
		AND MaxDeptStart.BusinessEntityID = dh.BusinessEntityID
INNER JOIN HumanResources.Department AS d 
	ON dh.DepartmentID = d.DepartmentID
WHERE p.PersonType IN ('SP', 'EM') 
ORDER BY Dept, FullName;
---------------------------------------------------------------------------
-- 37.  Solution 2 to Challenge Question "Company Picnic"

USE AdventureWorks2022;

SELECT 
    p.BusinessEntityID
    ,FullName = FirstName + ' ' + LastName + ISNULL (', ' + Suffix, '')
    ,Department = d.[Name]
FROM Person.Person AS p
CROSS APPLY ( SELECT TOP 1 BusinessEntityID, StartDate, DepartmentID
			      FROM HumanResources.EmployeeDepartmentHistory AS X1
			      WHERE p.BusinessEntityID = X1.BusinessEntityID 
			        AND EndDate IS NULL
			      ORDER BY StartDate DESC ) AS MaxDeptStart
INNER JOIN HumanResources.Department AS d 
    ON MaxDeptStart.DepartmentID = d.DepartmentID
WHERE p.PersonType IN ('SP', 'EM') 
ORDER BY Department, FullName;
---------------------------------------------------------------------------
-- 38.  Solution 1 to Challenge Question "Sales Reasons"

USE AdventureWorks2022;

DROP TABLE IF EXISTS #data;
GO

SELECT
	SalesReason =		sr.[Name]
	,[Count] =			COUNT (*)
	,SalesReasonRank =	DENSE_RANK () OVER (ORDER BY COUNT (*) DESC)
INTO #data
FROM Sales.SalesOrderHeaderSalesReason AS hsr
INNER JOIN Sales.SalesReason AS sr
	ON hsr.SalesReasonID = sr.SalesReasonID
GROUP BY sr.[Name]; 

SELECT SalesReason, [Count]
FROM #data AS d
WHERE SalesReasonRank = 1 
	OR SalesReasonRank = (SELECT MAX (SalesReasonRank) FROM #data AS X1)
ORDER BY [Count] DESC;
---------------------------------------------------------------------------
-- 38. Solution 2 to Challenge Question "Sales Reasons" 

USE AdventureWorks2022;

DROP TABLE IF EXISTS #data1; 
GO

SELECT
	Salesreason =				sr.[Name]
	,[Count] =					COUNT (*)
	,SalesReasonRankTop =		DENSE_RANK () OVER (ORDER BY COUNT (*) DESC)
	,SalesReasonRankBottom  =	DENSE_RANK () OVER (ORDER BY COUNT (*))
INTO #data1
FROM Sales.SalesOrderHeaderSalesReason AS hsr
INNER JOIN Sales.Salesreason AS sr
	ON hsr.SalesReasonID = sr.SalesReasonID
GROUP BY sr.[Name]; 

SELECT SalesReason, [Count]
FROM #data1
WHERE SalesReasonRankTop = 1 OR SalesReasonRankBottom = 1
ORDER BY [Count] DESC;
---------------------------------------------------------------------------
-- 38.  Solution 3 to Challenge Question: Sales Reasons

USE AdventureWorks2022;

WITH 
	Data1 AS 
		( SELECT TOP 1 WITH TIES
			SalesReason =	sr.[Name]
			,[Count] =		COUNT (*)
		FROM Sales.SalesOrderHeaderSalesReason AS hsr
		INNER JOIN Sales.Salesreason AS sr
			ON hsr.SalesReasonID = sr.SalesReasonID
		GROUP BY sr.[Name]
		ORDER BY [Count] DESC )

	,Data2 AS 
		( SELECT TOP 1 WITH TIES
			SalesReason =	sr.[Name]
			,[Count] =		COUNT (*)
		FROM Sales.SalesOrderHeaderSalesReason AS hsr
		INNER JOIN Sales.Salesreason AS sr
			ON hsr.SalesReasonID = sr.SalesReasonID
		GROUP BY sr.[Name]
		ORDER BY [Count] )

SELECT * FROM Data1
UNION
SELECT * FROM Data2;
---------------------------------------------------------------------------
-- 39.  Solution 1 for Challenge Question "Revenue Trended" (Part I)

USE AdventureWorks2022;

DECLARE @StartDate DATE =	'2014-04-01';
DECLARE @EndDate   DATE =	'2014-04-23';

SELECT
	DaysInMonthSoFar =			 DATEDIFF (DAY, @StartDate, @EndDate) + 1 
	,RevenueInMonthSoFar =		 SUM (SubTotal)

	,RevPerDayforMonthSoFar = 
        (SUM (SubTotal) / (DATEDIFF (DAY, @StartDate, @EndDate) + 1))
	
   ,DaysInMonth =				 
         DAY (EOMONTH (@StartDate))

	,MonthlyRevTrended =		
         SUM (SubTotal) / (DATEDIFF (DAY, @StartDate, @EndDate) + 1) 
         * DAY (EOMONTH (@StartDate))

FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN @StartDate AND @EndDate;
---------------------------------------------------------------------------
-- 39.  Solution 2 for Challenge Question "Revenue Trended" (Part I)
GO

USE AdventureWorks2022;

DECLARE @StartDate DATE =	'2014-04-01';
DECLARE @EndDate DATE =		'2014-04-23';

WITH Data1 AS
	( SELECT DISTINCT
		OrderDay =				CAST (OrderDate AS DATE)
		,RunningTotalRevenue =	SUM (SubTotal) OVER (ORDER BY OrderDate)
	FROM Sales.SalesOrderHeader
	WHERE OrderDate BETWEEN @StartDate AND @EndDate )

SELECT
	DaysInMonthSoFar =	    DATEDIFF (DAY, @StartDate, @EndDate) + 1 
	,RevenueInMonthSoFar =	 RunningTotalRevenue
	
,RevPerDayforMonthSoFar =  
         RunningTotalRevenue / (DATEDIFF (DAY, @StartDate, @EndDate) + 1)
	
,DaysInMonth = DAY (EOMONTH (@StartDate))

,MonthlyRevTrended =		
     (RunningTotalRevenue / (DATEDIFF (DAY, @StartDate, @EndDate) + 1)) 
      * DAY (EOMONTH (@StartDate))

FROM Data1
WHERE OrderDay = @EndDate;
---------------------------------------------------------------------------
-- 39.  Solution for Challenge "Revenue Trended" (Part II)

USE AdventureWorks2022;

SELECT
	ActualPerDay =	SUM (SubTotal) / DAY (EOMONTH (@StartDate))
	,ActualRev =	SUM (Subtotal)
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN @StartDate AND EOMONTH (@EndDate);
---------------------------------------------------------------------------
-- 40.  Solution to Challenge Question "Featured Product Reviews" 

USE AdventureWorks2022;

SELECT DISTINCT
	p.ProductID
	,pr.ProductReviewID
	,ProductName =		p.[Name]
	,Review =			pr.Comments
	,CommonWords =		p_word.[value]
FROM Production.ProductReview AS pr 
INNER JOIN Production.Product AS p 
	ON pr.ProductID = p.ProductID 
CROSS APPLY STRING_SPLIT (LOWER (pr.Comments), ' ') AS pr_word
CROSS APPLY STRING_SPLIT (LOWER (p.[Name]), ' ') AS p_word 
WHERE pr_word.[value] = p_word.[value]
ORDER BY p.ProductID;
---------------------------------------------------------------------------
-- 41.  Solution to Challenge Question "Employment Survey" (Part I)  

USE AdventureWorks2022;

SELECT 
	Employees =	COUNT (*)
	
,[%Male] =		
     ROUND (SUM (CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) 
          / CONVERT (FLOAT, COUNT (*)) * 100, 2)
	
,[%Female] =	
     ROUND (SUM (CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) 
     / CONVERT (FLOAT, COUNT (*)) * 100, 2)
	
,AvgMonthsEmp =	AVG (DATEDIFF (MONTH, HireDate, GETDATE ()))
FROM HumanResources.Employee
WHERE CurrentFlag = 1;
---------------------------------------------------------------------------
-- 41.  Solution to Challenge Question "Employment Survey" (Part II)  

USE AdventureWorks2022;

SELECT
	Quartile
	,Employees = COUNT (*)
	
,[%Male] =		
         ROUND (SUM (CASE WHEN X1.Gender = 'M' THEN 1 ELSE 0 END) 
         / CONVERT (FLOAT, COUNT (*)) * 100, 1)
	
,[%Female] =	
        ROUND (SUM (CASE WHEN X1.Gender = 'F' THEN 1 ELSE 0 END) 
        / CONVERT (FLOAT, COUNT (*)) * 100, 1)
	
,AvgMonthsEmp =	AVG (MonthsEmployed)

FROM (SELECT 
		    BusinessEntityID
		
         ,Quartile = 
            NTILE (4) OVER (ORDER BY DATEDIFF (MONTH, HireDate, GETDATE ()))
		
         ,HireDate
		   ,MonthsEmployed  =	DATEDIFF (MONTH, HireDate, GETDATE ())
		   ,Gender
		FROM HumanResources.Employee 
		WHERE CurrentFlag = 1 ) AS X1
GROUP BY X1.Quartile;
---------------------------------------------------------------------------
-- 42.  Solution 1 to Challenge Question "Costs Vary"

USE AdventureWorks2022;

SELECT 
	pch.ProductID
	,ProductName =	p.[Name]
	,SubCategory =	s.[Name]
	,MinCost =		MIN (pch.StandardCost)
	,MaxCost =		MAX (pch.StandardCost)
	,CostVar=		MAX (pch.StandardCost) - MIN (pch.StandardCost)

	,CostVarRank =	
      CASE 
			WHEN MAX (pch.StandardCost) - MIN (pch.StandardCost) = 0 THEN 0
 
			ELSE DENSE_RANK () OVER (ORDER BY MAX (pch.StandardCost) 
              - MIN (pch.StandardCost) DESC) 
		 END

FROM Production.ProductCostHistory AS pch
INNER JOIN Production.Product AS p 
	ON pch.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS s 
	ON p.ProductSubcategoryID = s.ProductSubcategoryID
GROUP BY pch.ProductID, p.[Name], s.[Name]
ORDER BY MAX (pch.StandardCost) - MIN (pch.StandardCost) DESC;
---------------------------------------------------------------------------
-- 42.  Solution 2 to Challenge Question "Costs Vary"

USE AdventureWorks2022;

WITH Data1 AS 
	( SELECT 
		MinCost =		 MIN (pch.StandardCost)
        ,MaxCost =		 MAX (pch.StandardCost)
        ,CostVar =		 MAX (pch.StandardCost) - MIN (pch.StandardCost)
        ,ProductID =	 pch.ProductID
        ,ProductName =	 p.[Name]
        ,SubCategory =	 s.[Name]
    FROM Production.ProductCostHistory AS pch
    INNER JOIN Production.Product p 
		ON pch.ProductID = p.ProductID
    INNER JOIN Production.ProductSubcategory s 
		ON p.ProductSubcategoryID = s.ProductSubcategoryID
    GROUP BY pch.ProductID, p.[Name], s.[Name] )

SELECT 
	ProductID
	,ProductName
    ,SubCategory
    ,MinCost
    ,MaxCost
    ,CostVar
    ,CostVarRank =	CASE 
                        WHEN CostVar = 0 THEN 0
                        ELSE DENSE_RANK() OVER (ORDER BY CostVar DESC)
                    END
FROM Data1
ORDER BY CostVar DESC;
---------------------------------------------------------------------------
-- 43.  Solution 1 to Challenge Question "Expired Credit Cards" (Part I)

USE AdventureWorks2022;

DROP TABLE IF EXISTS #data1;
GO

SELECT
	c.CreditCardID
	,c.CardType
	,Expiration_Date =	EOMONTH (DATEFROMPARTS (c.ExpYear, c.ExpMonth, 1))
	,Last_Order =		CAST (s.OrderDate AS DATE)
	,[Orders<=Exp] =	COUNT (DISTINCT before_exp.SalesOrderID)
	,[Orders>Exp] =		COUNT (DISTINCT after_exp.SalesOrderID)
INTO #data1
FROM Sales.CreditCard AS c

LEFT JOIN Sales.SalesOrderHeader AS s 
	ON c.CreditCardID = s.CreditCardID
		AND s.OrderDate = (SELECT MAX (OrderDate)
					       FROM [Sales].SalesOrderHeader AS X1
						   WHERE s.CreditCardID = X1.CreditCardID)

LEFT JOIN Sales.SalesOrderHeader AS before_exp 
	ON c.CreditCardID = before_exp.CreditCardID
		AND before_exp.OrderDate <= EOMONTH (DATEFROMPARTS (c.ExpYear, c.ExpMonth,1))

LEFT JOIN Sales.SalesOrderHeader AS after_exp 
	ON c.CreditCardID = after_exp.CreditCardID
		AND after_exp.OrderDate > EOMONTH (DATEFROMPARTS (c.ExpYear, c.ExpMonth,1))

WHERE s.OrderDate IS NOT NULL
GROUP BY 
	c.CreditCardID
	,c.CardType
	,CAST (s.OrderDate AS DATE)
	,c.ExpYear
	,c.ExpMonth; 
	
SELECT * 
FROM #data1
ORDER BY CreditCardID;
---------------------------------------------------------------------------
--  43.  Solution 2 to Challenge Question 5: Expired Credit Cards (Part I)

USE AdventureWorks2022;

DROP TABLE IF EXISTS #data2;
GO

WITH Data1 AS 
	( SELECT 
		CreditCardID
		,Last_Order = CAST (MAX (OrderDate) AS DATE)
		FROM Sales.SalesOrderHeader
		GROUP BY CreditCardID )
	
SELECT 
	s.CreditCardID
	,c.CardType
	,Expiration_Date =	EOMONTH (DATEFROMPARTS (c.ExpYear, c.ExpMonth, 1))
	,d1.Last_Order
	
   ,[Orders<=Exp] =	 SUM (
                      CASE 
                        WHEN s.OrderDate <= EOMONTH (
                                               DATEFROMPARTS (
                                                  c.ExpYear, c.ExpMonth, 1)) 
                           THEN 1 ELSE 0 END)

	,[Orders>Exp] =		SUM (
                         CASE 
                            WHEN s.OrderDate > EOMONTH (
                                                DATEFROMPARTS (
                                                   c.ExpYear, c.ExpMonth, 1)) 
                           THEN 1 ELSE 0 END)

INTO #data2
FROM Sales.SalesOrderHeader AS s
INNER JOIN Sales.CreditCard AS c
	ON s.CreditCardID = c.CreditCardID
LEFT JOIN Data1 AS d1
	ON c.CreditCardID = d1.CreditCardID
GROUP BY 
     s.CreditCardID, c.CardType
     ,EOMONTH (DATEFROMPARTS (c.ExpYear, c.ExpMonth, 1))
	  ,d1.Last_Order;

SELECT * 
FROM #data2
ORDER BY CreditCardID;
---------------------------------------------------------------------------
--  Solution 3 to Challenge Question 5: Expired Credit Cards (Part I)

DROP TABLE IF EXISTS #data3;

SELECT
	c.CreditCardID
   ,c.CardType
   ,Expiration_Date =	EOMONTH (DATEFROMPARTS (c.ExpYear, c.ExpMonth, 1))
   ,Last_Order =		MAX (CAST(s.OrderDate AS DATE))
   ,[Orders<=Exp] =		COUNT (CASE WHEN s.OrderDate <= EOMONTH (DATEFROMPARTS (c.ExpYear, c.ExpMonth, 1)) THEN s.SalesOrderID END)
   ,[Orders>Exp] =		COUNT (CASE WHEN s.OrderDate > EOMONTH (DATEFROMPARTS (c.ExpYear, c.ExpMonth, 1)) THEN s.SalesOrderID END)
INTO #data3
FROM Sales.CreditCard AS c
INNER JOIN Sales.SalesOrderHeader AS s
    ON c.CreditCardID = s.CreditCardID
GROUP BY
    c.CreditCardID,
    c.CardType,
    c.ExpYear,
    c.ExpMonth
HAVING COUNT (s.SalesOrderID) > 0
ORDER BY CreditCardID;

SELECT *
FROM #data3
ORDER BY CreditCardID;
---------------------------------------------------------------------------
--  43.  Solution to Challenge Question "Expired Credit Cards" (Part II)

USE AdventureWorks2022;

SELECT 
	CardType
	,[Orders<=Exp] =	   SUM ([Orders<=Exp])
	,[Orders>Exp] =		SUM ([Orders>Exp])
FROM #data1
GROUP BY CardType
ORDER BY CardType;
---------------------------------------------------------------------------
-- 44.  Solution to Challenge Question "Median Revenue"

USE AdventureWorks2022;

WITH MedianSales AS 
	(SELECT DISTINCT
		OrderYear =		YEAR (OrderDate)
		,MedianSale =	PERCENTILE_DISC (0.5) WITHIN GROUP (ORDER BY Subtotal) OVER (PARTITION BY YEAR (OrderDate))
	 FROM Sales.SalesOrderHeader)

SELECT 
	OrderYear =   YEAR (s.OrderDate)
	,MinSale =	   MIN (s.SubTotal)
	,m.MedianSale
	,AvgSale =	   AVG (s.SubTotal)
	,MaxSale =	   MAX (s.SubTotal)
FROM Sales.SalesOrderHeader AS s
INNER JOIN MedianSales AS m 
	ON YEAR (s.OrderDate) = m.OrderYear
GROUP BY YEAR (s.OrderDate), m.MedianSale
ORDER BY YEAR (s.OrderDate);
---------------------------------------------------------------------------
-- 45.  Solution 1 to Challenge Question "Product Combinations"

USE AdventureWorks2022;

DROP TABLE IF EXISTS #ProductSales;

SELECT
	soh.CustomerID
	,soh.SalesOrderID
	,ProductType =		pc.[Name]
	,p.ProductLine
	,p.ProductID
INTO #ProductSales
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod 
	ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product AS p 
	ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS ps 
	ON p.ProductSubcategoryID = ps.ProductSubcategoryID  
INNER JOIN Production.ProductCategory pc 
	ON ps.ProductCategoryID = pc.ProductCategoryID;

DECLARE @TotalOrders FLOAT = 
	(SELECT COUNT (DISTINCT SalesOrderID) FROM #ProductSales);

DECLARE @BikeAccessoryOrders FLOAT =
	(SELECT COUNT (DISTINCT ps1.SalesOrderID)
	 FROM #ProductSales AS ps1
	 INNER JOIN #ProductSales AS ps2 
		ON ps1.SalesOrderID = ps2.SalesOrderID
	 WHERE ps1.ProductType = 'Bikes' 
		AND ps2.ProductType = 'Accessories'); 

DECLARE @BikeClothingOrders FLOAT = 
	( SELECT COUNT (*) 
	  FROM (SELECT SalesOrderID
		     FROM #ProductSales
		     GROUP BY SalesOrderID
		     HAVING SUM (CASE WHEN ProductType = 'Bikes' THEN 1 ELSE 0 END) > = 1
				   AND SUM (CASE WHEN ProductType = 'Clothing' THEN 1 ELSE 0 END) > = 2)
                 AS X1);
SELECT 
	[at least 1 Bike 1 Acc % Total] = 
		CONVERT (VARCHAR (10), 
			CONVERT (DECIMAL (5,2),	
				(@BikeAccessoryOrders / @TotalOrders) * 100)) + ' %'
	
	,[at least 1 Bike 2 Clothing % Total] = 
		CONVERT (VARCHAR(10), 
			CONVERT (DECIMAL (5,2), 
				(@BikeClothingOrders / @TotalOrders) * 100)) + ' %';
---------------------------------------------------------------------------
-- 45.  Solution 2 to Challenge Question "Product Combinations"
GO

USE AdventureWorks2022;

DECLARE @TotalOrders FLOAT = (SELECT COUNT (DISTINCT SalesOrderID) FROM #ProductSales);

WITH 
	Data1 AS 
		(SELECT
			SalesOrderID
			,Bike_Count = SUM (CASE WHEN ProductType = 'Bikes' 
                                     THEN 1 ELSE 0 END)

			,Accessory_Count =	SUM (CASE WHEN ProductType = 'Accessories' 
                                         THEN 1 ELSE 0 END)

			,Clothing_Count =	SUM (CASE WHEN ProductType = 'Clothing' 
                                         THEN 1 ELSE 0 END)
			FROM #ProductSales
			GROUP BY SalesOrderID )

	,Data2 AS 
		 (SELECT
				[at least 1 Bike 1 Acc] =	
               SUM (CASE WHEN Bike_Count >= 1 AND Accessory_Count >= 1 
                             THEN 1 ELSE 0 END)
				
           ,[at least 1 Bike 2 Clothing] =	
                SUM (CASE WHEN Bike_Count >= 1 AND Clothing_Count >= 2 
                             THEN 1 ELSE 0 END)
			FROM Data1 )


SELECT
	[at least 1 Bike 1 Acc % Total] =		
		CONVERT (VARCHAR (10), 
			CONVERT (DECIMAL (5,2), 
				[at least 1 Bike 1 Acc] / @TotalOrders * 100)) + '%'
	
	,[at least 1 Bike 2 Clothing % Total] =	
		CONVERT (VARCHAR (10)
			,CONVERT (DECIMAL (5,2),
				[at least 1 Bike 2 Clothing] / @TotalOrders* 100)) + '%'
 FROM Data2;
 ---------------------------------------------------------------------------
 -- 46.  Solution 1 to Challenge Question "Product Description Language Survey"

 USE AdventureWorks2022;

SELECT * 
FROM ( SELECT 
		  pm.ProductModelID
		  ,ProductModel =	pm.[Name]
		  ,Arabic =			SUM (CASE WHEN c.[Name] = 'Arabic'	THEN 1 ELSE 0 END)
		  ,Chinese =		SUM (CASE WHEN c.[Name] = 'Chinese' THEN 1 ELSE 0 END)
		  ,English =		SUM (CASE WHEN c.[Name] = 'English' THEN 1 ELSE 0 END)
		  ,French =			SUM (CASE WHEN c.[Name] = 'French'	THEN 1 ELSE 0 END)
		  ,Hebrew =			SUM (CASE WHEN c.[Name] = 'Hebrew'	THEN 1 ELSE 0 END)
		  ,Spanish =		SUM (CASE WHEN c.[Name] = 'Spanish' THEN 1 ELSE 0 END)
		  ,Thai =			SUM (CASE WHEN c.[Name] = 'Thai'	THEN 1 ELSE 0 END)
	  FROM Production.ProductModel AS pm
	  LEFT JOIN Production.ProductModelProductDescriptionCulture AS pdc
	  	ON pm.ProductModelID = pdc.ProductModelID
	  LEFT JOIN Production.Culture AS c
	  	ON pdc.CultureID = c.CultureID 
	  GROUP BY pm.ProductModelID, pm.[Name] ) AS X1
     ORDER BY Arabic + Chinese + English + French + Hebrew + Spanish + Thai
              ,ProductModelID;
 ---------------------------------------------------------------------------
 -- 46.  Solution 2 to Challenge Question "Product Description Language Survey" 

 USE AdventureWorks2022;

SELECT * 
FROM (
		SELECT
			Y1.ProductModelID
			,Y1.ProductModel
			,Arabic =			ISNULL (Y1.Arabic, 0)
			,Chinese =			ISNULL (Y1.Chinese, 0)
			,English =			ISNULL (Y1.English, 0)
			,French =			ISNULL (Y1.French, 0)
			,Hebrew =			ISNULL (Y1.Hebrew, 0)
			,Spanish =			ISNULL (Y1.Spanish, 0)
			,Thai =				ISNULL (Y1.Thai, 0)
		FROM ( SELECT 
				   pm.ProductModelID
				   ,ProductModel = pm.[Name]
				   ,c.[Name]
		      FROM Production.ProductModel AS pm
				LEFT JOIN Production.ProductModelProductDescriptionCulture AS pdc
					ON pm.ProductModelID = pdc.ProductModelID
				LEFT JOIN Production.Culture AS c
					ON pdc.CultureID = c.CultureID ) AS X1
		PIVOT	
			(COUNT (X1.[Name]) 
			 FOR [Name] IN (Arabic, Chinese, English, French, Hebrew, Spanish, Thai)
			 ) AS Y1
	) AS Z1
ORDER BY Arabic + Chinese + English + French + Hebrew + Spanish + Thai
         ,ProductModelID;
---------------------------------------------------------------------------
 --- 47.  Solution 1 to Challenge Question "Similar Products"      

USE AdventureWorks2022;

DECLARE @Today DATE = '2014-01-01';

SELECT
	BaseProd_ID =			p.ProductID
	,BaseProdName =			p.[name]
	,BaseProdPrice =	    p.ListPrice
	,SimiliarProdPrice =	p2.ListPrice
	,SimilarProdName =		p2.[Name]
	,SimilarProdID =	    p2.ProductID
FROM Production.Product AS p

CROSS APPLY (SELECT TOP 1 X1.ProductID, X1.ListPrice, X1.[Name]
	   		  FROM Production.Product AS X1
	   		  WHERE 1 = 1
                AND p.ProductSubcategoryID = X1.ProductSubcategoryID
				AND p.Size = X1.Size
	   			AND p.Style = X1.Style
	   			AND p.ProductID <> X1.ProductID
				AND X1.ListPrice <= p.ListPrice
	   			AND X1.FinishedGoodsFlag = 1
	   			AND X1.SellStartDate <= @Today
	   			AND ISNULL (X1.SellEndDate, '9999-12-31') > @Today
	   		  ORDER BY ABS (X1.ListPrice - p.ListPrice)) AS p2

WHERE p.FinishedGoodsFlag = 1
	AND p.SellStartDate <= @Today
	AND ISNULL (p.SellEndDate, '9999-12-31') > @Today
ORDER BY BaseProd_ID;
---------------------------------------------------------------------------
-- 47.  Solution 2 to Challenge Question: Similar Products
GO

USE AdventureWorks2022;

DECLARE @Today DATE = '2014-01-01';

SELECT 
	X1.BaseProd_ID
	,X1.BaseProdName
	,X1.BaseProdPrice
	,X1.SimiliarProdPrice
	,X1.SimilarProdName
	,X1.SimilarProdID
FROM ( SELECT 
		 BaseProd_ID =		  p.ProductID
		,BaseProdName =		  p.[name]
		,BaseProdPrice =	  p.ListPrice
		,SimiliarProdPrice =  p2.ListPrice
		,SimilarProdName =	  p2.[Name]
		,SimilarProdID =	  p2.ProductID

		,Diff_Rank = 
         ROW_NUMBER () OVER (PARTITION BY p.ProductID 
						     ORDER BY ABS (p.ListPrice - p2.ListPrice))
	  
        FROM Production.Product AS p
	     INNER JOIN Production.Product AS p2 
	  	      ON 1 = 1 
              AND p.ProductSubcategoryID = p2.ProductSubcategoryID
	  		      AND p.Size = p2.Size
	  		      AND p.Style = p2.Style
	  		      AND p2.ListPrice <= p.ListPrice
	  		      AND p2.FinishedGoodsFlag = 1
			      AND p.ProductID <> p2.ProductID
	  		      AND p2.SellStartDate <= @Today
	  		      AND ISNULL (p2.SellEndDate, '9999-12-31') > @Today		
	      WHERE p.FinishedGoodsFlag = 1
	  	            AND p.SellStartDate <= @Today
	  	            AND ISNULL (p.SellEndDate, '9999-12-31') > @Today 
	   ) AS X1
WHERE X1.Diff_Rank = 1
ORDER BY X1.BaseProd_ID;
---------------------------------------------------------------------------
-- 48.  Solution to Challenge Question "Trade Show Giveaway"

USE AdventureWorks2022;

DROP TABLE IF EXISTS #data;

SELECT
	ProductName =	p.[name]
	,Category =		pc.[Name]
	,StandardCost
INTO #data
FROM Production.Product AS p 
INNER JOIN Production.ProductSubcategory AS ps 
	ON p.ProductSubcategoryID = ps.ProductSubcategoryID  
INNER JOIN Production.ProductCategory AS pc 
	ON ps.ProductCategoryID = pc.ProductCategoryID -- SELECT * FROM #data
WHERE p.FinishedGoodsFlag = 1
	AND ISNULL (SellEndDate, '9999-12-31') > GETDATE ();

GO

DECLARE @Budget TINYINT = 120;

WITH 
	Accessories AS 
		( SELECT ProductName, StandardCost FROM #data WHERE Category = 'Accessories')

	,Clothing AS 
		( SELECT ProductName, StandardCost FROM #data WHERE Category = 'Clothing')

SELECT
	AccessoryName =			a.ProductName
	,AccessoryName2 =		a2.ProductName
	,ClothingName =			c.ProductName
	,AccessoryCost =		a.StandardCost
	,AccessoryCost2 =		a2.StandardCost
	,ClothingCost =			c.StandardCost
	,TotalStandardCost =	a.StandardCost + a2.StandardCost + c.StandardCost 
	,TotalStandardCostRank = 
       DENSE_RANK () OVER (ORDER BY 
                              a.StandardCost 
                              + a2.StandardCost 
                              + c.StandardCost DESC)
FROM Accessories AS a
CROSS JOIN Accessories AS a2
CROSS JOIN Clothing AS c
WHERE 1 = 1
	AND a.StandardCost + a2.StandardCost +  c.StandardCost  < @Budget
	AND a.ProductName <> a2.ProductName
ORDER BY TotalStandardCostRank;
---------------------------------------------------------------------------
-- 49.  Solution 1 to Challenge Question "Online/Offline"

USE AdventureWorks2022;

SELECT
	TerritoryID
	,TotalOrders = COUNT (*)

	,PercOnline	 = ROUND ( 
						SUM (CASE WHEN OnlineOrderFlag = 1 THEN 1 ELSE 0 END) 
							/ CONVERT (FLOAT, COUNT (*)) * 100, 2)

	,PercOffline = ROUND ( 
						SUM (CASE WHEN OnlineOrderFlag = 0 THEN 1 ELSE 0 END) 
						/ CONVERT (FLOAT, COUNT (*)) * 100, 2)
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
ORDER BY TerritoryID;
---------------------------------------------------------------------------
-- 49.  Solution 2 to Challenge Question "Online/Offline" 

USE AdventureWorks2022;

WITH Data1 AS 
	( SELECT 
		GroupingID =	GROUPING_ID (TerritoryID, OnlineOrderFlag)
		,TerritoryID
		,OnlineOrderFlag
		,[Count] =		CONVERT (FLOAT, COUNT (*))
	FROM Sales.SalesOrderHeader AS s
	GROUP BY ROLLUP (TerritoryID, OnlineOrderFlag) )

SELECT DISTINCT
	d1.TerritoryID
	,TotalOrders = total.[Count]
	,PercOnline =	ROUND ([online].[Count] / total.[Count] * 100, 2)
	,PercOffline =	ROUND ([offline].[Count] / total.[Count] * 100, 2)
FROM Data1 AS d1

OUTER APPLY (SELECT X1.[Count] 
			 FROM Data1 AS X1
			 WHERE d1.TerritoryID = X1.TerritoryID
				AND X1.OnlineOrderFlag = 1 ) AS [online]

OUTER APPLY (SELECT X1.[Count] 
			 FROM Data1 AS X1
			 WHERE d1.TerritoryID = X1.TerritoryID
				AND X1.OnlineOrderFlag = 0 ) AS [offline]

OUTER APPLY (SELECT X1.[Count] 
			 FROM Data1 AS X1
			 WHERE d1.TerritoryID = X1.TerritoryID
				AND X1.GroupingID = 1) AS total
WHERE d1.GroupingID = 0
ORDER BY TerritoryID;
---------------------------------------------------------------------------
-- 49.  Solution 3 to Challenge Question "Online/Offline" 

USE AdventureWorks2022;

WITH 
	Data1 AS 
		( SELECT 
		    TerritoryID
		    ,OnlineOrderFlag
		  FROM Sales.SalesOrderHeader )
	
	,Data2 AS 
		( SELECT 
			TerritoryID
			,Total = CONVERT (FLOAT, COUNT (*))
		FROM Sales.SalesOrderHeader
		GROUP BY TerritoryID )

SELECT 
    X1.TerritoryID
	,TotalOrders = d2.Total
    ,PercOnline =  ROUND (X1.[1] / d2.Total * 100, 2)
    ,PercOffline = ROUND (X1.[0] / d2.Total * 100, 2)
FROM Data1 AS d1
PIVOT (COUNT (OnlineOrderFlag)
    FOR OnlineOrderFlag IN ([1], [0])) AS X1
INNER JOIN Data2 AS d2
	ON X1.TerritoryID = d2.TerritoryID
ORDER BY TerritoryID;
---------------------------------------------------------------------------
-- 50.  Solution 1 to Challenge Question "Pay Rate Changes"  

USE AdventureWorks2022;

WITH Data1 AS 
	( SELECT
		BusinessEntityID
		,PayRateNumber =	ROW_NUMBER () OVER (PARTITION BY BusinessEntityID 
												ORDER BY RateChangeDate DESC)
		,RateChangeDate
		,Rate
	FROM HumanResources.EmployeePayHistory )

SELECT
	d1.BusinessEntityID
	,RatePrior =			d1_2.Rate
	,LatestRate =			d1.Rate

	,PercentChange =		CONVERT (VARCHAR (10), 
								(d1.Rate - d1_2.Rate) / d1_2.Rate * 100) + '%'
FROM Data1 d1
LEFT JOIN Data1 d1_2 
	ON d1.BusinessEntityID = d1_2.BusinessEntityID 
		AND d1_2.PayRateNumber = 2
WHERE d1.PayRateNumber = 1
ORDER BY d1.BusinessEntityID;	
---------------------------------------------------------------------------
-- 50.  Solution 2 to Challenge Question "Pay Rate Changes" 

USE AdventureWorks2022;

WITH Data1 AS 
	(SELECT
		BusinessEntityID
		,RateChangeDate
		,CurrentRate =   Rate
		,Rate_Prior =	  LAG (Rate, 1) OVER (PARTITION BY BusinessEntityID 
                                           ORDER BY RateChangeDate)

	FROM HumanResources.EmployeePayHistory AS p)

SELECT
	BusinessEntityID
	,CurrentRate 
	,PercentChange =	CONVERT (VARCHAR (10), 
							((CurrentRate - Rate_Prior)/ Rate_Prior) * 100) + '%'
FROM Data1
WHERE RateChangeDate = (SELECT MAX (RateChangeDate)
						FROM HumanResources.EmployeePayHistory AS X1
						WHERE Data1.BusinessEntityID = X1.BusinessEntityID)

ORDER BY BusinessEntityID;
---------------------------------------------------------------------------
-- 50.  Solution 3 to Challenge Question "Pay Rate Changes" 

USE AdventureWorks2022;

SELECT 
	BusinessEntityID
	,Rate_Prior = RatePrior.Rate
	,CurrentRate = h.Rate

	,PercentChange = CONVERT (VARCHAR (10), 
						      ((h.Rate- RatePrior.Rate)/ RatePrior.Rate) * 100) + '%'

FROM HumanResources.EmployeePayHistory AS h

OUTER APPLY (SELECT TOP 1 Rate, RateChangeDate
			     FROM HumanResources.EmployeePayHistory AS X1
			     WHERE h.BusinessEntityID = X1.BusinessEntityID
			     ORDER BY RateChangeDate DESC) AS MaxRate

OUTER APPLY (SELECT TOP 1 Rate, RateChangeDate
			    FROM HumanResources.EmployeePayHistory AS X1
			    WHERE h.BusinessEntityID = X1.BusinessEntityID
				    AND RateChangeDate < MaxRate.RateChangeDate
			    ORDER BY RateChangeDate DESC) AS RatePrior

WHERE h.RateChangeDate = MaxRate.RateChangeDate
ORDER BY BusinessEntityID;
---------------------------------------------------------------------------
-- 50.  Solution 4 to Challenge Question "Pay Rate Changes" 

USE AdventureWorks2022;

WITH 
	Data1 AS 
		( SELECT 
			BusinessEntityID
			,MaxRateChange_Date =	h.RateChangeDate
			,MaxRate =				h.Rate
		  FROM HumanResources.EmployeePayHistory AS h
		  WHERE RateChangeDate = (SELECT MAX (RateChangeDate)
		  						  FROM HumanResources.EmployeePayHistory AS X1
		  						  WHERE h.BusinessEntityID = X1.BusinessEntityID) )

	,Data2 AS 
		( SELECT
			BusinessEntityID
			,Rate_Prior = (SELECT TOP 1 Rate	
						      FROM HumanResources.EmployeePayHistory AS X1
						      WHERE d1.BusinessEntityID = X1.BusinessEntityID
							       AND X1.RateChangeDate < d1.MaxRateChange_Date
						      ORDER BY RateChangeDate DESC)

			,Current_Rate = d1.MaxRate
		FROM Data1 AS d1 )

SELECT 
	d2.*
	,PercentChange = CONVERT (VARCHAR (10), 
						       ((Current_Rate - Rate_Prior)/ Rate_Prior) * 100) + '%'
FROM Data2 AS d2
ORDER BY BusinessEntityID;
---------------------------------------------------------------------------
-- 51.  Solution 1 to Challenge Question "Sales Quota Changes"

USE AdventureWorks2022;

SELECT DISTINCT
	s.BusinessEntityID
	,SalesRepLastName =	p.LastName
	,Yr2013StartQuota =	min_2013.SalesQuota
	,Yr2014EndQuota =	max_2014.SalesQuota

	,[%ChangeQuota] =	(max_2014.SalesQuota - min_2013.SalesQuota) 
                         / min_2013.SalesQuota * 100

FROM Sales.SalesPersonQuotaHistory AS s
INNER JOIN Sales.SalesPersonQuotaHistory AS min_2013 

	ON s.BusinessEntityID = min_2013.BusinessEntityID 
		AND min_2013.QuotaDate = (SELECT MIN (QuotaDate) 
								  FROM Sales.SalesPersonQuotaHistory AS X1
								  WHERE min_2013.BusinessEntityID = X1.BusinessEntityID    
								     AND YEAR (X1.QuotaDate) = 2013)

INNER JOIN Sales.SalesPersonQuotaHistory AS max_2014 
	ON s.BusinessEntityID = max_2014.BusinessEntityID
		AND max_2014.QuotaDate = (SELECT MAX (QuotaDate) 
								  FROM Sales.SalesPersonQuotaHistory AS X1
								  WHERE max_2014.BusinessEntityID = X1.BusinessEntityID
									AND YEAR (X1.QuotaDate) = 2014)
INNER JOIN Person.Person AS p 
	ON s.BusinessEntityID = p.BusinessEntityID
ORDER BY BusinessEntityID;
---------------------------------------------------------------------------
-- 51.  Solution 2 to Challenge Question "Sales Quota Changes"

USE AdventureWorks2022;

SELECT DISTINCT
	s.BusinessEntityID
	,SalesRepLastName =		p.LastName
	,Yr2013StartQuota =		min_2013.SalesQuota
	,Yr2014EndQuota =		max_2014.SalesQuota

	,[%ChangeQuota] =		(max_2014.SalesQuota - min_2013.SalesQuota) 
							/ min_2013.SalesQuota * 100    
      
FROM Sales.SalesPersonQuotaHistory AS s

CROSS APPLY (SELECT TOP 1 BusinessEntityID, QuotaDate, SalesQuota
			    FROM  Sales.SalesPersonQuotaHistory AS X1
			    WHERE s.BusinessEntityID = X1.BusinessEntityID
				   AND YEAR (X1.QuotaDate) = 2013
			    ORDER BY QuotaDate) AS min_2013

CROSS APPLY (SELECT TOP 1 BusinessEntityID, QuotaDate, SalesQuota
			    FROM  Sales.SalesPersonQuotaHistory AS X1
			    WHERE s.BusinessEntityID = X1.BusinessEntityID
				    AND YEAR (X1.QuotaDate) = 2014
			    ORDER BY QuotaDate DESC) AS max_2014

INNER JOIN Person.Person AS p 
	ON s.BusinessEntityID = p.BusinessEntityID
ORDER BY BusinessEntityID;
---------------------------------------------------------------------------
-- 52.  Solution 1 to Challenge Question "Age Groups"
GO

USE AdventureWorks2022;

DECLARE @TodayDate DATE = '2010-09-09';

SELECT 
	e.JobTitle

	,AgeGroup =	
     CASE 
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) <= 18 THEN '18 or Under'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 19 AND 25 THEN '19 - 25'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 26 AND 34 THEN '26 - 34'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 35 AND 44 THEN '35 - 44'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 45 AND 54 THEN '45 - 54'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 55 AND 64 THEN '55 - 64'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) >= 65 THEN  '65 +' 
	   END 

		,p.Rate
		,Employees =	COUNT (e.BusinessEntityID)
FROM HumanResources.Employee AS e
INNER JOIN HumanResources.EmployeePayHistory AS p 
	ON e.BusinessEntityID = p.BusinessEntityID 
   
INNER JOIN ( SELECT BusinessEntityID, RatechangeDate = MAX (RateChangeDate) 
			 FROM HumanResources.EmployeePayHistory
			 GROUP BY BusinessEntityID ) AS rc
	
    ON p.BusinessEntityID = rc.BusinessEntityID   
		AND p.RateChangeDate = rc.RatechangeDate

GROUP BY 
	JobTitle 
	,Rate

	,CASE 
		WHEN DATEDIFF (YY, BirthDate, @TodayDate) <= 18 THEN '18 or Under'
		WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 19 AND 25 THEN '19 - 25'
		WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 26 AND 34 THEN '26 - 34'
		WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 35 AND 44 THEN '35 - 44'
		WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 45 AND 54 THEN '45 - 54'
		WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 55 AND 64 THEN '55 - 64'
		WHEN DATEDIFF (YY, BirthDate, @TodayDate) >= 65 THEN  '65 +' 
   END
ORDER BY e.JobTitle;
---------------------------------------------------------------------------
-- 52.  Solution 2 to Challenge Question "Age Groups"

GO

USE AdventureWorks2022;

DECLARE @TodayDate DATE = '2010-09-09';

WITH Data1 AS 
	( SELECT 
		BusinessEntityID
		,JobTitle
		,AgeGroup =	
     CASE 
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) <= 18 THEN '18 or Under'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 19 AND 25 THEN '19 - 25'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 26 AND 34 THEN '26 - 34'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 35 AND 44 THEN '35 - 44'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 45 AND 54 THEN '45 - 54'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 55 AND 64 THEN '55 - 64'
		  WHEN DATEDIFF (YY, BirthDate, @TodayDate) >= 65 THEN  '65 +' 
	   END 
	FROM HumanResources.Employee )

SELECT 
	d1.JobTitle
	,d1.AgeGroup
	,p.Rate
	,Employees = COUNT (*)
FROM Data1 AS d1
LEFT JOIN HumanResources.EmployeePayHistory AS p 
	ON d1.BusinessEntityID = p.BusinessEntityID
		AND RateChangeDate = (SELECT MAX (RateChangeDate)
						           FROM HumanResources.EmployeePayHistory AS X1
							        WHERE d1.BusinessEntityID = X1.BusinessEntityID)
GROUP BY d1.JobTitle, d1.AgeGroup, p.Rate
ORDER BY JobTitle;
---------------------------------------------------------------------------
-- 52.  Solution 3 to Challenge Question "Age Groups"
GO

USE AdventureWorks2022;

DECLARE @TodayDate DATE = '2010-09-09';

WITH 
	Data1 AS
		( SELECT 
			BusinessEntityID
			,JobTitle

			,AgeGroup = CASE 
							WHEN DATEDIFF (YY, BirthDate, @TodayDate) <= 18 THEN '18 or Under'
							WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 19 AND 25 THEN '19 - 25'
							WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 26 AND 34 THEN '26 - 34'
							WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 35 AND 44 THEN '35 - 44'
							WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 45 AND 54 THEN '45 - 54'
							WHEN DATEDIFF (YY, BirthDate, @TodayDate) BETWEEN 55 AND 64 THEN '55 - 64'
							WHEN DATEDIFF (YY, BirthDate, @TodayDate) >= 65 THEN  '65 +' 
						END 
    
	    FROM HumanResources.Employee )
	
	,Data2 AS 
		( SELECT p.BusinessEntityID, p.Rate
		  FROM HumanResources.EmployeePayHistory AS p
		  INNER JOIN ( SELECT 
                        BusinessEntityID
                        ,MaxRateChangeDate = MAX (RateChangeDate) 
					   FROM HumanResources.EmployeePayHistory
					   GROUP BY BusinessEntityID ) AS rc
			   ON p.BusinessEntityID = rc.BusinessEntityID
					AND p.RateChangeDate = rc.MaxRateChangeDate )

SELECT 
    d1.JobTitle
    ,d1.AgeGroup
    ,d2.Rate
    ,Employees = COUNT (*) 
FROM Data1 AS d1
LEFT JOIN Data2 AS d2 
    ON d1.BusinessEntityID = d2.BusinessEntityID
GROUP BY d1.JobTitle, d1.AgeGroup, d2.Rate
ORDER BY d1.JobTitle;
---------------------------------------------------------------------------
-- 53.  Solution 1 to Challenge Question "Overpaying"

USE AdventureWorks2022;

DROP TABLE IF EXISTS #ProductVendor;

SELECT
	ProductID
	,HighestPrice	=		MAX (LastReceiptCost)
	,SecondHighestPrice =	CONVERT (FLOAT, NULL)
INTO #ProductVendor
FROM Purchasing.ProductVendor
GROUP BY ProductID
HAVING COUNT (DISTINCT LastReceiptCost) > 1;

UPDATE p 
SET SecondHighestPrice = (SELECT TOP 1 X1.LastReceiptCost
					      FROM Purchasing.ProductVendor X1
					      WHERE 1 = 1
							AND p.ProductID = X1.ProductID
							AND p.HighestPrice <> X1.LastReceiptCost
					      ORDER BY X1.LastReceiptCost DESC)
FROM #ProductVendor AS p;

SELECT * 
FROM #ProductVendor
ORDER BY ProductID;
---------------------------------------------------------------------------
-- 53.  Solution 2 to Challenge Question "Overpaying"

USE AdventureWorks2022;

DROP TABLE IF EXISTS #ProductVendor2;

WITH Prices AS 
	( SELECT
		ProductID
		,LastReceiptCost
		,PriceRank = DENSE_RANK () OVER (PARTITION BY ProductID 
										 ORDER BY LastReceiptCost DESC)
	FROM Purchasing.ProductVendor )

SELECT DISTINCT
	p.ProductID
	,HighestPrice =			MostExp.LastReceiptCost
	,SecondHighestPrice =	SecondMostExp.LastReceiptCost
INTO #ProductVendor2
FROM Prices AS p
LEFT JOIN Prices AS MostExp
	ON p.ProductID = MostExp.ProductID
		AND MostExp.PriceRank = 1
LEFT JOIN Prices AS SecondMostExp
	ON p.ProductID = SecondMostExp.ProductID
		AND SecondMostExp.PriceRank = 2
		AND MostExp.LastReceiptCost <> SecondMostExp.LastReceiptCost
WHERE SecondMostExp.ProductID IS NOT NULL;

SELECT * 
FROM #ProductVendor2
ORDER BY ProductID;
---------------------------------------------------------------------------
-- 54.  Solution 1 to Challenge Question "Sales Order Counts"  

USE AdventureWorks2022;

DROP TABLE IF EXISTS #data;

WITH Data1 AS
	( SELECT
		p.LastName 
		,FY =		'FY' + CONVERT (CHAR (4), YEAR (DATEADD (MONTH, 6, (OrderDate))))
		,s.SalesOrderID
	FROM Sales.SalesOrderHeader AS s
	INNER JOIN Person.Person AS p 
		ON s.SalesPersonID = p.BusinessEntityID
	WHERE s.OnlineOrderFlag = 0 ) 

SELECT 
	LastName
	,FY2012
	,FY2013
	,FY2014
	,BestYear = GREATEST (FY2012, FY2013, FY2014)
FROM Data1
PIVOT (COUNT (Data1.SalesOrderID)
	FOR FY IN (FY2012, FY2013, FY2014)) AS X1
ORDER BY LastName;
---------------------------------------------------------------------------
-- 54.  Solution 2 to Challenge Question "Sales Order Counts"  

USE AdventureWorks2022;

SELECT *, BestYear = GREATEST (FY2012, FY2013, FY2014)
FROM ( SELECT 
		     p.LastName
		     ,FY2012 = SUM (
                       CASE 
                          WHEN YEAR (DATEADD (MONTH, 6, (OrderDate))) = 2012 
                             THEN 1 ELSE 0 END)

		     ,FY2013 = SUM (
                       CASE WHEN YEAR (DATEADD (MONTH, 6, (OrderDate))) = 2013 
                              THEN 1 ELSE 0 END)

		     ,FY2014 = SUM (
                       CASE WHEN YEAR (DATEADD (MONTH, 6, (OrderDate))) = 2014 
                               THEN 1 ELSE 0 END)
	  
        FROM Sales.SalesOrderHeader s
	     INNER JOIN Person.Person AS p 
	  	      ON s.SalesPersonID = p.BusinessEntityID
	     WHERE s.OnlineOrderFlag = 0
	     GROUP BY p.LastName ) AS X1

ORDER BY LastName;
---------------------------------------------------------------------------
-- 54.  Solution 3 to Challenge Question "Sales Order Counts"  

USE AdventureWorks2022;

WITH Data1 AS 
	( SELECT 
		p.LastName

		,FY2012 = SUM (CASE WHEN YEAR (DATEADD (MONTH, 6, s.OrderDate)) = 2012 
                   THEN 1 ELSE 0 END)

		,FY2013 = SUM (CASE WHEN YEAR (DATEADD (MONTH, 6, s.OrderDate)) = 2013 
                    THEN 1 ELSE 0 END)

		,FY2014 = SUM (CASE WHEN YEAR (DATEADD (MONTH, 6, s.OrderDate)) = 2014 
                    THEN 1 ELSE 0 END)
	FROM Sales.SalesOrderHeader s
	INNER JOIN Person.Person AS p 
	    ON s.SalesPersonID = p.BusinessEntityID
	WHERE s.OnlineOrderFlag = 0
	GROUP BY p.LastName )
	
SELECT *, BestYear = (SELECT MAX (FY) 
					        FROM (VALUES (FY2012), (FY2013), (FY2014)) AS v (FY)) 
FROM Data1
ORDER BY LastName;
---------------------------------------------------------------------------
-- 55.  Solution 1 to Challenge Question "Orphan Products/Vendors" (Part I) 

USE AdventureWorks2022;

DROP TABLE IF EXISTS #data;
GO

SELECT DISTINCT
	p.ProductID
	,ProductName = p.[Name]
	,VendorName =  v.[Name]
	,v.ActiveFlag						
INTO #data
FROM Production.Product AS p
FULL JOIN Purchasing.ProductVendor AS pv
	ON p.ProductID = pv.ProductID
FULL JOIN Purchasing.Vendor AS v
	ON pv.BusinessEntityID = v.BusinessEntityID;

SELECT * 
FROM #data
ORDER BY ProductID;
---------------------------------------------------------------------------
-- 55.  Solution 2 to Challenge Question "Orphan Products/Vendors" (Part I) 

USE AdventureWorks2022;

DROP TABLE IF EXISTS #data2;
GO

SELECT DISTINCT
    ProductID
    ,ProductName 
    ,VendorName
    ,ActiveFlag
INTO #data2
FROM (
		SELECT
			p.ProductID
			,ProductName =	p.[Name]
			,VendorName =	v.[Name]
			,v.ActiveFlag
		FROM Production.Product AS p
		LEFT JOIN Purchasing.ProductVendor AS pv
			ON p.ProductID = pv.ProductID
		LEFT JOIN Purchasing.Vendor AS v
			ON pv.BusinessEntityID = v.BusinessEntityID

		UNION

		SELECT 
			p.ProductID
			,ProductName = p.[Name]
			,VendorName =  v.[Name]
			,v.ActiveFlag
		FROM Purchasing.Vendor AS v
		LEFT JOIN Purchasing.ProductVendor AS pv
			ON v.BusinessEntityID = pv.BusinessEntityID
		LEFT JOIN Production.Product AS p 
			ON pv.ProductID = p.ProductID
	) AS X1;

SELECT * 
FROM #data2
ORDER BY ProductID;
---------------------------------------------------------------------------
-- 55.  Solution 1 to Challenge Question "Orphan Products/Vendors" (Part II) 

ALTER TABLE #data
ADD [Product/Vendor Status] VARCHAR (50);

GO

UPDATE #data
SET [Product/Vendor Status] = 
	CASE 
		WHEN ProductName IS NOT NULL AND VendorName IS NOT NULL 
			THEN 'Product with Associated Vendor' 
		WHEN ProductName IS NOT NULL AND VendorName IS NULL 
			THEN 'Product WITHOUT an Associated Vendor'
		WHEN ProductName IS NULL AND VendorName IS NOT NULL 
			THEN 'Vendor WITHOUT an Associated Product'
	END;

SELECT
	X1.[Product/Vendor Status]
	,[Count] = COUNT (*)
FROM ( SELECT DISTINCT ProductID, VendorName, [Product/Vendor Status]
       FROM #data ) AS X1
GROUP BY [Product/Vendor Status]
ORDER BY [Count] DESC;
---------------------------------------------------------------------------
-- 55.  Solution 2 to Challenge Question "Orphan Products/Vendors" (Part II) 

USE AdventureWorks2022;

WITH Labels AS 
	( SELECT *
		,[Product/Vendor Status] = 
			CASE 
				WHEN ProductName IS NOT NULL AND VendorName IS NOT NULL 
               THEN 'Product with Associated Vendor' 
				WHEN ProductName IS NOT NULL AND VendorName IS NULL 
               THEN 'Product WITHOUT an Associated Vendor'
				WHEN ProductName IS NULL AND VendorName IS NOT NULL 
               THEN 'Vendor WITHOUT an Associated Product'
			END
	FROM #data2 )

SELECT
	[Product/Vendor Status]
	,[Count] = COUNT (*)
FROM Labels
GROUP BY [Product/Vendor Status]
ORDER BY [Count] DESC;
---------------------------------------------------------------------------
-- 56.  Solution to Challenge Question: Calendar of Work Days  

USE AdventureWorks2022;

DROP TABLE IF EXISTS HumanResources.Calendar;

CREATE TABLE HumanResources.Calendar 
	(DateID			INT NOT NULL PRIMARY KEY		
	,[Date]			DATE			
	,[Year]			INT				
	,TextMonth		VARCHAR (25)	
	,[DayOfMonth]	TINYINT			
	,[DayOfWeek]	VARCHAR (50)	
	,IsBusinessDay	BIT				
	,IsHoliday		BIT	DEFAULT 0
	,HolidayName	VARCHAR (50) );

DECLARE @StartDate DATETIME =	'1990-01-01';
DECLARE @EndDate DATETIME =		'2034-12-31';

DECLARE @TotalDays INT = DATEDIFF (DAY, @StartDate, @EndDate) + 1;                 

DECLARE @Index INT = 1;

WHILE @Index <= @TotalDays
BEGIN
	INSERT HumanResources.Calendar (DateID, [Date])
		SELECT 
			DateID = @Index
			,[Date] = DATEADD (DAY, @Index - 1, @StartDate);
	SET @Index = @Index + 1;
END; 

UPDATE HumanResources.Calendar  
SET
   [Year] =			   YEAR ([Date])
	,TextMonth	=	   DATENAME (MONTH, [Date])
	,[DayOfMonth] =		DAY ([Date])
	,[DayOfWeek] =		DATENAME (DW, [Date])
	,IsBusinessDay =	CASE WHEN DATENAME (DW, [Date]) IN ('Saturday', 'Sunday') THEN 0 ELSE 1 END;

-- New Year's Day, January 1. 
WITH Data1 AS 
	( SELECT
		[Date]
		,[Year]
		,[DayOfWeek]
		,ConclusionHolidayDate = 
			CASE 
				WHEN [DayOfWeek] IN ('Saturday', 'Sunday') 
					THEN (SELECT MIN (X1.[Date]) 
						   FROM HumanResources.Calendar AS X1
						   WHERE X1.[DayOfWeek] = 'Monday' 
							   AND X1.[Date] > c.[Date] ) 
				ELSE [Date]
			END

	 FROM HumanResources.Calendar AS c
	 WHERE TextMonth = 'January' AND [DayOfMonth] = 1 )


UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'New Year''s Day'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.ConclusionHolidayDate;
------------------------------------
-- MLK: 3rd Monday in January
WITH Data1 AS 
	(SELECT *
      ,MondayCount = ROW_NUMBER () OVER (PARTITION BY [Year] ORDER BY [Date])
	 FROM HumanResources.Calendar
	 WHERE TextMonth = 'January' AND [DayOfWeek] = 'Monday' )

UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'Martin Luther King''s Birthday'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.[Date]	
		AND d1.MondayCount = 3;
------------------------------------
-- Washington's Birthday: 3rd Monday in February
WITH Data1 AS 
	(SELECT *, MondayCount = ROW_NUMBER () OVER (PARTITION BY [Year] ORDER BY [Date])
	 FROM HumanResources.Calendar
	 WHERE TextMonth = 'February' 
		AND [DayOfWeek] = 'Monday' )

UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'Washington''s Birthday'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.[Date]	
		AND d1.MondayCount = 3;
------------------------------------
-- Memorial Day: Last Monday in May
WITH 
	Data1 AS 
		(SELECT *
			,MondayCount = ROW_NUMBER () OVER (PARTITION BY [Year] ORDER BY [Date] DESC)
		 FROM HumanResources.Calendar
		 WHERE TextMonth = 'May' AND [DayOfWeek] = 'Monday' )
		
UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'Memorial Day'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.[Date]	
		AND d1.MondayCount = 1;
------------------------------------
-- Juneteenth: June 19
WITH Data1 AS 
	( SELECT
		[Date]
		,[Year]
		,[DayOfWeek]
		,ConclusionHolidayDate = 
			CASE 
				WHEN [DayOfWeek] IN ('Saturday', 'Sunday') 
					THEN (SELECT MIN (X1.[Date]) 
						  FROM HumanResources.Calendar AS X1
						  WHERE X1.[DayOfWeek] = 'Monday' 
							AND X1.[Date] > c.[Date] ) 
					ELSE [Date]
			END

	 FROM HumanResources.Calendar AS c
	 WHERE TextMonth = 'June' AND [DayOfMonth] = 19 )

UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'Juneteenth National Independence Day'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.ConclusionHolidayDate;

-- Independence Day: July 4
WITH Data1 AS 
	( SELECT
		[Date]
		,[Year]
		,[DayOfWeek]
		,ConclusionHolidayDate = 
			CASE 
				WHEN [DayOfWeek] IN ('Saturday', 'Sunday') 
					THEN (SELECT MIN (X1.[Date]) 
						  FROM HumanResources.Calendar AS X1
						  WHERE X1.[DayOfWeek] = 'Monday' 
							AND X1.[Date] > c.[Date] ) 
					ELSE [Date]
			END

	 FROM HumanResources.Calendar AS c
	 WHERE TextMonth = 'July' AND [DayOfMonth] = 4 )

UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'Independence Day'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.ConclusionHolidayDate;
------------------------------------
-- Labor Day: 1st Monday in September
WITH Data1 AS 
	(SELECT *, MondayCount = ROW_NUMBER () OVER (PARTITION BY [Year] ORDER BY [Date])
	 FROM HumanResources.Calendar
	 WHERE TextMonth = 'September' AND [DayOfWeek] = 'Monday' )

UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'Labor Day'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.[Date]	
		AND d1.MondayCount = 1;

-- Columbus Day: 2nd Monday in October
WITH Data1 AS 
	(SELECT [Date], MondayCount = ROW_NUMBER () OVER (PARTITION BY [Year] 
													  ORDER BY [Date])
	 FROM HumanResources.Calendar
	 WHERE TextMonth = 'October' AND [DayOfWeek] = 'Monday' )

UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'Columbus Day'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.[Date]	
		AND d1.MondayCount = 2;
------------------------------------
-- Veterans's Day: November 11
WITH Data1 AS 
	( SELECT
		[Date]
		,[Year]
		,[DayOfWeek]
		,ConclusionHolidayDate = 
			CASE 
				WHEN [DayOfWeek] IN ('Saturday', 'Sunday') 
					THEN (SELECT MIN (X1.[Date]) 
						  FROM HumanResources.Calendar AS X1
						  WHERE X1.[DayOfWeek] = 'Monday' 
							AND X1.[Date] > c.[Date] ) 
					ELSE [Date]
			END

	 FROM HumanResources.Calendar AS c
	 WHERE TextMonth = 'November' AND [DayOfMonth] = 11 )

UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'Veterans Day'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.ConclusionHolidayDate;

-- Thanksgiving: 4th Thursday in November
WITH Data1 AS 
	(SELECT [Date], MondayCount = ROW_NUMBER () OVER (PARTITION BY [Year] 
                                                     ORDER BY [Date])
	 FROM HumanResources.Calendar
	 WHERE TextMonth = 'November' AND [DayOfWeek] = 'Thursday' )

UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'Thanksgiving Day'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.[Date]	
		AND d1.MondayCount = 4;
------------------------------------
-- Christmas: December 25
WITH Data1 AS 
	( SELECT
		[Date]
		,[Year]
		,[DayOfWeek]
		,ConclusionHolidayDate = 
			CASE 
				WHEN [DayOfWeek] IN ('Saturday', 'Sunday') 
					THEN (SELECT MIN (X1.[Date]) 
						   FROM HumanResources.Calendar AS X1
						   WHERE X1.[DayOfWeek] = 'Monday' 
							  AND X1.[Date] > c.[Date] ) 
					ELSE [Date] END

	 FROM HumanResources.Calendar AS c
	 WHERE TextMonth = 'December' AND [DayOfMonth] = 25 )

UPDATE c
SET 
	IsBusinessDay = 0
	,IsHoliday =		1
	,HolidayName = 'Christmas Day'
FROM HumanResources.Calendar AS c
INNER JOIN Data1 AS d1
	ON c.[Date] = d1.ConclusionHolidayDate;

SELECT
	[Year]
	,BusinessDays =		SUM (CONVERT (TINYINT, IsBusinessDay))
	
   ,WeekendDays =		
       SUM (CASE WHEN [DayOfWeek] IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END)
	
,Holidays = SUM (CONVERT (TINYINT, IsHoliday))
FROM HumanResources.Calendar
GROUP BY [Year]
ORDER BY [Year];
---------------------------------------------------------------------------
/*

Bonus: "Simple Twist of Fate" 
(Impossible to execute because life doesn't actually work like this. 
For SQL thought experiment purposes only)   


SELECT 
	s.Person_ID
	,s.Situation_ID
	,s.Original_Outcome_ID
	,t.Twist
	,New_Outcome_ID =		s.Original_Outcome_ID + ISNULL (t.Twist, 0)
	,New_Outcome =			o.Outcome_Descr
FROM Situation AS s 

OUTER APPLY ( SELECT TOP 1 Person_ID, Twist
			     FROM Twists AS X1
			     WHERE s.Person_ID = X1.Person_ID
			 	    AND X1.Expiration > GETDATE ()
			     ORDER BY NEWID () ) AS t

LEFT JOIN Outcomes AS o 
    ON s.Original_Outcome_ID + ISNULL (t.Twist, 0) = o.Outcome_ID 

WHERE s.Person_ID = @Person_ID
	AND s.Situation_ID = @Situation_ID;

---------------------------------------------------------------------------
Bonus: "Friend of the Devil" 
(Impossible to execute because life doesn't actually work like this. 
For SQL thought experiment purposes only)   


DECLARE @Basis_Person VARCHAR (50) = 'Brian';

DROP TABLE IF EXISTS #Devil_Friends;

WITH Data1 AS 
	(SELECT 
		Row_ID
		,Cleaned_Up_Journal_Entry = REPLACE (TRANSLATE (Notes, ',?.''', '****'), '*', '')
	 FROM Devil_Social_Journal )

SELECT 
	Raw_Name =				s.[value]
	,English_Name =		    ISNULL (d.Real_Name, e.[Name])
	,Friend_of_the_Devil =	e.[Name]
INTO #Devil_Friends
FROM Data1 AS d1
CROSS APPLY STRING_SPLIT (d1.Cleaned_Up_Journal_Entry, ' ') AS s
LEFT JOIN Devil_Friend_Nicknames AS d 
    ON TRIM (s.[value]) = d.Nickname
INNER JOIN English_Names AS e 
    ON COALESCE (Real_Name, s.[value]) = e.[Name]; 

WITH Data2 AS 
	( SELECT DISTINCT d.Friend_of_the_Devil
	  FROM #Devil_Friends AS d
	  LEFT JOIN Person_Friendships AS p 
		ON p.Person1 = @Basis_Person
			AND p.Active = 1 
			AND d.Friend_of_the_Devil = p.Person2
	  LEFT JOIN Person_Friendships AS p2 
		ON p2.Person2 = @Basis_Person 
			AND p2.Active = 1 
			AND d.Friend_of_the_Devil = p2.Person1 
	  WHERE COALESCE (p.Person1, p2.Person1) IS NULL )

INSERT Person_Friendships (Person1, Person2, [Source])
	
	SELECT 
		Person1 =	@Basis_Person
		,Person2 =	Friend_of_the_Devil
		,[Source] =	'Devil Referral'
	FROM Data2;                                      
	

	*/
---------------------------------------------------------------------------