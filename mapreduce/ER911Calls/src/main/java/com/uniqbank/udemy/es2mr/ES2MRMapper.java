package com.uniqbank.udemy.es2mr;

import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.io.MapWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class ES2MRMapper extends Mapper<Text, MapWritable, Text, Text>{
	public static final Log log = LogFactory.getLog(ES2MRMapper.class);
	public void map(Text key, MapWritable value, Context context) throws IOException, InterruptedException{
		String separator = "|";
		StringBuilder sb = new StringBuilder();
		
		sb.append(value.get(new Text("zip")) + separator);
		sb.append(value.get(new Text("township")) + separator);
		sb.append(value.get(new Text("emergency")) + separator);
		sb.append(value.get(new Text("details")));
		
		Text record = new Text(sb.toString());
		context.write(record, record);
	}
}