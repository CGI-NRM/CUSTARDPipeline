# CUSTARDPipeline
**C**GI **U**rsus **S**NP-based **T**rimming **A**nalysing **R**ecording and **D**ocumenting **Pipeline**

## Dependecies
Step 1 requires that there is a folder in the users home directory called `tools` and that it contains the BBTools package (silly, I know). You can make this happen by doing the following:
```bash
cd # move into home directory
mkdir tools cd tools/
git clone https://github.com/bbushnell/BBTools
```
Or edit `CUSTARDPipeline/1_Merged_data/merge_all_pairs.sh` if you have bbmerge.sh installed somewhere else (or in your path).

## Download pipeline

Simple enough, navigate to where you want to run your analysis and run:
```bash
git clone https://github.com/CGI-NRM/CUSTARDPipeline
```

## Step 0 - Add data
Move your raw *.fq.gz reads to the folder `CUSTARDPipeline/0_Raw_data/`. If you wish to split your samples into chunks simply run:
```bash
cd CUSTARDPipeline/0_Raw_data/ # move into correct directory
bash split_into_chunks.sh # splits samples into chunks of 100, edit if another number is desired
```

## Step 1 - Merge data (if pair-ended)
If your data i pair-ended, merge your ends by running:
```bash
cd CUSTARDPipeline/1_Merged_data/ # move into correct directory
bash merge_all_pairs.sh
```
This will create a log file and write merged files into `CUSTARDPipeline/1_Merged_data/`
