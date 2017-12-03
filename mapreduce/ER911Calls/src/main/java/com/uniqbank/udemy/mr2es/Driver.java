package com.uniqbank.udemy.mr2es;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.elasticsearch.hadoop.mr.EsOutputFormat;

public class Driver{
	public static void main(String [] args) throws Exception{
		Configuration conf = new Configuration();
		conf.set("es.nodes", "localhost:9200");
		conf.set("es.resource", "mapreduce/er911");
		
		Job job = new Job(conf, "MapReduce to ElasticSearch");
		job.setJarByClass(Driver.class);
		job.setMapperClass(Mr2esMapper.class);
		job.setOutputFormatClass(EsOutputFormat.class);
		job.setNumReduceTasks(0);
		job.setMapSpeculativeExecution(false);
		job.setReduceSpeculativeExecution(false);
		FileInputFormat.addInputPath(job, new Path(args[0]));
		
		System.exit(job.waitForCompletion(true)?0:1);
	}
}