#!/bin/bash

# Usage (note, it assumes that subfolders are prefixed with "chunk_"):
# bash loop_over_chunks.sh ../Filtered_data/

for cur_folder in $1/chunk*
do
  chunk_name=${cur_folder/*\/}
  cur_time=`date`
  echo "Parsing "$chunk_name". ("$cur_time")"
  snp_folder=$cur_folder"/SNP_filtered/"
  if [[ -d $snp_folder ]]
  then
    cur_time=`date`
    echo " - Genotyping files in "$snp_folder". ("$cur_time")"
    python ./snpotypewriter.py $snp_folder > $chunk_name"_genotypes.csv" "genotype"
    echo " - Calculating depths in "$snp_folder". ("$cur_time")"
    python ./snpotypewriter.py $snp_folder > $chunk_name"_depths.csv" "depth"
  else
    echo " - No SNP folder found."
  fi
  echo " - Done."
done
cur_time=`date`
echo "All parsing done. ("$cur_time")"
