#!/usr/bin/awk -f

BEGIN{
	skip = 1;
	table_name="";
	task="";
	filename = "clean_database.sql.gz";

	if (output_file != ""){
		filename = output_file;
	}
}

match($0, /-- (Dumping data|Table structure) for table `(.+)`/, matches){
	table_name=matches[2];
	task=matches[1];
	if (task == "Table structure"){
		print table_name;
	}
}

{
	skip = 0;
	if (task == "Dumping data"){
		# Avoids dumping cache tables data
		if ( index(table_name, "cache") == 1 ){
			skip = 1;
		}
	}
	system("")   # flush output

	if(table_name!="" && skip == 0){
		print | "gzip > "filename;
	}
}
