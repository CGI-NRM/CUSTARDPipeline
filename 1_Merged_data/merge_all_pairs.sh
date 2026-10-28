# Merge all pair in ../0_Raw_data, both in main folder and separated into "chunk_*"-folders
# Usage:
# bash merge_all_pairs.sh

raw_dir="../0_Raw_data"
unm_dir="../Unmerged_reads"
fwd_end="_1.fq.gz"
rev_end="_2.fq.gz"

merge_folder ()
{
  for forward_in in $1/*$fwd_end
  do
    reverse_in=${forward_in/"$fwd_end"/"$rev_end"}
    merged_out=${forward_in/"$raw_dir"/"./"}
    output=${merged_out/"$fwd_end"/""}
    echo $output
#     ~/tools/BBTools/bbmap/bbmerge.sh in1=$forward_in in2=$reverse_in out="./"$output".merged.fq.gz" outu1=$unm_dir"/"$output".unmerged_1.fq.gz" outu2=$unm_dir"/"$output".unmerged_2.fq.gz"
    ~/tools/BBTools/bbmerge.sh in1=$forward_in in2=$reverse_in out="./"$output".merged.fq.gz" outu1=$unm_dir"/"$output".unmerged_1.fq.gz" outu2=$unm_dir"/"$output".unmerged_2.fq.gz"
  done
}

merge_all ()
{
  echo "### Merging files in $raw_dir:"
  merge_folder $raw_dir # process files directly i raw_dir
  for chunk_dir in $raw_dir/chunk_*/ # process any chunk subfolders in raw_dir
  do
    echo "- Processing subfolder: "$chunk_dir
    out_dir=${chunk_dir/$raw_dir/"./"}
    mkdir -p $out_dir
    merge_folder $chunk_dir
  done
}

# Write stout and sterr to log file:
merge_all 2>&1 | tee bbmerge_log.out
