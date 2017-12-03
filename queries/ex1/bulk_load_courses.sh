# create an index
curl -XPUT 'http://localhost:9200/university'


# set mapping for desired fields
curl -XPUT http://localhost:9200/university/course/_mapping?pretty -d '{
	"properties":{
		"start_dt":{
			"type" : "date",
			"format" : "MM/dd/yy",
			"index" : "not_analyzed"
		},
		"cid":{
			"type" : "long"
		},
		"duration":{
			"type" : "double"
		},
		"fee":{
			"type" : "double"
		}
	}
}'

# load json data into ElasticSearch index/type
curl -XPOST 'http://localhost:9200/_bulk?pretty&refresh' --data-binary "@courses.json"
