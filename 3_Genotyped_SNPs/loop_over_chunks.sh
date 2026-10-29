#!/bin/bash

# Usage (note, it assumes that subfolders are prefixed with "chunk_"):
# $ uv run ./loop_over_chunks.sh

for cur_folder in ../2_Filtered_data/chunk*
do
  chunk_name=${cur_folder/*\/}
  cur_time=`date`
  echo "Parsing "$chunk_name". ("$cur_time")"
  snp_folder=$cur_folder"/SNP_filtered/"
  if [[ -d $snp_folder ]]
  then
    cur_time=`date`
    echo " - Genotyping files in "$snp_folder". ("$cur_time")"
    python ./snpotypewriter.py $snp_folder "genotype" > $chunk_name"_genotypes.csv"
    cur_time=`date`
    echo " - Calculating depths in "$snp_folder". ("$cur_time")"
    python ./snpotypewriter.py $snp_folder "depth" > $chunk_name"_depths.csv"
  else
    echo " - No SNP folder found."
  fi
  echo " - Done."
done
cur_time=`date`
echo "All parsing done. ("$cur_time")"
