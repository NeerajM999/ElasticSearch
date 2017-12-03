-- use udemy database
use udemy;

-- drop Elastic Search index table in hive
drop table if exists candidate_es;

-- create table in hive which will load an index from Elastic Search
create external table candidate_es(
    name            string      comment 'name of the candidate',
    age		        bigint      comment 'candidate age',
    eyecolor        string      comment 'candidate eyecolor',
    gender          string      comment 'candidate gender',
   	company     	string      comment 'company of the candidate',
    email        	string      comment 'candidate email',
    phone        	string      comment 'candidate phone',
    latitude        double      comment 'candidate location lat',
    longitude     	double      comment 'candidate location lon'
)
stored by 'org.elasticsearch.hadoop.hive.EsStorageHandler'
location '/dev/final/udemy/candidate_es'
TBLPROPERTIES('es.resource'='research/candidate',
              'es.node' = 'http://localhost',
              'es.port' = '9200',
			  'es.mapping.names' = 'eyecolor:eyeColor');

