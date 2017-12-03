REGISTER /usr/local/lib/elasticsearch-hadoop-2.3.0.jar;

-- load 2012 games data from elasticsearch into PIG relation called ES
-- ES = LOAD 'games/year-2012' using org.elasticsearch.hadoop.pig.EsStorage('es.query={ "query": { "match" : { "publisher" : { "query" : "Capcom" } } } }');

ES = LOAD 'games/year-2012' using org.elasticsearch.hadoop.pig.EsStorage('es.query={ "query": { "bool" : { "should" : [{ "term": { "publisher" : "Activision" } }], "should" : [{ "term" : { "publisher" : "Capcom" } }] } } }');

-- sample and validate data
-- x = limit ES 5;
-- dump x;

-- store json data into a HDFS file

store ES into '/dev/final/udemy/es2pig/out' using PigStorage();
