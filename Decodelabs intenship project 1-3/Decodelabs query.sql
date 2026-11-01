--------------------------------------
--PROJECT 3: DATASET EXPLORATION
--QUERY ; VIEWING THE COMPLETE DATASET
--------------------------------------
Select
  *
From
  Decodelabs



-- ============================================
-- DATA CLEANING
-- QUERY 1: CHECK FOR DUPLICATE ORDER IDs
-- ============================================

SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM decodelabs
GROUP BY OrderID
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;




-- ============================================
-- DATA CLEANING
-- QUERY 2: CHECK FOR MISSING VALUES
-- ============================================
SELECT
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN [Customer ID] IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN OrderID IS NULL THEN 1 ELSE 0 END) AS MissingOrderID,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS MissingQuantity,
    SUM(CASE WHEN TotalPrice IS NULL THEN 1 ELSE 0 END) AS MissingTotalPrice,
    SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS MissingDate,
    SUM(CASE WHEN Product IS NULL THEN 1 ELSE 0 END) AS MissingProduct,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS MissingUnitPrice,
    SUM(CASE WHEN PaymentMethod IS NULL THEN 1 ELSE 0 END) AS MissingPaymentMethod,
    SUM(CASE WHEN OrderStatus IS NULL THEN 1 ELSE 0 END) AS MissingOrderStatus,
    SUM(CASE WHEN CouponCode IS NULL THEN 1 ELSE 0 END) AS MissingCouponCode,
    SUM(CASE WHEN ReferralSource IS NULL THEN 1 ELSE 0 END) AS MissingReferralSource
FROM decodelabs;




-- ============================================
-- DATA CLEANING
-- QUERY 3: CHECK FOR BLANK VALUES
-- ============================================

SELECT
    SUM(CASE WHEN LTRIM(RTRIM([Customer ID])) = '' THEN 1 ELSE 0 END) AS BlankCustomerID,
    SUM(CASE WHEN LTRIM(RTRIM(OrderID)) = '' THEN 1 ELSE 0 END) AS BlankOrderID,
    SUM(CASE WHEN LTRIM(RTRIM(Product)) = '' THEN 1 ELSE 0 END) AS BlankProduct,
    SUM(CASE WHEN LTRIM(RTRIM(PaymentMethod)) = '' THEN 1 ELSE 0 END) AS BlankPaymentMethod,
    SUM(CASE WHEN LTRIM(RTRIM(OrderStatus)) = '' THEN 1 ELSE 0 END) AS BlankOrderStatus,
    SUM(CASE WHEN LTRIM(RTRIM(CouponCode)) = '' THEN 1 ELSE 0 END) AS BlankCouponCode,
    SUM(CASE WHEN LTRIM(RTRIM(ReferralSource)) = '' THEN 1 ELSE 0 END) AS BlankReferralSource
FROM decodelabs;





-----------------------------------------------------
--BUSINESS QUESTION1: CUTOMER VALUE ANALYSIS
--QUERY 1; WHICH CUTOMERS GENERATE THE HIGHEST TOTAL
--ORDER VALUE?
-----------------------------------------------------
Select
  [Customer ID],
  count(OrderID)  AS TotalOrders,
  sum(Quantity)   AS TotalQuantity,
  Round(Sum(TotalPrice),2) AS TotalCustomerValue,
  Round(AVG(TotalPrice),2) AS AverageOrderValue

From
  Decodelabs

Group By [Customer ID]

Order by TotalCustomerValue Desc;



-----------------------------------------------------
--BUSINESS QUESTION1: CUTOMER VALUE ANALYSIS
--QUERY 2; TOP 10 CUSTOMER BY TOTAL PURCHASE VALUE
-----------------------------------------------------
Select Top 10
  [Customer ID],
  count(OrderID)  AS TotalOrders,
  sum(Quantity)   AS TotalQuantity,
  Round(Sum(TotalPrice),2) AS TotalCustomerValue
  
From
  Decodelabs

Group By [Customer ID]

Order by TotalCustomerValue Desc;



-- ============================================
-- BUSINESS QUESTION 1: CUSTOMER VALUE ANALYSIS
-- QUERY 3: TOP 10 CUSTOMERS' PERCENTAGE OF TOTAL ORDER VALUE
-- ============================================

