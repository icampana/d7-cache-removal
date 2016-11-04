# Drupal 7 Cache databases data dump removal
Simple AWK script to remove the cache tables data from a large dump file

It can handle an uncompressed SQL file or directly an gzipped file, you
need to have gzip installed and gawk, if using Linux it should work out
of the box.  In OSX can be installed with Homebrew.

## Use
Simply pipe the SQL output to the script and it will generate a new gzipped
database dump without the cache data (but still include the table structure).

gunzip -c database.sql.gz |  gawk -f ./db_cleanup.awk
