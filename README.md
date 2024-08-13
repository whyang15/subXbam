# subXbam
This tool will take in a list of BAM files, subsample each BAM file to the desired genome coverage, and create new subsample BAM files.

## How it Works
The shell script uses samtools for the following tasks:
- Calculating the total bases in each BAM file
- Determining the estimated coverage of the original BAM file
- Calculating the subsampling factor to reach the desired final coverage
- Subsampling the original BAM file and creating a new subsample BAM file


Within the shell script, user can specify what their estimated genome size and how much coverage they want at the end.  
```
# User Input Variables:
BAM_LIST="bam_list.txt"
GENOME_SIZE=5000000
END_COV=15
OUTDIR="/your_working_directory/subXbam_outputs"
```


## Usage
1. Ensure you have samtools installed on your system.
2. Create a text file bam_list.txt that contains the paths to your BAM files, one per line.
3. Update the User Input Variables section in the shell script with your desired settings.
4. Run the shell script to generate the subsample BAM files in the specified output directory.

```
bash do_subXbam.sh
```
or 
```
./do_subXbam.sh
```


The subsample BAM files will be named with the format <input_name>_subset_<end_cov>x.bam, where <input_name> is the base name of the original BAM file, and <end_cov> is the desired final coverage.

## Example Run and output:
```
% ./do_subXbam.sh 

Processing BAM file: /Users/weihsienyang/Desktop/AY_Porfolio/datasets/PB_Microbial/m64004_210929_143746.bc2031.bam
Total bases in the BAM file: 187013282
Estimated Coverage: 37.40
Subsample factor: .40
Input name: m64004_210929_143746.bc2031
Output file: /Users/weihsienyang/Desktop/AY_Porfolio/datasets/PB_Microbial/subXbam_outputs/m64004_210929_143746.bc2031_subset_15x.bam
 

Processing BAM file: /Users/weihsienyang/Desktop/AY_Porfolio/datasets/PB_Microbial/m64004_210929_143746.bc2032.bam
Total bases in the BAM file: 168500264
Estimated Coverage: 33.70
Subsample factor: .44
Input name: m64004_210929_143746.bc2032
Output file: /Users/weihsienyang/Desktop/AY_Porfolio/datasets/PB_Microbial/subXbam_outputs/m64004_210929_143746.bc2032_subset_15x.bam
 
```

