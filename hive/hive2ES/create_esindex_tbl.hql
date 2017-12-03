
-- use udemy database
use udemy;

-- drop Elastic Search index table in hive
drop table if exists vg_sales_es;

-- create table in hive which will load an index in Elastic Search
create external table vg_sales_es(
	rank            bigint  	comment 'Ranking of overall sales',
    name            string  	comment 'name of the game',
    platform        string  	comment 'pc, ps4 etc',
    year            string  	comment 'year of games release',
    genre           string  	comment 'genre of the game',
    publisher       string  	comment 'publisher of the game',
    na_sales        double  	comment 'sales in north america (in millions)',
    eu_sales        double  	comment 'sales in Europe (in millions)',
    jp_sales        double  	comment 'sales in Japan (in millions)',
    other_sales     double 		comment 'sales in rest of the world (in millions)',
    global_sales    double  	comment 'total worldwide sales'
)
stored by 'org.elasticsearch.hadoop.hive.EsStorageHandler'
location '/dev/final/udemy/vg_sales_es'
TBLPROPERTIES('es.resource'='vg/sales', 
			  'es.node' = 'http://localhost',
			  'es.port' = '9200');
