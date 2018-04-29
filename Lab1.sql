/******************** Lab 1 ******************************************

Work in your Lab 1 groups.  One group submission for the group portion, individual submissions for the 
individual portion.

Your team scripts should be identical except for 7.X and 8.X.

Unless specified otherwise, use as many separate queries as you need in your responses.

All questions require SQL responses except those marked "ENGLISH".

The data for this lab is available from the US Bureau of Labor Statistics, and is freely available
here: http://download.bls.gov/pub/time.series/ap/.  Contained in that directory is a documentation 
file named ap.txt which describes the nature of the data.

***********************************************************************/


---------------------- SETUP -----------------------------

/* 0.0
(No SQL to show here, just install the DB and load the data)
Download and review all the files from http://download.bls.gov/pub/time.series/ap/
The APSetup.sql script creates the AP database and adds the necessary tables.  Edit 
the end of the script to insert all the AP data files except ap.txt and ap.contacts,
and ensure each table has a primary key.
*/


------------------------------------------------------------------------
----------------Group Portion-------------------------------------------
------------------------------------------------------------------------

---------------------- QUESTIONS -----------------------------
/* 1.1 
ENGLISH: 
What does AP stand for? Hint: Read the documentation in ap.txt, and "average price" or "the series" is not specific
enough.  What will you tell a non-technical person this database contains?
*/
-- Average Price
-- This is a database for the Average Prices of household items and appliences calculated over a months time
-- Such items include Motor fuels, Electricity, food items, etc.

/* 2.1
Look at the Series table.  Area_code references rows in Area, item_code references
rows in items, and likewise with the two period columns.  

Write single query that returns all the rows and columns from 
Series plus the matching rows, if any, for the above columns from their source tables.

Include all the rows from series, regardless of a matching row in any other table.

*/
Use AP

Select s.item_code, *
From series s, area a, item i
Where s.area_code = a.area_code
And s.item_code = i.item_code

Select *
From series

Select * from item


/* 2.2
Your query above will probably be useful in the future.  Create a view
called SeriesDescription based on that query.  Be explicit with your 
column names (do not use *), and do not duplicate columns in the view.

For help in creating and using views, see the Ben-Gan book, pg 169-171.

A view stores a _query_, not the query result, and lets you write

Select *
From <whatever your view is called> 
Where...

to simplify and shorten future queries.
*/
Create View SeriesDescription As 
Select s.series_id as 'SeriesID', s.area_code as 'SeriesAreaCode', s.item_code 'SeriesItemCode', a.area_code as 'AreaCode', i.item_code 'ItemCode'
From series s, area a, item i
Where s.area_code = a.area_code
And s.item_code = i.item_code


/* 3.1
Use your new view to return the descriptions for series APU0000702212.
*/
Select *
From SeriesDescription
Where SeriesDescription.SeriesID = 'APU0000702212'

/* 3.2
Join your SeriesDescription view to Food and filter to seriesid APU0000702212,
Order the results chronologically.
*/
Select *
From SeriesDescription s
	Join Food f
	On s.SeriesID = f.series_id
	where s.SeriesID = 'APU0000702212'


/*
3.3 ENGLISH
What does the value column represent in the result of 3.2 for series_id APU0000702212?
Be specific in your response ("price" is not good enough).
*/



/* 3.4
Using the food table, return the prices for series APU0000702212 for each April, sorted
in reverse chronological order.
*/

Select *
From food
Where Series_ID = 'APU0000702212'
and SUBSTRING(period,2,2) = 04
order by year DESC




/* 4.1
Did you notice Food, Gasoline, and HouseholdFuels all have the same structure?
Having these records split between different tables is like putting appointments
for different days of the week in separate tables. Let's fix it.

Create an AllProducts table to meet the following requirements.  The new table must:
	a. Not lose any information found in the old tables
	b. Improve any mis-typed data (think: should month and year really be split into two columns?)
	c. Include the source table for each record, so that returning to the 
		old format will be possible with a where clause like this:
			Select *
			From AllProducts
			Where SourceTable = 'Gasoline'

			Hint: Remember that you can hard code a string in the select, like Select 'test', * From ATable

	d. Ensure the AllProducts table has a suitable primary key and foreign keys to any
		related code tables (but not to the Food, Gasoline, and Household fuel tables)
*/

drop table AllProducts

Create Table AllProducts (
	series_id varchar(17),
	Date datetime,
	value varchar(50),
	foornote_codes varchar(50),
	SourceTable varchar(50)
	)
	go


