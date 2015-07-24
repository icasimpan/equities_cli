## NICE TO HAVE: A way to avoid control+c issue when processing
#!/bin/bash

## -----------------------------------------------------------
## get_allticker() - given $csv_file, output the stock symbols
## -----------------------------------------------------------
get_allticker() {
  local csv_file=$1
  local retval=""

  ## ensure $csv_file exist
  [[ -e $csv_file ]] && {
    retval=$(cat $csv_file|cut -d',' -f1|sort)
  }

  echo $retval
} ## END: get_allticker()

csv_file=$1

output_dir=./output/each_stock
mkdir -p $output_dir

## avoid duplicate processing
sig_csv=$(md5sum $csv_file|cut -d' ' -f1)
[[ $(grep -c $sig_csv $output_dir/processed.log 2>/dev/null) -eq 1 ]] && { echo "ERROR: Previously processed. Aborting"; exit 1; }

start_timestamp=$(date)
## now, process it!
## 
count=0
for each_ticker in $(get_allticker "$csv_file"); do
   echo "processing: $each_ticker"
   ## sanitize ticker name to remove ^ from indices
   clean_ticker=$(echo $each_ticker|sed 's/^\^//g') 
   output_file=$clean_ticker 
   [[ "echo $each_ticker|grep -c ^\^" ]] && { output_file=$(echo $each_ticker|sed 's/^\^/0_INDEX_/g'); }
   grep "$clean_ticker" $csv_file >> $output_dir/${output_file}.csv
   let count=$count+1
done 
end_timestamp=$(date)

## log md5sum of processed csv
md5sum $csv_file >> $output_dir/processed.log

## SUMMARY
input_count=$(wc -l $csv_file|cut -d' ' -f1)
[[ $input_count -eq $count ]] && result='SUCCESSFUL' || result='FAILURE'

echo
echo "Processing $result"
echo
echo "SUMMARY: "
echo "$(basename $csv_file) has $input_count lines"
echo "processed: $count lines"
echo "start: $start_timestamp"
echo "end: $end_timestamp"
