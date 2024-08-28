#!/usr/bin/env nextflow
nextflow.enable.dsl = 2
// modules
include { MACS2 } from "./modules/MACS2.nf"
include { GENERATE_CHROM_SIZE_BED_FILE } from "./modules/generate_genome_bed_file.nf"
include { SORT_NARROW_PEAKS } from "./modules/sort_narrow_peaks.nf"
include { MAKE_CANDIDATE_REGIONS } from "./modules/make_candidate_regions.nf"
include { CREATE_NEIGHBORHOODS } from "./modules/create_neigborhoods.nf"
include { PREDICT } from "./modules/predict.nf"
include { FILTER_PREDICTIONS } from "./modules/filter_predictions.nf"
include { QUALITY_CONTROL } from "./modules/quality_control.nf"

workflow {
	// inputs
	accessibility_ch = Channel.fromFilePairs("${params.accessibility}",checkIfExists:true)
	accessibility_feature_ch = Channel.value("${params.accessibility_feature}")
	en_activity_feature_ch = Channel.value("${params.en_activity_feature}")
	chrom_sizes_ch = Channel.fromPath("${params.chrom_sizes}",checkIfExists:true)
	regions_blocklist_ch = Channel.fromPath("${params.regions_blocklist}",checkIfExists:true)
	tss_ch = Channel.fromPath("${params.genome_tss}",checkIfExists:true)
	peak_extend_from_summit_ch = Channel.value("${params.peak_extend_from_summit}")
	n_strongest_peaks_ch = Channel.value("${params.n_strongest_peaks}")
	genes_ch = Channel.fromPath("${params.genes}")
	ubiquitous_genes_ch = Channel.fromPath("${params.ubiquitous_genes}",checkIfExists:true)
	h3k27ac_ch = Channel.fromPath("${params.h3k27ac}",checkIfExists:true)
	qnorm_ch = Channel.fromPath("${params.qnorm}",checkIfExists:true)
	flags_ch =  Channel.value("${params.flags}")
	hic_file_ch = Channel.fromPath("${params.hic_file}")
	hic_type_ch = Channel.value("${params.hic_type}")
	hic_resolution_ch = Channel.value("${params.hic_resolution}")
	score_column_ch = Channel.value("${params.score_column}")
	cell_type_ch = Channel.value("${params.cell_type}")
    hic_gamma_ch =  Channel.value("${params.hic_gamma}")
    hic_scale_ch =  Channel.value("${params.hic_scale}")
    hic_pseudocount_distance_ch = Channel.value("${params.hic_pseudocount_distance}")
	threshold_ch = Channel.value("${params.threshold}")
	include_self_promoter_ch = Channel.value("${params.include_self_promoter}")
	only_expressed_genes_ch = Channel.value("${params.only_expressed_genes}")
	filter_params_ch = Channel.value("${params.filter_params}")

	// MACS2 peak calling
	MACS2(accessibility_ch)

   	GENERATE_CHROM_SIZE_BED_FILE(chrom_sizes_ch)

	SORT_NARROW_PEAKS(
		MACS2.out.narrow_peak
		.combine(chrom_sizes_ch)
		.combine(GENERATE_CHROM_SIZE_BED_FILE.out)
	)

	// make candidate regions
	MAKE_CANDIDATE_REGIONS(
		accessibility_ch
		.join(SORT_NARROW_PEAKS.out.tuple)
		.combine(chrom_sizes_ch)
		.combine(GENERATE_CHROM_SIZE_BED_FILE.out)
		.combine(regions_blocklist_ch)
		.combine(tss_ch)
		.combine(peak_extend_from_summit_ch)
		.combine(n_strongest_peaks_ch)
	)

	// create neighborhoods
	CREATE_NEIGHBORHOODS(
		accessibility_ch.map{ [it[1]]}.flatten().toList(),
		MAKE_CANDIDATE_REGIONS.out.candidate_regions,
		chrom_sizes_ch,
		GENERATE_CHROM_SIZE_BED_FILE.out,
		genes_ch,
		ubiquitous_genes_ch,
		h3k27ac_ch.collect(),
		qnorm_ch,
		accessibility_feature_ch
	)

	// prediction
	PREDICT(
		CREATE_NEIGHBORHOODS.out.enhancers,
		CREATE_NEIGHBORHOODS.out.genes,
		hic_file_ch,
		hic_type_ch,
		hic_resolution_ch,
		chrom_sizes_ch,
		score_column_ch,
		accessibility_feature_ch,
		cell_type_ch,
		hic_gamma_ch,
		hic_scale_ch,
		hic_pseudocount_distance_ch,
		flags_ch
	)	

	FILTER_PREDICTIONS(
		filter_params_ch,
		PREDICT.out.all_putative,
		PREDICT.out.all_putative_non_expressed,
		score_column_ch,
		threshold_ch,
		include_self_promoter_ch,
		only_expressed_genes_ch
	)
	// qc
	QUALITY_CONTROL(
		filter_params_ch,
		MAKE_CANDIDATE_REGIONS.out.candidate_regions,
		CREATE_NEIGHBORHOODS.out.neighborhood,
		FILTER_PREDICTIONS.out.enh_predictions_full,
		chrom_sizes_ch,
		hic_gamma_ch,
		hic_scale_ch
	)
}
