/* COMMON TABLE EXPRESSIONS(CTE) and Inline Views otherwise known as SUBSELECTS
 
A CTE is a temporary result set that is created from an SQL statement. The temp result is not stored
but can be used to run another query off of within the same statement.
You have done this before with a calculator. If you add 1+1 you will see the result of 2
The number 2 is temporarily stored in the result view of the calculator but you can run more
calculations over that temp number like * 4  you will get 8 then you can +4 to get 12. However, once you
turn the calculator off and on those numbers are gone, not stored. Same with CTE's and inline views.
Few of the main reasons why you might use a CTE
1. Running an aggregate over an aggregate. You may recall the shout out to not being able to run an AVG(COUNT(field))
with a CTE you could run a query that does the count then run another query over that result set which now views that count as 
a value not a function. and run the average over the value. 
example
COUNT(stores) as NoLongerCount_Just_a_Value
AVG(NoLongerCount_Just_a_Value)
2. Another reason for using the Subselect is to create a filter on your data and then run your query. Example would be you 
have 2 massive files, you could filter each one down to smaller tables before joining them. This would provide optimization
*/

-- AGGREGATE and AGGREGATE EXAMPLE
-- Lets say you need to get the average number of items in a given category or department
-- First you would need to run a count.
SELECT  IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3, 
COUNT(DISTINCT IMITEM) 
FROM RPT_MOD.VW_INPRDDTA_INITMMP
GROUP BY IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3
ORDER BY 1, 2 DESC,3,4,5

-- what happens if you try to do an Average number of items in a department
SELECT  IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3, 
AVG(COUNT(DISTINCT IMITEM)) 
FROM RPT_MOD.VW_INPRDDTA_INITMMP
GROUP BY IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3
ORDER BY 1, 2 DESC,3,4,5

/* wouldn't it be nice if you could run the first query to a table and then 
build your average over that table? */

WITH Item_counts AS (
                      SELECT  IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3, 
                      COUNT(DISTINCT IMITEM) AS item_count
                      FROM RPT_MOD.VW_INPRDDTA_INITMMP
                      GROUP BY IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3
                      ORDER BY 1, 2 DESC,3,4,5
                       )  
SELECT IMDEPT, AVG(item_count)
FROM Item_counts
GROUP BY IMDEPT; 

/* Here is the exact same example just built a different way using what is known
as an inline view.  There is not much difference in performance choosing 
1 vs the other comes down to style(readability)and if you will use the view or 
temp table more than once. Prime example of using a temp table or view 
more than once is a UNION. In this case an inline view will be pretty messy. 
Where as with a the CTE you only have to code it once. */

-- Inline view
SELECT IMDEPT, SUM(Item_count)
FROM 
     (SELECT  IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3, 
      COUNT(DISTINCT IMITEM) AS item_count
      FROM RPT_MOD.VW_INPRDDTA_INITMMP
      GROUP BY IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3
      ORDER BY 1, 2 DESC,3,4,5
     ) item_counts
GROUP BY IMDEPT





/* USING CTE AND INLINE VIEWS TO Join 2 subselects together 
lets say in this example you want to speed your query up by filtering on a 
smaller data set*/

WITH 
a AS (SELECT WICMPY, WIWHS5, WIDEPT,SUM(WISLS1)  
      FROM RPT_MOD.VW_INPRDINV_INWITMP
      WHERE WICMPY = 1
      AND WIDEPT = 24
      AND ROWNUM <=100
      GROUP BY WICMPY, WIWHS5, WIDEPT),

b AS (SELECT IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3, 
      COUNT(DISTINCT IMITEM) AS item_count
      FROM RPT_MOD.VW_INPRDDTA_INITMMP
      WHERE IMCMPY = 1
      AND IMDEPT = 24
      GROUP BY IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3
      ORDER BY 1, 2 DESC,3,4,5)


SELECT *
FROM a
JOIN b
ON a.WICMPY = b.IMCMPY 
AND a.WIDEPT = b.IMDEPT

-- same example but with an inline view

SELECT *
FROM

      (SELECT WICMPY, WIWHS5, WIDEPT,SUM(WISLS1)  
      FROM RPT_MOD.VW_INPRDINV_INWITMP
      WHERE WICMPY = 1
      AND WIDEPT = 24
      AND ROWNUM <=100
      GROUP BY WICMPY, WIWHS5, WIDEPT) a

JOIN

(SELECT IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3, 
      COUNT(DISTINCT IMITEM) AS item_count
      FROM RPT_MOD.VW_INPRDDTA_INITMMP
      WHERE IMCMPY = 1
      AND IMDEPT = 24
      GROUP BY IMCMPY, IMDEPT, IMCAT1, IMCAT2, IMCAT3
      ORDER BY 1, 2 DESC,3,4,5)  b

ON a.WICMPY = b.IMCMPY 
AND a.WIDEPT = b.IMDEPT

SELECT * from rpt_mod.VW_INPRDINV_INWITMP
WHERE rownum <=100

SELECT * from rpt_mod.VW_INPRDINV_INWCTLP
WHERE rownum <=100


-- Here is an example of creating 2 temp tables, joining them, 
-- There is some logic that doesnt work can you find it and fix it
WITH
a AS (SELECT DISTINCT WICMPY,WIWHS5, count(DISTINCT WIWHS5) AS HS_WIWHS5
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE 
WICMPY= 1
AND WIDEPT= 16 
GROUP BY WICMPY, WIWHS5
HAVING SUM(WISLS1)>4000
ORDER BY 3 DESC),

b AS (SELECT WCREGN, WCCMPY, WCCITY, WCSTA, WCZIP, WCWHS5, count(DISTINCT WCWHS5) AS Total_WCSTA
FROM RPT_MOD.VW_INPRDINV_INWCTLP
GROUP BY WCREGN, WCCMPY, WCCITY, WCSTA,WCWHS5, WCZIP)


SELECT 
SUM(a.HS_WIWHS5), SUM(b.Total_WCSTA), Concat(((SUM(a.HS_WIWHS5)/SUM(b.Total_WCSTA))* 100),'%')
FROM A a
RIGHT JOIN B b
ON a.WICMPY=b.WCCMPY
AND a.WIWHS5=b.WCWHS5

-- We will cover Numeric functions but why wait, try googling 
-- ORACLE SYNTAX ROUND or FLOAT or DEC to see how and get this down to a better size