select *
From AllProducts
Where SourceTable = 'Gasoline'

ALTER TABLE Allproducts
ADD FOREIGN KEY (series_id) REFERENCES series(series_id);

ALTER TABLE Allproducts
ADD PRIMARY KEY (Product_id);


/* 4.2
Populate the AllProducts table with all the data from 
the gasoline, food, and householdfuels tables.  Use appropriate techniques to 
convert the data in those source tables to the format required by the 
AllProducts table.  

Use a _single_ query for your insert.

See the Union operator, Ben-Gan page 192.  In a union, multiple selects act as one larger query.

*/

Insert into Allproducts
Select series_id,cast(year +'-' + substring(period,2,2) + '-15' as datetime) as Date,
	value, footnote_codes, SourceTable = 'Food'
From  food
Union
Select series_id,cast(year +'-' + substring(period,2,2) + '-15' as datetime) as Date,
	value, footnote_codes, SourceTable = 'Gasoline'
From Gasoline
Union 
Select series_id,cast(year +'-' + substring(period,2,2) + '-15' as datetime) as Date,
	value, footnote_codes, SourceTable = 'HouseholdFules'
From HouseholdFuels


ALTER TABLE Allproducts ADD Product_id int identity(1,1) not null
GO
ALTER TABLE Allproducts
add CONSTRAINT Product_id primary key(Product_id)
GO

/* 4.3
Remove the Food, Gasoline, and HouseholdFuels tables from the database.
(Remove the tables, not just their rows)
*/

drop table food
drop table gasoline
drop table HouseholdFuels



/* 4.4

(No answer required. UI tools are fine here)

Ensure that all tables in AP have primary keys, and that foreign keys exist to constrain
and show relationships.  You can ignore the footnotes table as it has 0 rows.

You'll submit a database diagram image with your lab submission.
*/


/* 4.5 ENGLISH
So... that was a lot of work.  Why bother?  Why create one new table and remove the three old ones?  Explain
when starting from scratch on a new project how you will decide what data belongs in the same 
table and what should be stored in different tables.
*/




/* 5.1
Return the records in period that are not used in the AllProducts table.


(Aren't you glad we have an all products table?  Think of how much more of a pain
this query would have been if the data was still split across 3 tables)

*/

select distinct *
from period p left join AllProducts a
on substring(p.period,2,2) = month(a.date)
where a.date is null


/* 5.2
Return the records in AllProducts that have a period that doesn't exist
in the period table
*/

select *
From Allproducts a left join period p
on month(a.date) = substring(p.period,2,2)
where p.period is null

/* 5.3 ENGLISH
Explain how a foreign key acts on the Primary and Foreign Key tables.  Which table
can have values not found in the other table?  Which table(s) is/are modified to receive
the constraint?
*/




/* 6.1
Return the top 100 products that had the largest month-to-month change in price as 
a percent (p2 - p1)/p1.
*/
use AP

select *
from AllProducts

select TOP 100 *, ((CAST(p2.value as float) - CAST(p1.value as float)) / CAST(p1.value as float)) * 100 as 'percent'
from AllProducts p1 join AllProducts p2
on p1.Date = p2.Date + 1
where p1.series_id = p2.series_id

/* 6.2 ENGLISH
How did you handle division by 0?  Are the zeros good data, or bad?  Justify your decision.
*/


/* 6.3 ENGLISH
What food items tend to have the largest price changes?  (SQL is OK here, but I want you to explain
the result in English).
*/


/* 6.4 ENGLISH
Records from HouseholdFuels show up a lot in the top 15 records with the largest price changes.
Look at the item name for each.  Is there any other explanation other than there were a lot 
of months with large price changes that make HouseholdFuels appear so many times in the top 15?
Justify your response.
*/



------------------------------------------------------------------------
----------------Individual Portion-------------------------------------------
------------------------------------------------------------------------


/* Submit the following questions individually in the Lab 1 - Individual portion.  Do not 
work in your groups on these questions.  All answers here must be your own work.  */

/* 7.1
SQL & ENGLISH: 

Find something else interesting in this database by describing your intent in English and 
extracting the data with queries. 

Dig a little bit... a single query with a simple where clause is not what I'm looking for.
Get curious, use as many queries as you'd like, and explain what you looked for and what you found
in English.

Completely optional: Can you find anything outside the database (like 6.5) that correlates
to what you found in the data?
*/




/* 8.1
ENGLISH: 

What features of this database were easy to use?  Hard to use?
*/