SELECT
    ROUND(SUM(Top10.TotalCustomerValue), 2) AS Top10CustomerValue,
    ROUND(
        (SUM(Top10.TotalCustomerValue) * 100.0) /
        (SELECT SUM(TotalPrice) FROM decodelabs),
        2
    ) AS Top10PercentageOfTotal
FROM (
    SELECT TOP 10
        [Customer ID],
        SUM(TotalPrice) AS TotalCustomerValue
    FROM decodelabs
    GROUP BY [Customer ID]
    ORDER BY SUM(TotalPrice) DESC
) AS Top10;




-- ============================================
-- BUSINESS QUESTION 2: REPEAT PURCHASE ANALYSIS
-- QUERY 1: IDENTIFYING REPEAT CUSTOMERS
-- ============================================

SELECT
    [Customer ID],
    COUNT(OrderID) AS TotalOrders
FROM decodelabs
GROUP BY [Customer ID]
HAVING COUNT(OrderID) > 1
ORDER BY TotalOrders DESC;





-- ============================================
-- BUSINESS QUESTION 2: REPEAT PURCHASE ANALYSIS
-- QUERY 2: TOTAL NUMBER OF REPEAT CUSTOMERS
-- ============================================

SELECT
    COUNT(*) AS TotalRepeatCustomers
FROM (
    SELECT
        [Customer ID]
    FROM decodelabs
    GROUP BY [Customer ID]
    HAVING COUNT(OrderID) > 1
) AS RepeatCustomers;





-- ============================================
-- BUSINESS QUESTION 2: REPEAT PURCHASE ANALYSIS
-- QUERY 3: REPEAT PURCHASE RATE
-- ============================================

