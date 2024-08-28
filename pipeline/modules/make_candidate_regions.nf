process MAKE_CANDIDATE_REGIONS{
	label 'process_medium'
	container "nttg8100/abc_general:latest"

	input:
	tuple val(basename_sample),
	path(accessibility),
	path(sorted_narrow_peak),
	path(chrom_sizes),
	path(chrom_sizes_bed),
	path(regions_blocklist),
	path(tss),
	val(peak_extend_from_summit),
	val(n_strongest_peak)

	output:
	path("candidate_regions"), emit: full
	path("candidate_regions/macs2_peaks.sorted.narrowPeak.candidateRegions.bed"), emit: candidate_regions

    script:
    """
	mkdir -p candidate_regions
    makeCandidateRegions.py \\
		--narrowPeak ${sorted_narrow_peak} \\
		--accessibility ${accessibility[0]} \\
		--outDir candidate_regions \\
		--chrom_sizes ${chrom_sizes} \\
		--chrom_sizes_bed ${chrom_sizes_bed} \\
		--regions_blocklist ${regions_blocklist} \\
		--regions_includelist ${tss} \\
		--peakExtendFromSummit ${peak_extend_from_summit} \\
		--nStrongestPeak ${n_strongest_peak}
    """
}