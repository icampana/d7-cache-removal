#!/usr/bin/awk -f

BEGIN{
	skip = 1;
	table_name="";
	task="";
	filename = "clean_database.sql.gz";

	if (output_file != ""){
		filename = output_file;
	}

	speedup_header = "SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, AUTOCOMMIT = 0;\nSET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;\nSET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;\n";

	if (filename == "stdout"){
		print speedup_header;
	} else {
		print speedup_header | "gzip > "filename;
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
		if (filename == "stdout"){
			print ;
		} else {
			print | "gzip > "filename;
		}
	}
}
END{
	speedup_footer = "SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;\nSET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;\nSET AUTOCOMMIT = @OLD_AUTOCOMMIT;\nCOMMIT;";

	if (filename == "stdout"){
		print speedup_footer;
	} else {
		print speedup_footer | "gzip > "filename;
	}
}
