package com.uniqbank.udemy.mr2es;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.MapWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class Mr2esMapper extends Mapper<LongWritable, Text, Text, MapWritable>{
	public static final Log log = LogFactory.getLog(Mr2esMapper.class);
	public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException{
		// convert Text object to String and trim any extra spaces at beginning or end of line.
		String line = value.toString().trim();
		
		if(key.get() == 0 && line.contains("lat")){
			return; // skip this line as it's the header of the file
		}
		// tokenize the line into fields, based on separator (comma in this case).
		// remember if any of fields in data file contains comma (or any separator) inside value then,
		// we should use CSV parsers which handles quotes, double quotes, etc within data items. 
		String[] fields = line.split(",");
		
		// declare an object for passing map of values to ElasticSearch via context methad later.
		MapWritable map = new MapWritable();
		
		//log.debug("processing a record: "+ fields.toString());
		
		map.put(new Text("location"), (fields[0] == null || fields[1] == null)? 
													NullWritable.get(): new Text(fields[0]+ "," + fields[1]));
		map.put(new Text("details"), (fields[2] != null? new Text(fields[2]): NullWritable.get()));
		map.put(new Text("zip"), (fields[3] != null? new Text(fields[3]): NullWritable.get()));
		map.put(new Text("emergency"), (fields[4] != null? new Text(fields[4]): NullWritable.get()));
		
		//parse datetime field to appropriate format for ElasticSearch
		SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss a");
		Long ts = null;
		try {
			ts = df.parse(fields[5]).getTime();
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		//map.put(new Text("@timestamp"), ts != null? new LongWritable(ts): new LongWritable(new Date().getTime()));
		map.put(new Text("@timestamp"), ts != null? new Text(fields[5]): new Text(df.format(new Date().getTime())));

		map.put(new Text("township"), (fields[6] != null? new Text(fields[6]): NullWritable.get()));
		
		context.write(value, map);
	}
	
}