# CUSTARDPipeline
**C**GI **U**rsus **S**NP-based **T**rimming **A**nalysing **R**ecording and **D**ocumenting **Pipeline**

## Dependecies
In order to handle python dependencies properly the package uv is used. It needs to be installed and will then recognise project files and pull down needed packages. It is installed in a few different ways depending on system:
```bash
sudo pacman -S uv # Arch
pamac install uv # Manjaro

curl -LsSf https://astral.sh/uv/install.sh | sh # other distros, with curl (refresh terminal)
wget -qO- https://astral.sh/uv/install.sh | sh # other distros, with wget (refresh terminal)
```

Step 1 also requires that there is a folder in the users home directory called `tools` and that it contains the BBTools package (silly, I know). You can make this happen by doing the following:
```bash
cd # move into home directory
mkdir tools
cd tools/
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
uv run ./split_into_chunks.sh # splits samples into chunks of 100, edit if another number is desired
```

## Step 1 - Merge data (if pair-ended)
If your data i pair-ended, merge your ends by running (works no matter if you have split your samples into chunks or not):
```bash
cd CUSTARDPipeline/1_Merged_data/ # move into correct directory
uv run ./merge_all_pairs.sh
```
This will create a log file and write merged files into `CUSTARDPipeline/1_Merged_data/`

## Step 2 - Trim data

### Step A: Trim primers
In order to trim the data in your `CUSTARDPipeline/1_Merged_data/` you use slightly different settings depending on previous choices.

#### Data not in chunks and paired-ended
```bash
cd CUSTARDPipeline/2_Filtered_data/ # move into correct directory
uv run ./trim_all_primers.sh merged Primers/Bear_SNP_all_loci_current.fa
```

#### Data not in chunks and single-ended
```bash
cd CUSTARDPipeline/2_Filtered_data/ # move into correct directory
uv run ./trim_all_primers.sh single Primers/Bear_SNP_all_loci_current.fa
```

#### Data in chunks and paired-ended
First edit `run_individual_chunks.sh` and uncomment/modify which chunks to run.
```bash
cd CUSTARDPipeline/2_Filtered_data/ # move into correct directory
uv run ./run_individual_chunks.sh
```

### Step B: Trim SNPs

#### Data not in chunks
```bash
uv run ./filter_out_SNPs.sh
```

#### Data in chunks
First edit `run_individual_chunks_SNPs.sh` and uncomment/modify which chunks to run.
```bash
uv run ./run_individual_chunks_SNPs.sh
```
