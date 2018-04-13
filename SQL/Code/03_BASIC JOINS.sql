/* Before creating your joins draw a model of your database 
and how your data will connect. 
All tables will often be able to link directly into a Primary transaction table
or Fact Table. There may be instances where you will need to create a  unique 
identifier using multiple fields. It is crucial to understand what is in your unique 
fields
EXAMPLE table one may have Company and Table 2 may have a Company field
but Table 1 may only contain Company 1 information. If you join the two tables together
on company number you would filter out Company 4 data

In some cases you may need to join one table to another table and then to a primary table
in effect daisy chaining tables together. You would do this because you need info from 2 tables that have
no way to connect and a third table assists in this. */


-- STEP 1 REVIEW AND UNDERSTAND YOUR KEYS BETWEEN TABLES YOU WANT TO JOIN
-- JOINING INWITMP TO INWCTLP

----------------------INWITMP--------------------------------------------------
-- 2 records
SELECT COUNT(DISTINCT WICMPY)
FROM RPT_MOD.VW_INPRDINV_INWITMP

-- 988 records
SELECT COUNT(DISTINCT WIWHS5)
FROM RPT_MOD.VW_INPRDINV_INWITMP


-- Several ways to count distinct over 2 columns here is a quick trick
-- 989 records
SELECT COUNT(DISTINCT CONCAT(WICMPY, WIWHS5))
FROM RPT_MOD.VW_INPRDINV_INWITMP

-- Why is there an extra record? 
-- Try using excel and vlookup to solve what is happening
SELECT DISTINCT WICMPY, WIWHS5
FROM RPT_MOD.VW_INPRDINV_INWITMP
ORDER BY 1,2


SELECT * 
FROM RPT_MOD.VW_INPRDINV_INWITMP
WHERE WIWHS5 = 360
and wicmpy = 4

-----------------------------INWCTLP-------------------------------------------
--2 records
SELECT COUNT(DISTINCT WCCMPY)
FROM RPT_MOD.VW_INPRDINV_INWCTLP

-- 974
SELECT COUNT(DISTINCT WCWHS5)
FROM RPT_MOD.VW_INPRDINV_INWCTLP


-- 974 records
SELECT COUNT(DISTINCT CONCAT(WCCMPY, WCWHS5))
FROM RPT_MOD.VW_INPRDINV_INWCTLP

/* Why does 1 table have 989 unique records and the other 974?
First lets look at basic join syntax then we will attemp to answer 
that question. */

-- ON VS WHERE --
-- for basic joins you could use ON or WHERE
SELECT a.WICMPY, a.WIWHS5, b.WCCMPY, b.WCWHS5

FROM RPT_MOD.VW_INPRDINV_INWITMP a

JOIN RPT_MOD.VW_INPRDINV_INWCTLP b
ON a.WICMPY = b.WCCMPY
AND a.WIWHS5= b.WCWHS5

WHERE b.WCWHS5 = 110
AND  a.WIITEM = 2

SELECT a.WICMPY, a.WIWHS5, b.WCCMPY, b.WCWHS5
FROM RPT_MOD.VW_INPRDINV_INWITMP a, 
RPT_MOD.VW_INPRDINV_INWCTLP b

WHERE a.WICMPY = b.WCCMPY
AND a.WIWHS5= b.WCWHS5
AND b.WCWHS5 = 110
AND a.WIITEM = 2

/* 
Which is faster?
Which is easier to read?
Which is more consistant?
*/

/* EXERCISE - Use what you have learned so far to create seperate queries and:
1) JOIN INWITMP to INITMMP 
2) JOIN INWITMP to INDDESP
Remember to use filters when testing your queries and Row LIMITS
*/

-------------------JOINING MULTIPLE TABLES-------------------------------------
SELECT a.WICMPY, a.WIWHS5, b.WCCMPY, b.WCWHS5, c.DDDESL
FROM RPT_MOD.VW_INPRDINV_INWITMP a

