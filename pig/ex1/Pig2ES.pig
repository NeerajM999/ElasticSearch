REGISTER /usr/local/lib/elasticsearch-hadoop-2.3.0.jar;

DEFINE EsStorage org.elasticsearch.hadoop.pig.EsStorage(
	'es.http.timeout=5m', 
	'es.index.auto.create=true', 
	'es.mapping.pig.tuple.use.field.names = true'
	);

SET default_parallel 5;
SET pig.splitCombination FALSE;

-- load all records into relation 'all_games' from hive table
all_games = load 'udemy.vg_sales' using org.apache.hive.hcatalog.pig.HCatLoader() as (rank:chararray, name:chararray, platform:chararray, year:int, genre:chararray, publisher:chararray, na_sales:double, eu_sales:double, jp_sales:double, other_sales:double, global_sales:double);

-- filter games launched in year = 2012
games_2012 = filter all_games by year == 2012; 

-- use for validating results before storing into ES
-- games_2012_5 = limit games_2012 5; -- takes a small test sample
-- dump games_2012; -- review results before storing into ES


-- order records based on global_sales
ordered_games = order games_2012 by global_sales desc parallel 5;

-- og = limit ordered_games 10;
-- dump og;

-- prepare records to be loaded into ElasticSearch
-- we will consolidate all sales data into a structure like sales { na_sales:na_sales, eu_sales:eu_sales, ... } 
target = foreach ordered_games generate rank, name, platform, year, genre, publisher, TOTUPLE(na_sales, eu_sales, jp_sales, other_sales, global_sales) as sales;

-- t = limit target 5;
-- dump t;

store target into 'games/year-{target.year}' using EsStorage;
