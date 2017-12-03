package com.uniqbank.udemy.es2mr;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.elasticsearch.hadoop.mr.EsInputFormat;

public class Driver{
	public static void main(String [] args) throws Exception{
		//hdfs location
		String query = "/dev/final/udemy/es2mr/query.json";
		
		Configuration conf = new Configuration();
		conf.set("es.nodes", "localhost:9200");
		conf.set("es.resource", "mapreduce/er911");
		conf.set("es.query", query);
		
		Job job = new Job(conf, "ElasticSearch to MapReduce");
		job.setJarByClass(Driver.class);
		job.setMapperClass(ES2MRMapper.class);
		job.setInputFormatClass(EsInputFormat.class);
		job.setNumReduceTasks(0);
		job.setMapSpeculativeExecution(false);
		job.setReduceSpeculativeExecution(false);
		FileOutputFormat.setOutputPath(job, new Path(args[0]));
		
		System.exit(job.waitForCompletion(true)?0:1);
	}
}