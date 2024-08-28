process GENERATE_CHROM_SIZE_BED_FILE{
	label 'process_small'
	
	input:
	path(chrom_sizes)
	
	output:
	path("chrom_sizes.bed")

    script:
    """
    awk 'BEGIN {{OFS="\t"}} {{if (NF > 0) print \$1,"0",\$2 ; else print \$0}}' ${chrom_sizes} > chrom_sizes.bed
    """
}