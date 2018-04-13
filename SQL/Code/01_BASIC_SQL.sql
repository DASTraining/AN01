
/* COMMENTING
 multi line */
 
-- single line


/******************************************************************************
REPORT: 
REQUESTER:
DEPARTMENT:
AUTHOR:
DESCRIPTION:

SOURCE:


CALCULATIONS


CHANGE LOG
DATE    FIRST        LAST               CHANGE

*******************************************************************************/

--------------------------------------------------------------------------------
--                            REVIEW TABLES
--------------------------------------------------------------------------------

SELECT *
FROM RPT_MOD.VW_INPRDDTA_INITMMP
WHERE ROWNUM <= 1000

SELECT * 
FROM RPT_MOD.VW_INPRDINV_INWCTLP
WHERE ROWNUM <= 1000

SELECT * 
FROM RPT_MOD.VW_INPRDINV_INVMSTP
WHERE ROWNUM <= 1000


SELECT *
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <=1000

SELECT * 
FROM RPT_MOD.VW_INPRDINV_INDDESP
WHERE ROWNUM <= 1000

SELECT * 
FROM RPT_MOD.VW_INPRDDTA_INCPNLP
WHERE ROWNUM <= 1000

SELECT * 
FROM RPT_MOD.VW_PRDGPL_UTCLDRP
WHERE ROWNUM <= 1000

/* 
After completing data analytic summary review fields of interest in each 
realative table. While testing and developing always use filters and row 
limitations
*/
SELECT *
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIITEM = 2
AND WIWHS5 = 110
AND ROWNUM <=1000

-----------------------------------------------------
--    DISTINCT & COUNT                              -
-----------------------------------------------------

-- 50 rows
SELECT IMITEM
FROM RPT_MOD.VW_INPRDDTA_INITMMP
ORDER BY 1

SELECT DISTINCT vendor
FROM products
ORDER BY 1


SELECT DISTINCT COUNT(vendor)
FROM products
ORDER BY 1

-- 271 records 
SELECT COUNT(DISTINCT vendor)
FROM products

/* debrief answer the question why SELECT distinct brought back duplicates but
Select COUNT(DISTINCT field) removed duplicates */

-- EXERCISE
/* Try a SELECT DISTINCT on category_name and a Count Distinct
In your own words what is happening?*/


-------------------------------------------------------------------------------
--                       STRING FUNCTIONS                                    --
-------------------------------------------------------------------------------
/* As you begin using functions and formulas giving your fields useful names 
will be key AS helps you do this */
SELECT WISYTD, WISLS4, WISLS3, WISLS1, WIMNOR, WIMXOR, WIOHIN, WIOHUN, 
WIRCUN, WIADJN, WIOOUN, WISELL, WISTAT
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000