JOIN RPT_MOD.VW_INPRDINV_INWCTLP b
ON a.WICMPY = b.WCCMPY
AND a.WIWHS5= b.WCWHS5

JOIN RPT_MOD.VW_INPRDINV_INDDESP c
ON a.WIDEPT = c.DDDEPT

WHERE b.WCWHS5 = 110
AND  a.WIITEM = 2

--EXERCISE 
-- JOIN INITMMP to the above Query
/* EXTRA convert your ON clause into WHERE clause joins being fluent in both 
is a good idea */


--------------------INVMSTP----------------------------------------------------
-- knowing your fields, knowing your business and knowing your joins

-- 1) EXERCISE create an analysis of counts for INVMSTP
-- 2) Review sample data of INVMSTP in excel use filters to understand data
-- 3) Think about the information in the table outside of just the table

/* Helpful info from Troy Thomas in Accounting
Vendor is the BBA aka Buying vendor (Buyer setup based on configuration)
AP is the Accounts Payable Vendor (This is the actual vendor being paid)

For example:  Buying may have several different configurations for an item, 
depending on the region or set of locations, usually denoted by a suffix, 
but no matter what the configuration, we would pay the same AP vendor. */ 



-- create small sample set
SELECT VMCMPY, VMWHS5, VMDEPT, VMBUY5, VMVEND, VMSUFF, VMBUYR, VMAPNO, VMASUF, VMSHVS 
FROM RPT_MOD.VW_INPRDINV_INVMSTP
WHERE 
VMCMPY = 1 
AND VMWHS5 = 110 
AND VMDEPT = 24
AND VMAPNO = 83582
AND ROWNUM <= 1000

-- test joins
SELECT 
b.VMCMPY, b.VMWHS5, b.VMDEPT,
a.WIITEM, b.VMBUY5, b.VMVEND, 
b.VMSUFF, b.VMBUYR, b.VMAPNO, 
b.VMASUF, b.VMSHVS

FROM RPT_MOD.VW_INPRDINV_INWITMP a

JOIN RPT_MOD.VW_INPRDINV_INVMSTP b
ON a.WICMPY = b.VMCMPY
AND a.WIWHS5 = b.VMWHS5
AND a.WIDEPT = b.VMDEPT
AND a.WIVEND = b.VMVEND
AND a.WISUFF = b.VMSUFF

WHERE 
b.VMCMPY = 1 
AND b.VMWHS5 = 110 
AND b.VMDEPT = 24
AND b.VMAPNO = 83582
AND ROWNUM <= 1000

-- REVIEW BASIC SQL--
/* Using the above query:
1) Remove filters on Department, APNO
2) Add the field WISLS1 and SUM it
3) Filter to only see results where the SUM of WISLS1 is  greater than 0
4) Add department descriptions

*/


-- SOLUTION
SELECT 
b.VMCMPY, b.VMWHS5, b.VMDEPT,
a.WIITEM, c.IMDES1, b.VMBUY5, b.VMVEND, 
b.VMSUFF, b.VMBUYR, b.VMAPNO, 
b.VMASUF, b.VMSHVS, SUM(WISLS1)

FROM RPT_MOD.VW_INPRDINV_INWITMP a
JOIN RPT_MOD.VW_INPRDDTA_INITMMP c
ON a.WIITEM = c.IMITEM
JOIN RPT_MOD.VW_INPRDINV_INVMSTP b
ON a.WICMPY = b.VMCMPY
AND a.WIWHS5 = b.VMWHS5
AND a.WIDEPT = b.VMDEPT
AND a.WIVEND = b.VMVEND
AND a.WISUFF = b.VMSUFF

WHERE 
c.IMCMPY = 1 
AND b.VMWHS5 = 110 
AND ROWNUM <= 1000

GROUP BY b.VMCMPY, b.VMWHS5, b.VMDEPT,
a.WIITEM, c.IMDES1, b.VMBUY5, b.VMVEND, 
b.VMSUFF, b.VMBUYR, b.VMAPNO, 
b.VMASUF, b.VMSHVS

HAVING sum(WISLS1)>0

