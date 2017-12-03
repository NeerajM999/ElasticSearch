-- create a database to hold all our tables

create database if not exists udemy;

-- use udemy database for vg_sales table

use udemy;

-- create external table called vg_sales in udemy database

drop table if exists vg_sales;

create external table vg_sales(
	rank 			int			comment 'Ranking of overall sales',
	name			string			comment	'name of the game',
	platform		string			comment	'pc, ps4 etc',
	year			string			comment 'year of games release',
	genre			string			comment 'genre of the game',
	publisher		string			comment	'publisher of the game',
	na_sales		double	comment 'sales in north america (in millions)',
	eu_sales		double	comment 'sales in Europe (in millions)',
	jp_sales		double	comment 'sales in Japan (in millions)',
	other_sales		double	comment 'sales in rest of the world (in millions)',
	global_sales	double	comment 'total worldwide sales'
)
row format serde
	'org.apache.hadoop.hive.serde2.OpenCSVSerde'
stored as
	TEXTFILE
location
	'/dev/final/udemy/vg_sales'
TBLPROPERTIES("skip.header.line.count"="1");
