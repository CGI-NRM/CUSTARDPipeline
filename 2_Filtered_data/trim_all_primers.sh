#!/bin/bash

# Usage:
# bash trim_all_primers.sh single Primers/primers.fa
# bash trim_all_primers.sh merged Primers/primers.fa
# bash trim_all_primers.sh chunk Primers/primers.fa ../1_Merged_data/chunk_[n]

# Specify data:
data_type=$1 # the first terminal argument will be taken as data type (single, merged or chunk)
if [[ $data_type == "single" ]] # if single ended data
then
  dataset="../0_Raw_data/*.fastq.gz"
  outdir="../2_Filtered_data/"
  suffix=""
elif [[ $data_type == "merged" ]] # if merged data
then
  dataset=""Merged_data/*.merged.fq.gz""
  outdir="../2_Filtered_data/"
  suffix=""
elif [[ $data_type == "chunk" ]] # if merged chunk data
then
  dataset=""$3/*.merged.fq.gz""
  outdir=${3/"1_Merged_data"/"2_Filtered_data"}
  suffix=${3//"/"/""}
  suffix=${suffix//"."/""}
  suffix="_${suffix//"1_Merged_data"/""}"
  mkdir -p $outdir
fi


# Specify primer file:
primers=$2 # the second terminal argument will be taken as primer file path

# Specify file path:


# Trim primers and create a file for each locus:
trim_primers ()
{
  for file in $2
  do
    sample=$(basename -s .fastq.gz "$file")
    cutadapt -j 0 --discard-untrimmed -e 0.1 --no-indels --error-rate 0.1 -a file:$1 -o $outdir/{name}_$sample.fastq.gz $file
  done
}

trim_primers $primers "$dataset" | tee cutadapt"$suffix"_log.out