-- Give the fields user friendly names
SELECT
CONCAT(WIITEM, 
WISYTD AS "FISCAL YTD SALES IN UNITS",
WISLS4 AS "THREE WKS AGO SALES IN UNITS", 
WISLS3 AS "TWO WKS AGO SALES IN UNITS",
WISLS2 AS "LAST WKS SALES IN UNITS", 
WISLS1 AS "CURRENT WKS SALES IN UNITS", 
WIMNOR AS "ITEM MINIMUM ORDER QUANTITY",
WIMXOR AS "ITEM MAXIMUM ORDER QUANTITY", 
WIOHIN AS "OH IN SELL UNITS IN TRANSIT", 
WIOHUN AS "ON HAND/SELL UNITS", 
WIRCUN AS "WKLY RECVG/ UNITS", 
WIADJN AS "ADJ. AMT.", 
WIOOUN AS "ON ORDER IN SELL UNITS", 
WISELL AS "SELL PRICE TO WHOLESALER", 
WISTAT AS "VENDOR STATUS= ACT,INACT,DIS"
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000


-- EXERCISE using INITMMP create user friendly fields for 5 fields



------------------CONCAT(field1, field2, field3, field4)------------------------
--Concatenates two character strings.

-- Put vendor and vendor suffix together
SELECT
(CONCAT(WIVEND, WISUFF)) AS "VENDORSUFF",
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000

-- Add a hyphen use test as you go method
SELECT
(CONCAT(WIVEND, '-')) "VENDOR-SUFF"
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000

-- use indents and returns to make dev easier
SELECT
(CONCAT(
       (CONCAT(WIVEND, '-')),
                             WISUFF))"VENDOR-SUFF"
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000

-- Finished product
SELECT
(CONCAT((CONCAT(WIVEND, '-')),WISUFF))"VENDOR-SUFF"
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000

-- EXCERISE Concatenate the 3 sign fields placing a pipe |  between each field


------------------LOWER(field1) UPPER(field1)-------------------
-- Converts a character string to upper or lowercase. 

SELECT 
WIRDES, 
LOWER(WIRDES),
UPPER(WIRDES)
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000


/* EXERCISE - In the previous exercise you concatenated 3 fields together;
using that formula, convert your results to lowercase.
*/

------------------TO_datatype(field)------------------------------------------
-- converting a date to string for string manipulation

SELECT 
WICHGD_WICHGT_ISO, 
(TO_CHAR(WICHGD_WICHGT_ISO)
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000



------------------SUBSTR(field,start, length)-------------------
-- returns part of the string dictated by the starting point and the lenght 
-- asked to be returned

SELECT 
WICHGD_WICHGT_ISO, 
SUBSTR(TO_CHAR(WICHGD_WICHGT_ISO),0,10)
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000

------------------REPLACE(field, field, field)---------------------------------
-- Reviews field and replaces value in field with another value. 
SELECT 
WIRDES,
REPLACE(WIRDES, 'DVD', 'BLUERAY')
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000

--HACK use replace to pseudo delete
SELECT 
WIRDES,
REPLACE(WIRDES, 'DVD', 'BLUERAY'),
REPLACE(REPLACE(WIRDES, 'DVD', 'BLUERAY'),':','')
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE ROWNUM <= 1000

/* CREATE CALCS
Keep in mind with some calculations you may need to change the data type using
CAST or CONVERT this will be covered later  for now we will create IMU*/

SELECT
WISYTD AS "FISCAL YTD SALES IN UNITS",
WISLS4 AS "THREE WKS AGO SALES IN UNITS", 
WISLS3 AS "TWO WKS AGO SALES IN UNITS",
WISLS2 AS "LAST WKS SALES IN UNITS", 
WISLS1 AS "CURRENT WKS SALES IN UNITS", 
WIMNOR AS "ITEM MINIMUM ORDER QUANTITY",
WIMXOR AS "ITEM MAXIMUM ORDER QUANTITY", 
WIOHIN AS "OH IN SELL UNITS IN TRANSIT", 
WIOHUN AS "ON HAND/SELL UNITS", 
WIRCUN AS "WKLY RECVG/ UNITS", 
WIADJN AS "ADJ. AMT.", 
WIOOUN AS "ON ORDER IN SELL UNITS", 
WISELL AS "SELL PRICE TO WHOLESALER", 
WISTAT AS "VENDOR STATUS= ACT,INACT,DIS",
(WISELL - WINLC) AS "sellprice - cost",
(((WISELL - WINLC)/WISELL)*100) AS "IMU",
(ROUND((((WISELL - WINLC)/WISELL)*100),2 )) AS "IMU percentage", 
CONCAT((ROUND((((WISELL - WINLC)/WISELL)*100),2 )), '%') as "IMU%"
FROM RPT_MOD.VW_INPRDINV_INWITMP

WHERE 
(ROUND((((WISELL - WINLC)/WISELL)*100),2 ))<= 2
AND
ROWNUM <= 1000
ORDER BY 18



-- next use filters for validation
SELECT
WISYTD AS "FISCAL YTD SALES IN UNITS",
WISLS4 AS "THREE WKS AGO SALES IN UNITS", 
WISLS3 AS "TWO WKS AGO SALES IN UNITS",
WISLS2 AS "LAST WKS SALES IN UNITS", 
WISLS1 AS "CURRENT WKS SALES IN UNITS", 
WIMNOR AS "ITEM MINIMUM ORDER QUANTITY",
WIMXOR AS "ITEM MAXIMUM ORDER QUANTITY", 
WIOHIN AS "OH IN SELL UNITS IN TRANSIT", 
WIOHUN AS "ON HAND/SELL UNITS", 
WIRCUN AS "WKLY RECVG/ UNITS", 
WIADJN AS "ADJ. AMT.", 
WIOOUN AS "ON ORDER IN SELL UNITS", 
WISELL AS "SELL PRICE TO WHOLESALER", 
WISTAT AS "VENDOR STATUS= ACT,INACT,DIS",
(WISELL - WINLC) AS "sellprice - cost",
(((WISELL - WINLC)/WISELL)*100) AS "IMU",
(ROUND((((WISELL - WINLC)/WISELL)*100),2 )) AS "IMU percentage", 
CONCAT((ROUND((((WISELL - WINLC)/WISELL)*100),2 )), '%') as "IMU%"
FROM RPT_MOD.VW_INPRDINV_INWITMP

WHERE 
WIWHS5 = 110
AND WIITEM = 2
ORDER BY 18


/* EXERCISE:
What is the percent of difference from last week sales in units and two weeks
ago sales in units?
*/



/* 
REVIEW INITMMP, INWCTLP & INVMSTP
Out of all 4 tables which is the transaction table?
Why would you use INWCTLP?
What are common fields between the reference tables and the transaction table?
*/


--------------------------------------------------------------------------------
--                        EXTRAS                                              --
--------------------------------------------------------------------------------

------------------LENGTH(field)-------------------
-- counts length of characters in a field 
SELECT 
LENGTH('               102.3                   ')
FROM DUAL



------------------LTRIM(field) RTRIM(field)-------------------
-- trims blanks
SELECT 
'               102.3                   ',
LTRIM('               102.3                   '),
RTRIM('               102.3                   ')
FROM DUAL

-- Exercise: is the length the same after Rtrim and Ltrim?