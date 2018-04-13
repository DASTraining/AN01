----------------------------------------------------------------
--          FILTERS
----------------------------------------------------------------
SELECT * 
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE
ROWNUM <=1000

--IN
SELECT WIITEM, WIRDES, WINLC, WISELL, WISLS1, WISLS2, WISLS3, WISLS4
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIDEPT IN (61, 62, 63, 64, 65)
AND WIWHS5 = 110
AND ROWNUM <= 1000

-- NOT IN
SELECT WIITEM,WIRDES WINLC, WISELL, WISLS1, WISLS2, WISLS3, WISLS4
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIDEPT IN (61, 62, 63, 64, 65)
AND WIITEM NOT IN ( 32819, 39972, 39966)
AND WIWHS5 = 110
AND ROWNUM <= 1000

--BETWEEN
SELECT WIITEM,WIRDES, WINLC, WISELL, WISLS1, WISLS2, WISLS3, WISLS4
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIDEPT IN (61, 62, 63, 64, 65)
AND WIITEM BETWEEN 30000 AND 40000
AND WIWHS5 = 110
AND ROWNUM <= 1000

-- NOT BETWEEN
SELECT WIITEM, WIRDES, WINLC, WISELL, WISLS1, WISLS2, WISLS3, WISLS4
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIDEPT IN (61, 62, 63, 64, 65)
AND WIITEM NOT BETWEEN 30000 AND 40000
AND WIWHS5 = 110
AND ROWNUM <= 1000

/* EXERCISE: Locate two items on that has had 0 sales in units for a week and
onE that has had 1 sales in units. Put those two items in an IN statement to 
filter on them then run a test using BETWEEN to see if BETWEEN excludes or 
include both or either of them */

 


-- LIKE, LIKE & lower 
SELECT WIITEM, WIRDES, WINLC, WISELL, WISLS1, WISLS2, WISLS3, WISLS4
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIDEPT IN (61, 62, 63, 64, 65)
AND WIITEM NOT BETWEEN 30000 AND 40000
AND WIWHS5 = 110
AND LOWER(WIRDES) LIKE '%salmon%'
AND ROWNUM <= 1000


-- OR
SELECT * 
FROM RPT_MOD.VW_INPRDDTA_INITMMP
WHERE IMCMPY = 1
AND IMSTAT = 'A'
AND IMDEPT = 24
OR IMCAT1 = 'Z'

---------------------------------------------------------------------------------------------------
-- GROUP BY/ HAVING
---------------------------------------------------------------------------------------------------
/* GROUP BY is used whenever you aggregated a measure that also has a dimension in the results.
 you will always be GROUPING BY  the dimensions */
SELECT WIITEM, WIRDES, WINLC, WISELL, SUM(WISLS1), SUM(WISLS2), SUM(WISLS3), SUM(WISLS4)
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIDEPT IN (61, 62, 63, 64, 65)
AND WIITEM NOT BETWEEN 30000 AND 40000
AND WIWHS5 = 110
AND LOWER(WIRDES) LIKE '%salmon%'
AND ROWNUM <= 1000
GROUP BY WIITEM, WIRDES, WINLC, WISELL


/*HAVING is a filter for aggregations so if you wanted to only see where the sum(shelf_price) is over 20$ 
you would not put it in the WHERE but in the HAVING. */
SELECT WIITEM, WIRDES, WINLC, WISELL, SUM(WISLS1), SUM(WISLS2), SUM(WISLS3), SUM(WISLS4)
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIDEPT IN (61, 62, 63, 64, 65)
AND WIITEM NOT BETWEEN 30000 AND 40000
AND WIWHS5 = 110
AND LOWER(WIRDES) LIKE '%salmon%'
AND ROWNUM <= 1000
GROUP BY WIITEM, WIRDES, WINLC, WISELL
HAVING SUM(WISLS1) > 0

-- EXERCISE: creating HAVING filter to include >0 for all sls fields



-- EXERSICE- FIX THE CODE

SELECT LOCATION, (cost –sell price),  SUM(sales), 
FROM sales
WHERE Category = ‘Tequila’
units purchased >2
GROUP BY Store
HAVING SUM(sales) > 30.00
ORDER BY 3




--------------------------------------------------------
-- AGGREGATES
--------------------------------------------------------
-- Examples of aggregates, how could you use filters to make more use of these?

-- COUNT()
SELECT COUNT(WIITEM)
FROM RPT_MOD.VW_INPRDINV_INWITMP


-- COUNT(DISTINCT) 
SELECT COUNT(DISTINCT WIITEM)
FROM RPT_MOD.VW_INPRDINV_INWITMP

-- AVG()
SELECT WIITEM, AVG(WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5
ORDER BY 2 DESC

-- MIN()
SELECT WIITEM, MIN(WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIWHS5 = 110
GROUP BY WIITEM
ORDER BY 2 DESC

-- MAX()
SELECT WIITEM, MAX(WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIWHS5 = 110
GROUP BY WIITEM
ORDER BY 2 DESC

-- SUM()
SELECT WIITEM, SUM(WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIWHS5 = 110
GROUP BY WIITEM
ORDER BY 2 DESC

-- BASIC SUMMARY
SELECT 
WIITEM, 
SUM(WISLS1),
MIN(WISLS1),
MAX(WISLS1), 
AVG(WISLS1), 
MEDIAN(WISLS1), 
STATS_MODE(WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIWHS5 = 110
GROUP BY WIITEM
ORDER BY 2 DESC

/* Example for nesting aggregates: CANNOT BE DONE unless doing a subselect.
Example of why you might do this
Count how many hours you worked in a given week then find the average for the week. */

SELECT WIWHS5, SUM(COUNT(WISLS1))
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5
ORDER BY 2 DESC


---------------------------------------------------------------------------------------------
-- * BONUS* AGGREGATES for Statistics
---------------------------------------------------------------------------------------------
/* Corr calculates the pearsons correlation a correlation of 1 means a perfect positive
a correlation of -1 means a perfect negative and a correlation of 0 means no correlation */





-- corr(Y,X)
SELECT corr(WISLS2, WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5


--population covariance
SELECT covar_pop(WISLS2, WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5

--sample covariance
SELECT covar_samp(WISLS2, WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5

-- regr_avgx average of the independent variable (sum(X)/N)
SELECT regr_avgx(WISLS2, WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5

-- regr_avgy(Y, X)average of the dependent variable (sum(Y)/N)
SELECT regr_avgy(WISLS2, WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5

-- regr_count(Y, X) number of input rows in which both expressions are nonnull
SELECT regr_count(WISLS2, WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5

--regr_intercept(Y,X) y-intercept of the least-squares-fit linear equation determined by 
-- the (X,Y) pairs
SELECT	regr_intercept(WISLS2, WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5
   
-- regr_r2(Y,X) square of the correlation coefficient
SELECT	regr_r2(WISLS2, WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5

-- regr_slope(Y,X) slope of the least squares fit
SELECT	regr_intercept(WISLS2, WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5


--stddev(expression) Standard Deviation sample
SELECT WIITEM, stddev(WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIITEM

--stddev_pop(expression) Standard deviation population
SELECT vendor, stddev_pop(WISLS1)
FROM RPT_MOD.VW_INPRDINV_INWITMP
GROUP BY WIWHS5

