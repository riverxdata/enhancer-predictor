# Enhancer_predictor
Enhancer predictor is the tool to predict the enhancers of target genes using the omics data

Currently, we adapt the model of latest v1.1.2 ABC enhancer (https://github.com/broadinstitute/ABC-Enhancer-Gene-Prediction/releases/tag/v1.1.2).
## Installization
+ Nextflow v23.10.1
+ Docker v27.3.0

To run the pipeline, using the below command, for macos:
```
nextflow run enhancer_predictor.nf -profile docker,arm,K562_chr22
```
for linux
```
nextflow run enhancer_predictor.nf -profile docker,K562_chr22
```

To customize your own data, add your profile using the template of K562_chr22 example `conf/samples/K562_chr22.config`
## Paramters
| Parameter                      | Description                                           |
|--------------------------------|-------------------------------------------------------|
| `accessibility`                | Path to accessibility data files (e.g., BAM, BAI)     |
| `accessibility_feature`        | Accessibility feature (e.g., "DHS")                   |
| `en_activity_feature`          | Enhancer activity feature (e.g., "H3K27ac")           |
| `genome_size`                  | Genome size (e.g., "hs")                              |
| `pval`                         | P-value threshold (e.g., 0.1)                         |
| `chrom_sizes`                  | Path to chromosome sizes file                         |
| `peak_extend_from_summit`      | Number of base pairs to extend peaks from summit (e.g., 250) |
| `n_strongest_peaks`            | Number of strongest peaks to consider (e.g., 150000)  |
| `regions_blocklist`            | Path to regions blocklist file                        |
| `ubiquitous_genes`             | Path to ubiquitously expressed genes file             |
| `genes`                        | Path to gene boundaries file                          |
| `genome_tss`                   | Path to transcription start site (TSS) file           |
| `h3k27ac`                      | Path to H3K27ac data files                            |
| `qnorm`                        | Path to quantile normalization reference file         |
| `flags`                        | Flags for the prediction step (e.g., "--scale_hic_using_powerlaw") |
| `hic_gamma`                    | Hi-C gamma parameter (e.g., 1.024238616787792)        |
| `hic_scale`                    | Hi-C scale parameter (e.g., 5.9594510043736655)       |
| `hic_pseudocount_distance`     | Hi-C pseudocount distance (e.g., 5000)                |
| `hic_type`                     | Hi-C data type (e.g., "hic")                          |
| `hic_resolution`               | Hi-C resolution (e.g., 5000)                          |
| `cell_type`                    | Cell type (e.g., "K562")                              |
| `score_column`                 | Column name for score (e.g., "ABC.Score")             |
| `threshold`                    | Threshold for predictions (e.g., 0.022)               |
| `include_self_promoter`        | Whether to include self-promoter (e.g., "false")      |
| `only_expressed_genes`         | Whether to include only expressed genes (e.g., "false") |
| `filter_params`                | Filter parameters string                              |
| `publish_dir_mode`             | Mode for publishing directory (e.g., "copy")          |
| `outdir`                       | Output directory (e.g., "result/K562_chr22_h3k27ac_dhs") |
| `max_cpus`                     | Maximum number of CPUs to use (e.g., 10)              |
| `max_memory`                   | Maximum memory to use (e.g., 14 GB)                   |

## License
Check `LICENSE`
