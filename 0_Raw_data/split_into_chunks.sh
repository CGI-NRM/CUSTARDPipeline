#!/bin/bash

# $ bash split_into_chunks.sh

counter=0
for i in ./*1.fq.gz
do
  if [[ $((counter % 100)) == 0 ]] # change from 100 to make smaller or bigger chunks
  then
    mkdir "chunk_$counter"
    destination_folder="chunk_$counter"
  fi
  mv ${i/"1.fq.gz"/"*"} $destination_folder
  counter=$((counter + 1))
done
