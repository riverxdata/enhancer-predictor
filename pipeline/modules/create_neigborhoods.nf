
process CREATE_NEIGHBORHOODS{
	label 'process_medium'
	container "nttg8100/abc_general:latest"

	input:
	path(accessibility)
	path(sorted_narrow_peak)
	path(chrom_sizes)
	path(chrom_sizes_bed)
	path(genes)
	path(ubiquitous_genes)
	path(h3k27ac)
    path(qnorm)
	val(accessibility_type)


	output:
	path("neighborhood/EnhancerList.txt") , emit: enhancers
	path("neighborhood/GeneList.txt") , emit: genes
	path("neighborhood"), emit: neighborhood
    script:
	def args = "--${accessibility_type} ${accessibility[0]} --H3K27ac ${h3k27ac.findAll{ it.name.endsWith(".bam") }.join(",")}"
	script:
    """
    # get sorted & unique gene list
	# intersect first to remove alternate chromosomes
	bedtools intersect -u -a ${genes} -b ${chrom_sizes_bed} | \\
	bedtools sort -faidx ${chrom_sizes} -i stdin | \\
	uniq > processed_genes_file.bed

	mkdir -p neighborhood			
	run.neighborhoods.py \\
		--candidate_enhancer_regions ${sorted_narrow_peak} \\
		${args} \\
		--chrom_sizes ${chrom_sizes} \\
		--chrom_sizes_bed ${chrom_sizes_bed} \\
		--outdir neighborhood \\
		--genes processed_genes_file.bed \\
		--ubiquitously_expressed_genes ${ubiquitous_genes} \\
        --qnorm ${qnorm}
    """
}