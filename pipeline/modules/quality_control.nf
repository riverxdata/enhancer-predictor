process QUALITY_CONTROL{
    label 'process_medium'
	container "nttg8100/abc_general:latest"

    input:
    val(filter_params)
    path(candidate_regions)
    path(neighborhood_directory)
    path(enh_predictions_full)
    path(chrom_sizes)
    val(gamma)
    val(scale)


    output:
    path("metrics")
    path("metrics/QCSummary_${filter_params}.tsv")
    path("metrics/QCPlots_${filter_params}.pdf")

    script:
    """
    mkdir -p metrics
    grabMetrics.py \\
			--outdir metrics \\
			--output_qc_summary metrics/QCSummary_${filter_params}.tsv \\
			--output_qc_plots metrics/QCPlots_${filter_params}.pdf \\
			--macs_peaks ${candidate_regions} \\
			--neighborhood_outdir ${neighborhood_directory} \\
			--preds_file ${enh_predictions_full} \\
			--chrom_sizes ${chrom_sizes} \\
			--hic_gamma ${gamma} \\
			--hic_scale ${scale} 
    """
}