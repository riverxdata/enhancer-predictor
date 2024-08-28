process SORT_NARROW_PEAKS{
	label 'process_small'
	container "quay.io/biocontainers/bedtools:2.31.1--hf5e1c6e_0"

	input:
	tuple val(sample),
	path(narrow_peak),
	path(chrom_sizes),
	path(chrom_sizes_bed)

	output:
	tuple val(sample), path("macs2_peaks.sorted.narrowPeak"), emit: tuple
	path("macs2_peaks.sorted.narrowPeak"), emit: file

    script:
    """
    bedtools intersect -u -a ${narrow_peak} -b ${chrom_sizes_bed} | \
    bedtools sort -faidx ${chrom_sizes} -i stdin > macs2_peaks.sorted.narrowPeak
	"""
}
