process MACS2{
	tag "$basename_sample"
    label 'process_medium'
	container "quay.io/biocontainers/macs2:2.2.9.1--py311hdad781d_1"

	input:
	tuple val(basename_sample), path(accessibility)

	output:
	path("peaks"), emit: peaks
	tuple val(basename_sample), path("peaks/macs2_peaks.narrowPeak"), emit: narrow_peak

    script:
    """
	if [[ "{$accessibility}" == *tagAlign* ]]; then
			FORMAT="BED"
		else
			FORMAT="AUTO"
		fi
	mkdir -p peaks
    macs2 callpeak \\
		-f \$FORMAT \\
		-g ${params.genome_size} \\
		-p ${params.pval} \\
		-n macs2 \\
		--shift -75 \\
		--extsize 150 \\
		--nomodel \\
		--keep-dup all \\
		--call-summits \\
		--outdir peaks \\
		-t ${accessibility[0]} 
    """
}