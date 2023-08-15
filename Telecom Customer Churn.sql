/* Dataset provided by Maven Analytics: Telecom Customer Churn */

/* How many customers joined the company during the last quarter?
	What is the customer profile for a customer that churned, joined and stayed? Are they different?
	What seem to be the key drivers of customer churn?
	Is the company losing high value customers? If so, how can they retain them? */

SELECT COUNT(*), Gender
FROM telecom_customer
GROUP BY Gender;
-- Female 3488, Male 3555 (total 7043)

SELECT MAX(Age)
FROM telecom_customer;
-- Oldest customer is 80

SELECT MIN(Age)
FROM telecom_customer;
-- Youngest customer is 19

SELECT COUNT(*),
CASE
	WHEN Age BETWEEN 19 AND 40 THEN 'Age 19 - 40'
	WHEN Age BETWEEN 41 AND 60 THEN 'Age 41 - 60'
	ELSE 'Age 61 - 80'
END AS 'AgeGroups'
FROM telecom_customer
GROUP BY AgeGroups;
-- Age 19-40: 2817 or 40%, Age 41-60: 2564 or 36%, and Age 61-80: 1662 or 24%

SELECT COUNT(*),
CASE
	WHEN TenureinMonths BETWEEN 1 AND 3 THEN '1 quarter'
	WHEN TenureinMonths BETWEEN 4 AND 6 THEN '2 quarters'
	WHEN TenureinMonths BETWEEN 7 AND 9 THEN '3 quarters'
	WHEN TenureinMonths BETWEEN 10 AND 12 THEN '4 quarters'
	WHEN TenureinMonths BETWEEN 13 AND 24 THEN 'one to two years'
	ELSE 'two or more years'
END AS 'TimeAsCustomer'
FROM telecom_customer
GROUP BY TimeAsCustomer;
-- 2186 customers joined in past year: 1051 last quarter, 419 second quarter, 373 third quarter, 343 fourth quarter
-- 1024 customers joined one-two years ago
-- 3833 joined more than two years ago

SELECT COUNT(*), Contract
FROM telecom_customer
GROUP BY Contract;
-- month-to-month contract 3610, one-year contract 1550, two-year contract 1883

SELECT COUNT(*), CustomerStatus
FROM telecom_customer
GROUP BY CustomerStatus
ORDER BY COUNT(*) ASC;
-- 454 joined, 1869 churned, 4720 stayed

SELECT COUNT(*), TenureinMonths
FROM telecom_customer
WHERE CustomerStatus = 'Joined'
GROUP BY TenureinMonths;
-- "Joined" status indicates customer joined in the last quarter (1, 2 or 3 months)

SELECT DISTINCT ChurnCategory
FROM telecom_customer;
-- Reasons for churn: competitor, dissatisfaction, other, price, attitude (as well as 'null')

SELECT COUNT(*), ChurnCategory
FROM telecom_customer
WHERE ChurnCategory IS NOT Null
GROUP BY ChurnCategory
ORDER BY COUNT(*) DESC;
-- Top reason for churn: competitor (841 or 45%)
-- Dissatisfaction 321, Attitude 314, Price 211, Other 182

SELECT COUNT(*), ChurnReason
FROM telecom_customer
WHERE ChurnCategory = 'Competitor'
GROUP BY ChurnReason
ORDER BY COUNT(*) DESC;
-- Competitor had better devices (313), made better offer (311), offered more data (117), offered higher download speeds (100)

SELECT DISTINCT ChurnReason
FROM telecom_customer
WHERE ChurnCategory = 'Other';
-- 'Other' category includes customer moved, customer is deceased, or a response of "don't know"

SELECT CustomerStatus, Gender, COUNT(Gender) AS 'Count', ROUND(AVG(Age),0) AS AVGAge, ROUND(AVG(TenureinMonths),0) AS AVGTenure, ROUND(AVG(MonthlyCharge),2) AS AVGMonthlyCharge, ROUND(AVG(NumberofReferrals),1) AS AVGReferrals
FROM telecom_customer
GROUP BY CustomerStatus, Gender;
-- profiles are similar for women and men in their respective status categories
-- CHURNED: 939 women, 930 men; average age 49 and 50; average tenure 17 and 19 months; average charge $73.61 and $73.09
-- STAYED: 2338 womenm 2382 men; average age 46 for both; average tenure 41 months for both; average charge $62.34 and $61.14
-- difference between Churned and Stayed: those leaving have been customers for a shorter amount of time, and are being charged more; those staying make more referrals

SELECT CustomerStatus, ROUND(AVG(MonthlyCharge),2) AS AVGMonthlyCharge, ROUND(AVG(TotalRevenue),2) AS AVGTotalRevenue
FROM telecom_customer
GROUP BY CustomerStatus;
-- Churned customers are being charged more monthly ($73.35 vs $61.74, but have a lower total revenue ($1971 vs $3736) (likely, due to shorter tenure)

SELECT ChurnReason, COUNT(UnlimitedData) AS 'Count', UnlimitedData
FROM telecom_customer
WHERE ChurnCategory = 'Competitor' AND ChurnReason = 'Competitor offered more data'
GROUP BY ChurnReason, UnlimitedData;
-- of 117 who left because competitor offered more data, 23 did not have unlimited data while 94 did have it