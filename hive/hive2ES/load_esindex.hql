-- load Elastic Search index/type through hive table

use udemy;
insert overwrite table vg_sales_es
select 
cast(v.rank as bigint),                	              	   
v.name,                	              	   
v.platform,            	              	   
v.year,                	              	   
v.genre,               	              	   
v.publisher,           	              	   
cast(v.na_sales as double),            	              	   
cast(v.eu_sales as double),            	              	   
cast(v.jp_sales as double),            	              	   
cast(v.other_sales as double),         	              	   
cast(v.global_sales as double)
from vg_sales v;
