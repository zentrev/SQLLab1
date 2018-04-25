Use Master

Drop database AP

Create database AP
Go

USE [AP]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[series](
	[series_id] [varchar](17) NULL,
	[area_code] [varchar](4) NULL,
	[item_code] [varchar](9) NULL,
	[series_title] varchar(200) NULL,
	[footnote_codes] [varchar](10) NULL,
	[begin_year] [smallint] NULL,
	[begin_period] [varchar](3) NULL,
	[end_year] [smallint] NULL,
	[end_period] [varchar](3) NULL
) 

CREATE TABLE [dbo].[period](
	[period] [varchar](3) NULL,
	[period_abbr] [varchar](5) NULL,
	[period_name] [varchar](14) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[item](
	[item_code] [varchar](9) NULL,
	[item_name] [varchar](89) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[HouseholdFuels](
	[series_id] [varchar](17) NULL,
	[year] [smallint] NULL,
	[period] [varchar](3) NULL,
	[value] [varchar](50) NULL,
	[footnote_codes] [varchar](10) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[Gasoline](
	[series_id] [varchar](17) NULL,
	[year] [smallint] NULL,
	[period] [varchar](3) NULL,
	[value] [varchar](50) NULL,
	[footnote_codes] [varchar](10) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[footnote](
	[footnote_code] [varchar](10) NULL,
	[footnote_text] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[Food](
	[series_id] [varchar](50) NULL,
	[year] [varchar](50) NULL,
	[period] [varchar](50) NULL,
	[value] [varchar](50) NULL,
	[footnote_codes] [varchar](50) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[Current](
	[series_id] [varchar](17) NULL,
	[year] [smallint] NULL,
	[period] [varchar](3) NULL,
	[value] [varchar](50) NULL,
	[footnote_codes] [varchar](10) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[area](
	[area_code] [varchar](4) NULL,
	[area_name] [varchar](300) NULL
) ON [PRIMARY]
Go




--follow this pattern to insert the data from the remaining files
--from http://download.bls.gov/pub/time.series/ap/.  Import all tables
--except ap.contacts and ap.txt.


--bulk insert period from 'c:\ap\ap.period' with (firstrow = 2)

Use AP


bulk insert area from 'c:\temp\ap\ap.area' with (firstrow = 2)
bulk insert [Current] from 'c:\temp\ap\ap.Current' with (firstrow = 2)
bulk insert HouseholdFuels from 'c:\temp\ap\ap.HouseholdFules' with (firstrow = 2)
bulk insert Gasoline from 'c:\temp\ap\ap.Gasoline' with (firstrow = 2)
bulk insert Food from 'c:\temp\ap\ap.Food' with (firstrow = 2)
bulk insert footnote from 'c:\temp\ap\ap.footnote' with (firstrow = 2)
bulk insert item from 'c:\temp\ap\ap.item' with (firstrow = 2)
bulk insert [period] from 'c:\temp\ap\ap.period' with (firstrow = 2)
bulk insert series from 'c:\temp\ap\ap.series' with (firstrow = 2)

ALTER TABLE area ALTER COLUMN area_code varchar(4) not NULL

ALTER TABLE area 
ADD Primary key (area_code)

ALTER TABLE footnote ALTER COLUMN footnote_code varchar(10) not NULL

ALTER TABLE footnote 
ADD Primary key (footnote_code)

ALTER TABLE item ALTER COLUMN item_code varchar(9) not NULL

ALTER TABLE item 
ADD Primary key (item_code)

ALTER TABLE series ALTER COLUMN series_id varchar(17) not NULL

ALTER TABLE series 
ADD Primary key (series_id)

ALTER TABLE period ALTER COLUMN period varchar(3) not NULL

ALTER TABLE period 
ADD Primary key (period)



select *
From area

Select distinct area_code
From area
