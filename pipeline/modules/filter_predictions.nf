
process FILTER_PREDICTIONS{
	label 'process_medium'
	container "nttg8100/abc_general:latest"

	input:
    val(filter_params)
    path(all_putative)
    path(all_putative_non_expressed)
    val(score_column)
    val(threshold)
    val(include_self_promoter)
    val(only_expressed_genes)

    output:
    path("filter_predictions")
    path("filter_predictions/EnhancerPredictionsFull_${filter_params}.tsv"), emit: enh_predictions_full

    script:
    """
    mkdir -p filter_predictions
    filter_predictions.py \\
    --output_tsv_file filter_predictions/EnhancerPredictionsFull_${filter_params}.tsv \\
    --output_slim_tsv_file filter_predictions/EnhancerPrediction_${filter_params}.tsv \\
    --output_bed_file filter_predictions/EnhancerPredictionsFull_${filter_params}.bedpe.gz \\
    --output_gene_stats_file filter_predictions/GenePredictionStats_${filter_params}.tsv \\
    --pred_file ${all_putative} \\
    --pred_nonexpressed_file ${all_putative_non_expressed} \\
    --score_column ${score_column} \\
    --threshold ${threshold} \\
    --include_self_promoter ${include_self_promoter} \\
    --only_expressed_genes ${only_expressed_genes}
    """
}