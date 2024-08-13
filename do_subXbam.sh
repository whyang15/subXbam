#!/usr/bin/env bash
# set -x

# User Input Variables:
BAM_LIST="bam_list.txt"
GENOME_SIZE=5000
END_COV=5
OUTDIR="output_directory"

# Check if input file exists:
if [[ ! -f "$BAM_LIST" ]]; then
    echo "Error: BAM list file '$BAM_LIST' not found."
    exit 1
fi


# read in the input and make that as list.
while IFS= read -r bam || [[ -n "$bam" ]]; do
    echo -e "\nProcessing BAM file: $bam"  
    if [[ ! -f "$bam" ]]; then
        echo "Error: BAM file '$bam' not found."
        continue
    fi

    # calculate how big the bam size is.
        # Read lengths. Use `grep ^RL | cut -f 2-` to extract this part. The columns are: read length, count
    TOTAL_BASES=$(samtools stats "$bam" | grep ^RL | cut -f 2- | awk '{sum += $1 * $2} END { print sum }')
    if [[ -z "$TOTAL_BASES" ]]; then
        echo "Error: Failed to calculate total bases for $bam"
        continue
    fi

    
    # calculate how much coverage is in the original bam.
    EST_COVERAGE=$(echo "scale=2; $TOTAL_BASES / $GENOME_SIZE" | bc)
    echo "Total bases in the BAM file: $TOTAL_BASES"
    echo "Estimated Coverage: $EST_COVERAGE"

    # calculate the subsample factor to reach final coverage.
    SUBX=$(echo "scale=2; $END_COV / $EST_COVERAGE" | bc)
    echo "Subsample factor: $SUBX"

    # new output name:
    # Strip the extension from the input file name
    INPUT_NAME=$(basename "$bam" .bam)
    echo "Input name: $INPUT_NAME"

    # Generate the output file name
    OUTPUT_NAME="${INPUT_NAME}_subset_${END_COV}x.bam"

    # use samtools to do the subsample using the subsample factor and create a new bam file.
    samtools view -b -o "$OUTDIR"/"$OUTPUT_NAME" -s "$SUBX" "$bam" 
    if [[ $? -ne 0 ]]; then
        echo "Error: samtools view failed for $bam"
        continue
    fi

    echo -e "Output file: "$OUTDIR"/"$OUTPUT_NAME"\n "

done < "$BAM_LIST"

