
process PREDICT{
	label 'process_medium'
	container "nttg8100/abc_general:latest"

	input:
	path(enhancers)
    path(genes)
    file(hic_file)
    val(hic_type)
    val(hic_resolution)
    path(chrom_sizes)
    val(score_column)
    val(accessibility_feature)
    val(cellType)
    val(gamma)
    val(scale)
    val(hic_pseudocount_distance)
    val(flags)

    output:
    path("predict/EnhancerPredictionsAllPutative.tsv.gz") , emit: all_putative
    path("predict/EnhancerPredictionsAllPutativeNonExpressedGenes.tsv.gz") , emit: all_putative_non_expressed
    
    script:
    """
    if [ "$hic_file" != "null" ]; then
        args="--hic_file ${hic_file} --hic_type ${hic_type} --hic_resolution ${hic_resolution}"
    else
        args=""
    fi

    mkdir -p predict
    predict.py \\
    --enhancers ${enhancers} \\
    --genes ${genes} \\
    --outdir predict \\
    --score_column ${score_column} \\
    --chrom_sizes ${chrom_sizes} \\
    --accessibility_feature ${accessibility_feature} \\
    --cellType ${cellType} \\
    --hic_gamma ${gamma} \\
    --hic_scale ${scale} \\
    --hic_pseudocount_distance ${hic_pseudocount_distance} \\
    ${flags} \\
    \${args}
    """
}