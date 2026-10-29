#!/bin/bash

# Script for running snpotypewriter on all samples in the SNP_filtered folder (i.e. no chunks, but all in one run).
python ./snpotypewriter.py ../Filtered_data/SNP_filtered "genotype" > "all_genotypes.csv"
python ./snpotypewriter.py ../Filtered_data/SNP_filtered "depth" > "all_depths.csv"