SELECT
    COUNT(*) AS TotalCustomers,
    SUM(CASE
        WHEN TotalOrders > 1 THEN 1
        ELSE 0
    END) AS RepeatCustomers,

    ROUND(
        SUM(CASE
            WHEN TotalOrders > 1 THEN 1.0
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS RepeatPurchaseRate
FROM (
    SELECT
        [Customer ID],
        COUNT(OrderID) AS TotalOrders
    FROM decodelabs
    GROUP BY [Customer ID]
) AS CustomerOrders;




-- ============================================
-- BUSINESS QUESTION 2: CUSTOMER RETENTION
-- QUERY 3: CUSTOMERS WHO PURCHASED ONLY ONCE
-- ============================================

SELECT
    COUNT(*) AS OneTimeCustomers
FROM (
    SELECT
        [Customer ID]
    FROM decodelabs
    GROUP BY [Customer ID]
    HAVING COUNT(OrderID) = 1
) AS OneTimeBuyers;




-- ============================================
-- BUSINESS QUESTION 2: CUSTOMER RETENTION
-- QUERY 4: CUSTOMERS WHO PURCHASED TWICE
-- ============================================

SELECT
    COUNT(*) AS TwoTimeCustomers
FROM (
    SELECT
        [Customer ID]
    FROM decodelabs
    GROUP BY [Customer ID]
    HAVING COUNT(OrderID) = 2
) AS TwoTimeBuyers;




-- ============================================
-- BUSINESS QUESTION 2: CUSTOMER RETENTION
-- QUERY 5: CUSTOMERS WHO PURCHASED THREE TIMES OR MORE
-- ============================================

SELECT
    COUNT(*) AS CustomersWithThreeOrMoreOrders
FROM (
    SELECT
        [Customer ID]
    FROM decodelabs
    GROUP BY [Customer ID]
    HAVING COUNT(OrderID) >= 3
) AS FrequentBuyers;



-- ============================================
-- BUSINESS QUESTION 2: CUSTOMER RETENTION
-- QUERY 7: CUSTOMERS WHO PURCHASED EVERY YEAR
-- ============================================

SELECT
    [Customer ID],
    COUNT(OrderID) AS TotalOrders,
    COUNT(DISTINCT YEAR([Date])) AS YearsActive
FROM decodelabs
GROUP BY [Customer ID]
HAVING COUNT(DISTINCT YEAR([Date])) =
(
    SELECT COUNT(DISTINCT YEAR([Date]))
    FROM decodelabs
)
ORDER BY YearsActive DESC, TotalOrders DESC;




-- ============================================
-- BUSINESS QUESTION 2: CUSTOMER RETENTION
-- QUERY 8: CUSTOMERS WHO STOPPED PURCHASING
-- ============================================

SELECT
    [Customer ID],
    MAX([Date]) AS LastPurchaseDate,
    COUNT(OrderID) AS TotalOrders
FROM decodelabs
GROUP BY [Customer ID]
HAVING MAX([Date]) < DATEADD(
    DAY,
    -90,
    (SELECT MAX([Date]) FROM decodelabs)
)
ORDER BY LastPurchaseDate ASC;




-- ============================================
-- BUSINESS QUESTION 3: CUSTOMER ACQUISITION SOURCES
-- QUERY 1: CUSTOMERS BY REFERRAL SOURCE
-- ============================================

SELECT
    ReferralSource,
    COUNT(DISTINCT [Customer ID]) AS TotalCustomers
FROM decodelabs
GROUP BY ReferralSource
ORDER BY TotalCustomers DESC;



-- ============================================
-- BUSINESS QUESTION 3: CUSTOMER ACQUISITION SOURCES
-- QUERY 2: TOTAL ORDER VALUE BY REFERRAL SOURCE
-- ============================================

SELECT
    ReferralSource,
    COUNT(DISTINCT [Customer ID]) AS TotalCustomers,
    COUNT(OrderID) AS TotalOrders,
    ROUND(SUM(TotalPrice), 2) AS TotalOrderValue
FROM decodelabs
GROUP BY ReferralSource
ORDER BY TotalOrderValue DESC;




-- ============================================
-- BUSINESS QUESTION 3: CUSTOMER ACQUISITION SOURCES
-- QUERY 3: REPEAT CUSTOMERS BY REFERRAL SOURCE
-- ============================================

SELECT
    ReferralSource,
    COUNT(*) AS RepeatCustomers
FROM (
    SELECT
        [Customer ID],
        ReferralSource,
        COUNT(OrderID) AS TotalOrders
    FROM decodelabs
    GROUP BY [Customer ID], ReferralSource
    HAVING COUNT(OrderID) > 1
) AS RepeatBuyers
GROUP BY ReferralSource
ORDER BY RepeatCustomers DESC;




-- ============================================
-- BUSINESS QUESTION 3: CUSTOMER ACQUISITION SOURCES
-- QUERY 4: AVERAGE CUSTOMER SPENDING BY REFERRAL SOURCE
-- ============================================

SELECT
    ReferralSource,
    COUNT(*) AS TotalCustomers,
    ROUND(AVG(CustomerSpending), 2) AS AverageCustomerSpending
FROM (
    SELECT
        [Customer ID],
        ReferralSource,
        SUM(TotalPrice) AS CustomerSpending
    FROM decodelabs
    GROUP BY [Customer ID], ReferralSource
) AS CustomerValues
GROUP BY ReferralSource
ORDER BY AverageCustomerSpending DESC;



-- ============================================
-- BUSINESS QUESTION 3: CUSTOMER ACQUISITION SOURCES
-- QUERY 5: REPEAT PURCHASE RATE BY REFERRAL SOURCE
-- ============================================

SELECT
    ReferralSource,
    COUNT(*) AS TotalCustomers,
    SUM(CASE
        WHEN TotalOrders > 1 THEN 1
        ELSE 0
    END) AS RepeatCustomers,
    ROUND(
        SUM(CASE
            WHEN TotalOrders > 1 THEN 1.0
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS RepeatPurchaseRate
FROM (
    SELECT
        [Customer ID],
        ReferralSource,
        COUNT(OrderID) AS TotalOrders
    FROM decodelabs
    GROUP BY [Customer ID], ReferralSource
) AS CustomerSummary
GROUP BY ReferralSource
ORDER BY RepeatPurchaseRate DESC;





-- ============================================
-- BUSINESS QUESTION 4: PAYMENT BEHAVIOUR
-- QUERY 1: ORDERS BY PAYMENT METHOD
-- ============================================

SELECT
    PaymentMethod,
    COUNT(OrderID) AS TotalOrders
FROM decodelabs
GROUP BY PaymentMethod
ORDER BY TotalOrders DESC;




-- ============================================
-- BUSINESS QUESTION 4: PAYMENT BEHAVIOUR
-- QUERY 2: TOTAL ORDER VALUE BY PAYMENT METHOD
-- ============================================

SELECT
    PaymentMethod,
    COUNT(OrderID) AS TotalOrders,
    ROUND(SUM(TotalPrice), 2) AS TotalOrderValue
FROM decodelabs
GROUP BY PaymentMethod
ORDER BY TotalOrderValue DESC;



-- ============================================
-- BUSINESS QUESTION 4: PAYMENT BEHAVIOUR
-- QUERY 3: AVERAGE ORDER VALUE BY PAYMENT METHOD
-- ============================================

SELECT
    PaymentMethod,
    COUNT(OrderID) AS TotalOrders,
    ROUND(AVG(TotalPrice), 2) AS AverageOrderValue
FROM decodelabs
GROUP BY PaymentMethod
ORDER BY AverageOrderValue DESC;





-- ============================================
-- BUSINESS QUESTION 4: PAYMENT BEHAVIOUR
-- QUERY 4: CUSTOMERS BY PAYMENT METHOD
-- ============================================

SELECT
    PaymentMethod,
    COUNT(DISTINCT [Customer ID]) AS TotalCustomers
FROM decodelabs
GROUP BY PaymentMethod
ORDER BY TotalCustomers DESC;






-- ============================================
-- BUSINESS QUESTION 4: PAYMENT BEHAVIOUR
-- QUERY 5: PAYMENT METHOD BY ORDER STATUS
-- ============================================

SELECT
    PaymentMethod,
    OrderStatus,
    COUNT(OrderID) AS TotalOrders,
    ROUND(SUM(TotalPrice), 2) AS TotalOrderValue
FROM decodelabs
GROUP BY
    PaymentMethod,
    OrderStatus
ORDER BY
    PaymentMethod,
    TotalOrders DESC;







    -- ============================================
-- BUSINESS QUESTION 5: ORDER STATUS INVESTIGATION
-- QUERY 1: ORDER DISTRIBUTION BY STATUS
-- ============================================

SELECT
    OrderStatus,
    COUNT(OrderID) AS TotalOrders
FROM decodelabs
GROUP BY OrderStatus
ORDER BY TotalOrders DESC;





-- ============================================
-- BUSINESS QUESTION 5: ORDER STATUS INVESTIGATION
-- QUERY 1: ORDER DISTRIBUTION BY STATUS
-- ============================================

SELECT
    OrderStatus,
    COUNT(OrderID) AS TotalOrders
FROM decodelabs
GROUP BY OrderStatus
ORDER BY TotalOrders DESC;





-- ============================================
-- BUSINESS QUESTION 5: ORDER STATUS INVESTIGATION
-- QUERY 3: ORDER STATUS PERCENTAGE DISTRIBUTION
-- ============================================

SELECT
    OrderStatus,
    COUNT(OrderID) AS TotalOrders,
    ROUND(
        COUNT(OrderID) * 100.0 /
        (SELECT COUNT(OrderID) FROM decodelabs),
        2
    ) AS OrderStatusPercentage
FROM decodelabs
GROUP BY OrderStatus
ORDER BY OrderStatusPercentage DESC;






-- ============================================
-- BUSINESS QUESTION 5: ORDER STATUS INVESTIGATION
-- QUERY 4: CANCELLED AND RETURNED ORDERS
-- ============================================

SELECT
    OrderID,
    [Customer ID],
    Product,
    OrderStatus,
    TotalPrice
FROM decodelabs
WHERE OrderStatus IN ('Cancelled', 'Returned')
ORDER BY OrderStatus, TotalPrice DESC;






-- ============================================
-- BUSINESS QUESTION 5: ORDER STATUS INVESTIGATION
-- QUERY 5: CANCELLED AND RETURNED ORDERS BY PRODUCT
-- ============================================

SELECT
    Product,
    OrderStatus,
    COUNT(OrderID) AS TotalOrders,
    ROUND(SUM(TotalPrice), 2) AS TotalOrderValue
FROM decodelabs
WHERE OrderStatus IN ('Cancelled', 'Returned')
GROUP BY
    Product,
    OrderStatus
ORDER BY TotalOrders DESC;





-- ============================================
-- BUSINESS QUESTION 5: ORDER STATUS INVESTIGATION
-- QUERY 6: CUSTOMERS WITH MOST CANCELLED AND RETURNED ORDERS
-- ============================================

SELECT
    [Customer ID],
    OrderStatus,
    COUNT(OrderID) AS TotalOrders
FROM decodelabs
WHERE OrderStatus IN ('Cancelled', 'Returned')
GROUP BY [Customer ID], OrderStatus
ORDER BY TotalOrders DESC;








-- ============================================
-- BUSINESS QUESTION 6: YEARLY CUSTOMER BEHAVIOUR
-- QUERY 1: TOTAL ORDERS AND ORDER VALUE BY YEAR
-- ============================================

SELECT
    YEAR([Date]) AS OrderYear,
    COUNT(OrderID) AS TotalOrders,
    COUNT(DISTINCT [Customer ID]) AS TotalCustomers,
    ROUND(SUM(TotalPrice), 2) AS TotalOrderValue
FROM decodelabs
GROUP BY YEAR([Date])
ORDER BY OrderYear;







-- ============================================
-- BUSINESS QUESTION 6: YEARLY CUSTOMER BEHAVIOUR
-- QUERY 2: NEW CUSTOMERS ACQUIRED EACH YEAR
-- ============================================

SELECT
    FirstPurchaseYear,
    COUNT([Customer ID]) AS NewCustomers
FROM (
    SELECT
        [Customer ID],
        YEAR(MIN([Date])) AS FirstPurchaseYear
    FROM decodelabs
    GROUP BY [Customer ID]
) AS CustomerFirstPurchase
GROUP BY FirstPurchaseYear
ORDER BY FirstPurchaseYear;






-- ============================================
-- BUSINESS QUESTION 6: YEARLY CUSTOMER BEHAVIOUR
-- QUERY 3: REPEAT CUSTOMERS BY YEAR
-- ============================================

SELECT
    OrderYear,
    COUNT(*) AS RepeatCustomers
FROM (
    SELECT
        [Customer ID],
        YEAR([Date]) AS OrderYear,
        COUNT(OrderID) AS TotalOrders
    FROM decodelabs
    GROUP BY [Customer ID], YEAR([Date])
    HAVING COUNT(OrderID) > 1
) AS YearlyCustomerOrders
GROUP BY OrderYear
ORDER BY OrderYear;




-- ============================================
-- BUSINESS QUESTION 6: YEARLY CUSTOMER BEHAVIOUR
-- QUERY 4: AVERAGE ORDER VALUE BY YEAR
-- ============================================

SELECT
    YEAR([Date]) AS OrderYear,
    COUNT(OrderID) AS TotalOrders,
    ROUND(AVG(TotalPrice), 2) AS AverageOrderValue
FROM decodelabs
GROUP BY YEAR([Date])
ORDER BY OrderYear;







-- ============================================
-- BUSINESS QUESTION 6: YEARLY CUSTOMER BEHAVIOUR
-- QUERY 5: NEW VS RETURNING CUSTOMERS BY YEAR
-- ============================================

SELECT
    YEAR(d.[Date]) AS OrderYear,
    COUNT(DISTINCT CASE
        WHEN YEAR(d.[Date]) = f.FirstPurchaseYear
        THEN d.[Customer ID]
    END) AS NewCustomers,
    COUNT(DISTINCT CASE
        WHEN YEAR(d.[Date]) > f.FirstPurchaseYear
        THEN d.[Customer ID]
    END) AS ReturningCustomers
FROM decodelabs AS d
INNER JOIN (
    SELECT
        [Customer ID],
        YEAR(MIN([Date])) AS FirstPurchaseYear
    FROM decodelabs
    GROUP BY [Customer ID]
) AS f
    ON d.[Customer ID] = f.[Customer ID]
GROUP BY YEAR(d.[Date])
ORDER BY OrderYear;





-- ============================================
-- BUSINESS QUESTION 6: OUTLIER AND UNUSUAL BEHAVIOUR
-- QUERY 1: IDENTIFY UNUSUALLY HIGH ORDER VALUES
-- ============================================

SELECT
    OrderID,
    [Customer ID],
    Product,
    Round(TotalPrice,2)
FROM decodelabs
WHERE TotalPrice > (
    SELECT AVG(TotalPrice) + 2 * STDEV(TotalPrice)
    FROM decodelabs
)
ORDER BY TotalPrice DESC;