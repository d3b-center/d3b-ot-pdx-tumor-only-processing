cwlVersion: sbg:draft-2
class: Workflow
label: PDX RNA Expression Estimation Workflow
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: SubworkflowFeatureRequirement
- class: InlineJavascriptRequirement

inputs:
- id: '#ref_flat'
  label: refFlat file
  type:
  - File
  description: refFlat file
  sbg:fileTypes: TXT
  sbg:includeInPorts: true
  sbg:suggestedValue:
    name: refFlat file
    class: File
    path: 5dcd7d94e4b0eeec709a20d3
  sbg:x: 902.4514261881516
  sbg:y: 302.3531214396161
- id: '#rsem_prepare_reference_archive'
  label: RSEM prepared STAR reference indices
  type:
  - File
  description: RSEM-prepared STAR reference indices
  sbg:fileTypes: TAR
  sbg:includeInPorts: true
  sbg:suggestedValue:
    name: RSEM-prepared star reference indicies
    class: File
    path: 5dcd7d94e4b0eeec709a20d0
  sbg:x: 476.66669209798204
  sbg:y: 758.1374104817712
- id: '#ribosomal_intervals'
  label: Ribosomal intervals
  type:
  - 'null'
  - File
  description: Ribosomal intervals
  sbg:fileTypes: INTERVAL
  sbg:includeInPorts: true
  sbg:suggestedValue:
    name: Ribosomal intervals HG38
    class: File
    path: 5dcd7d94e4b0eeec709a20d2
  sbg:x: 910.0002034505213
  sbg:y: 178.33336512247732
- id: '#index_file'
  label: Xenome index files
  type:
  - File
  description: TGZ archive with Xenome index files
  sbg:fileTypes: TGZ, TAR.GZ
  sbg:includeInPorts: true
  sbg:suggestedValue:
    name: Xenome index files
    class: File
    path: 5dcd7d94e4b0eeec709a20d1
  sbg:x: 486.6667175292972
  sbg:y: 611.666666666667
- id: '#input_pair'
  label: Input FASTQ files
  type:
  - type: array
    items: File
  description: Input FASTQ files
  sbg:fileTypes: FASTQ, FASTQ.GZ, FQ, FQ.GZ, FQ.BZ2, FASTQ.BZ2
  sbg:includeInPorts: true
  sbg:x: 235.0001144409181
  sbg:y: 298.33346048990904
- id: '#forward_prob'
  label: Forward probability
  type:
  - 'null'
  - float
  description: |-
    Probability of generating a read from the forward strand of a transcript. Set to 1 for a strand-specific protocol where all (upstream) reads are derived from the forward strand, 0 for a strand-specific protocol where all (upstream) read are derived from the reverse strand, or 0.5 for a non-strand-specific protocol.
  required: false
  sbg:category: Advanced options
  sbg:suggestedValue: 0.5
  sbg:toolDefaultValue: '0.5'
- id: '#strand_specificity'
  label: Strand specificity
  type:
  - name: strand_specificity
    type: enum
    symbols:
    - NONE
    - FIRST_READ_TRANSCRIPTION_STRAND
    - SECOND_READ_TRANSCRIPTION_STRAND
  inputBinding:
    prefix: STRAND_SPECIFICITY=
    separate: false
    sbg:cmdInclude: true
  description: |-
    This parameter is to be set when using strand-specific library preparations. If the unpaired reads are expected to be on the transcription strand, the FIRST_READ_TRANSCRIPTION_STRAND option must be used.
  required: true
  sbg:altPrefix: STRAND
  sbg:category: Options
  sbg:suggestedValue: NONE
  sbg:toolDefaultValue: STRAND
- id: '#metric_accumulation_level'
  label: Metric accumulation level
  type:
  - 'null'
  - name: metric_accumulation_level
    type: enum
    symbols:
    - ALL_READS
    - SAMPLE
    - LIBRARY
    - READ_GROUP
  inputBinding:
    prefix: METRIC_ACCUMULATION_LEVEL=
    position: 8
    separate: false
    itemSeparator:
    sbg:cmdInclude: true
  description: |-
    This option sets the level(s) at which metrics are accumulated. Default value: [ALL_READS]. This option can be set to 'null' to clear the default value. Possible values: {ALL_READS, SAMPLE, LIBRARY, READ_GROUP} This option may be specified to 0 or more times. This option can be set to 'null' to clear the default list.
  required: false
  sbg:altPrefix: LEVEL
  sbg:category: Options
  sbg:suggestedValue: ALL_READS
  sbg:toolDefaultValue: ALL_READS
- id: '#ReadTotal'
  label: Minimum number of human-specific reads
  type:
  - 'null'
  - int
  description: Number of human-specific reads from Xenome (default is 1M paired-end
    reads).
  sbg:toolDefaultValue: '1000000'
- id: '#Sites'
  label: Somalier Sites file
  doc: Sites vcf file of variants to extract
  type:
  - File
  description: Sites vcf file of variants to extract
  sbg:fileTypes: VCF.GZ
  sbg:includeInPorts: true
  sbg:x: 2774.52587890625
  sbg:y: 153.2888946533203
- id: '#Reference'
  label: FASTA Reference
  doc: Path to reference fasta file
  type:
  - File
  description: Path to reference fasta file
  sbg:fileTypes: FASTA, FA
  sbg:includeInPorts: true
  sbg:suggestedValue:
    name: Homo sapiens 38 reference
    class: File
    path: 5dcd7d94e4b0eeec709a20ef
  sbg:x: 2776.21484375
  sbg:y: 559.7703857421875

outputs:
- id: '#rsem_model_plot'
  label: RSEM model plot
  type:
  - 'null'
  - File
  source:
  - '#RSEM_Plot_Model.rsem_model_plot'
  description: RSEM model plot
  required: false
  sbg:fileTypes: PDF
  sbg:includeInPorts: true
  sbg:x: 1297.7453613281257
  sbg:y: 562.7452087402347
- id: '#sample_name_isoforms_results'
  label: Isoform level expression estimates
  type:
  - 'null'
  - File
  source:
  - '#unix_cat_header.output'
  description: Isoform level expression estimates
  required: false
  sbg:includeInPorts: true
  sbg:x: 2338.65283203125
  sbg:y: 489.6705017089844
- id: '#sample_name_transcript_bam'
  label: BAM in transcript coordinates
  type:
  - 'null'
  - File
  source:
  - '#RSEM_Calculate_Expression.sample_name_transcript_bam'
  description: BAM in transcript coordinates
  required: false
  sbg:fileTypes: BAM
  sbg:includeInPorts: true
  sbg:x: 1281.2073974609375
  sbg:y: 914.7333374023438
- id: '#sample_name_genes_results'
  label: Gene level expression estimates
  type:
  - 'null'
  - File
  source:
  - '#unix_cat_header_1.output'
  description: Gene level expression estimates
  required: false
  sbg:includeInPorts: true
  sbg:x: 2344.318115234375
  sbg:y: 791.8929443359375
- id: '#report_zip'
  label: FASTQC reports ZIP archive
  type:
  - 'null'
  - type: array
    items: File
  source:
  - '#FastQC.report_zip'
  description: FASTQC reports ZIP archive
  required: false
  sbg:fileTypes: ZIP
  sbg:includeInPorts: true
  sbg:x: 726.6670227050786
  sbg:y: 180.00007311503103
- id: '#report_html'
  label: FASTQC HTML report
  type:
  - 'null'
  - type: array
    items: File
  source:
  - '#FastQC.report_html'
  description: FASTQC HTML report
  required: false
  sbg:fileTypes: HTML
  sbg:includeInPorts: true
  sbg:x: 731.6669718424483
  sbg:y: 311.666831970215
- id: '#integrated_QC_report'
  label: Integrated QC report
  type:
  - 'null'
  - File
  source:
  - '#QC_Integrate_RNA.integrated_QC_report'
  description: Integrated QC report
  required: false
  sbg:fileTypes: TXT
  sbg:includeInPorts: true
  sbg:x: 1429.499267578125
  sbg:y: 144.1125946044922
- id: '#chart_output'
  label: Picard CollectRNASeqMetrics report
  type:
  - 'null'
  - File
  source:
  - '#Picard_CollectRnaSeqMetrics.chart_output'
  description: Picard CollectRNASeqMetrics report
  required: false
  sbg:fileTypes: PDF
  sbg:includeInPorts: true
  sbg:x: 1431.6667683919281
  sbg:y: 410.0000508626304
- id: '#Somalier_File'
  label: Somalier Extract File
  type:
  - 'null'
  - File
  source:
  - '#somalier.Somalier_File'
  sbg:x: 3168.185302734375
  sbg:y: 285.8888854980469
- id: '#indexed_data_file'
  label: BAM in genome coordinates
  doc: Output BAM/CRAM, along with its index as secondary file.
  type:
  - 'null'
  - File
  secondaryFiles:
  - .bai
  - .crai
  - ^.bai
  - ^.crai
  - .csi
  - ^.csi
  source:
  - '#samtools_index.indexed_data_file'
  description: Output BAM/CRAM, along with its index as secondary file.
  sbg:fileTypes: BAM, CRAM
  sbg:x: 2339.07421875
  sbg:y: 169.91763305664062

steps:
- id: '#RSEM_Calculate_Expression'
  label: RSEM Calculate Expression
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#RSEM_Calculate_Expression.cwl
  inputs:
  - id: '#RSEM_Calculate_Expression.star'
    default: true
  - id: '#RSEM_Calculate_Expression.rsem_prepare_reference_archive'
    source: '#rsem_prepare_reference_archive'
  - id: '#RSEM_Calculate_Expression.read_files'
    source:
    - '#XenomeV2_Transcriptome.human_forward'
    - '#XenomeV2_Transcriptome.human_reverse'
  - id: '#RSEM_Calculate_Expression.output_genome_bam'
    default: true
  - id: '#RSEM_Calculate_Expression.forward_prob'
    source: '#forward_prob'
  outputs:
  - id: '#RSEM_Calculate_Expression.star_log_files'
  - id: '#RSEM_Calculate_Expression.sample_name_transcript_bam'
  - id: '#RSEM_Calculate_Expression.sample_name_isoforms_results'
  - id: '#RSEM_Calculate_Expression.sample_name_genome_bam'
  - id: '#RSEM_Calculate_Expression.sample_name_genes_results'
  - id: '#RSEM_Calculate_Expression.sample_name_alleles_results'
  - id: '#RSEM_Calculate_Expression.rsem_calculate_expression_archive'
  sbg:x: 815.1965332031255
  sbg:y: 695.0187174479171
- id: '#QC_Integrate_RNA'
  label: QC Integrate RNA
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#QC_Integrate_RNA.cwl
  inputs:
  - id: '#QC_Integrate_RNA.XenomeReport'
    source: '#XenomeV2_Transcriptome.stats_file'
  - id: '#QC_Integrate_RNA.PicardCollectRNASeqMetrics'
    source: '#Picard_CollectRnaSeqMetrics.rna_seq_metrics'
  outputs:
  - id: '#QC_Integrate_RNA.integrated_QC_report'
  sbg:x: 1322.12890625
  sbg:y: 303
- id: '#Picard_CollectRnaSeqMetrics'
  label: Picard CollectRnaSeqMetrics
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#Picard_CollectRnaSeqMetrics.cwl
  inputs:
  - id: '#Picard_CollectRnaSeqMetrics.strand_specificity'
    default: NONE
    source: '#strand_specificity'
  - id: '#Picard_CollectRnaSeqMetrics.ribosomal_intervals'
    source: '#ribosomal_intervals'
  - id: '#Picard_CollectRnaSeqMetrics.ref_flat'
    source: '#ref_flat'
  - id: '#Picard_CollectRnaSeqMetrics.metric_accumulation_level'
    source: '#metric_accumulation_level'
  - id: '#Picard_CollectRnaSeqMetrics.input_bam'
    source: '#RSEM_Calculate_Expression.sample_name_genome_bam'
  outputs:
  - id: '#Picard_CollectRnaSeqMetrics.rna_seq_metrics'
  - id: '#Picard_CollectRnaSeqMetrics.chart_output'
  sbg:x: 1173.137512207032
  sbg:y: 411.8813069661461
- id: '#RSEM_Plot_Model'
  label: RSEM Plot Model
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#RSEM_Plot_Model.cwl
  inputs:
  - id: '#RSEM_Plot_Model.rsem_calculate_expression_archive'
    source: '#RSEM_Calculate_Expression.rsem_calculate_expression_archive'
  outputs:
  - id: '#RSEM_Plot_Model.rsem_model_plot'
  sbg:x: 1138.4319051106777
  sbg:y: 562.2112274169925
- id: '#FastQC'
  label: FastQC
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#FastQC.cwl
  inputs:
  - id: '#FastQC.input_fastq'
    source:
    - '#SBG_Decompressor.output_files'
  outputs:
  - id: '#FastQC.report_zip'
  - id: '#FastQC.report_html'
  sbg:x: 505.00020345052116
  sbg:y: 250.00015258789077
- id: '#XenomeV2_Transcriptome'
  label: XenomeV2 Transcriptome
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#XenomeV2_Transcriptome.cwl
  inputs:
  - id: '#XenomeV2_Transcriptome.pairs'
    default: true
  - id: '#XenomeV2_Transcriptome.indices_name'
    default: hg38_broad_NOD_based_on_mm10_k25
  - id: '#XenomeV2_Transcriptome.index_file'
    source: '#index_file'
  - id: '#XenomeV2_Transcriptome.fastq_reverse'
    source: '#SBG_Split_Pair_by_Metadata.output_files_2'
  - id: '#XenomeV2_Transcriptome.fastq_forward'
    source: '#SBG_Split_Pair_by_Metadata.output_files_1'
  outputs:
  - id: '#XenomeV2_Transcriptome.stats_file'
  - id: '#XenomeV2_Transcriptome.human_reverse'
  - id: '#XenomeV2_Transcriptome.human_forward'
  sbg:x: 644.7568359375
  sbg:y: 463
- id: '#QC_Xenome_Report_1'
  label: QC Xenome Check
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#QC_Xenome_Report_1.cwl
  inputs:
  - id: '#QC_Xenome_Report_1.stats_file'
    source: '#XenomeV2_Transcriptome.stats_file'
  - id: '#QC_Xenome_Report_1.ReadTotal'
    source: '#ReadTotal'
  outputs:
  - id: '#QC_Xenome_Report_1.integrated_QC_report'
  - id: '#QC_Xenome_Report_1.error_log'
  sbg:x: 850.0002034505213
  sbg:y: 483.33343505859403
- id: '#SBG_Decompressor'
  label: SBG Decompressor
  in: []
  scatter: '#SBG_Decompressor.input_archive_file'
  run: pdx-rna-tumor-only.cwl.steps/#SBG_Decompressor.cwl
  inputs:
  - id: '#SBG_Decompressor.input_archive_file'
    source: '#input_pair'
  outputs:
  - id: '#SBG_Decompressor.output_files'
  sbg:x: 371.6666803757352
  sbg:y: 340.0000017616486
- id: '#SBG_Split_Pair_by_Metadata'
  label: SBG Split Pair by Metadata
  in: []
  scatter: '#SBG_Split_Pair_by_Metadata.input_pair'
  run: pdx-rna-tumor-only.cwl.steps/#SBG_Split_Pair_by_Metadata.cwl
  inputs:
  - id: '#SBG_Split_Pair_by_Metadata.metadata_criteria'
    default:
      output_1: paired_end:1
      output_2: paired_end:2
  - id: '#SBG_Split_Pair_by_Metadata.input_pair'
    source:
    - '#SBG_Decompressor.output_files'
  outputs:
  - id: '#SBG_Split_Pair_by_Metadata.output_files_2'
  - id: '#SBG_Split_Pair_by_Metadata.output_files_1'
  sbg:x: 496.66679382324253
  sbg:y: 421.6667683919273
- id: '#picard_addorreplacereadgroups_1_140'
  label: Picard AddOrReplaceReadGroups
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#picard_addorreplacereadgroups_1_140.cwl
  inputs:
  - id: '#picard_addorreplacereadgroups_1_140.input_bam'
    source:
    - '#samtools_index.indexed_data_file'
  - id: '#picard_addorreplacereadgroups_1_140.read_group_platform_unit'
    default: PU
  - id: '#picard_addorreplacereadgroups_1_140.read_group_platform'
    default: PL
  - id: '#picard_addorreplacereadgroups_1_140.read_group_lib'
    default: LIB
  - id: '#picard_addorreplacereadgroups_1_140.create_index'
    default: 'True'
  outputs:
  - id: '#picard_addorreplacereadgroups_1_140.edited_bam'
  sbg:x: 2649.229736328125
  sbg:y: 289.89630126953125
- id: '#somalier'
  label: Somalier Extract
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#somalier.cwl
  inputs:
  - id: '#somalier.Sites'
    source: '#Sites'
  - id: '#somalier.Reference'
    source: '#Reference'
  - id: '#somalier.Sample_file'
    source:
    - '#picard_addorreplacereadgroups_1_140.edited_bam'
  outputs:
  - id: '#somalier.Somalier_File'
  sbg:x: 2965.888916015625
  sbg:y: 386.96295166015625
- id: '#java_tester_9'
  label: perc_correct_strand
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#java_tester_9.cwl
  inputs:
  - id: '#java_tester_9.input'
    source: '#QC_Integrate_RNA.integrated_QC_report'
  outputs:
  - id: '#java_tester_9.output'
  sbg:x: 1744.639892578125
  sbg:y: 8.95759391784668
- id: '#java_tester_8'
  label: perc_usable_bases
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#java_tester_8.cwl
  inputs:
  - id: '#java_tester_8.input'
    source: '#QC_Integrate_RNA.integrated_QC_report'
  outputs:
  - id: '#java_tester_8.output'
  sbg:x: 1734.4365234375
  sbg:y: -230.387939453125
- id: '#java_tester_7'
  label: perc_ribosomal_bases
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#java_tester_7.cwl
  inputs:
  - id: '#java_tester_7.input'
    source: '#QC_Integrate_RNA.integrated_QC_report'
  outputs:
  - id: '#java_tester_7.output'
  sbg:x: 1737.3817138671875
  sbg:y: -108.16917419433594
- id: '#java_tester_5'
  label: human_percentage
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#java_tester_5.cwl
  inputs:
  - id: '#java_tester_5.input'
    source: '#QC_Integrate_RNA.integrated_QC_report'
  outputs:
  - id: '#java_tester_5.output'
  sbg:x: 1746.130615234375
  sbg:y: 269.6145935058594
- id: '#java_tester_4'
  label: human_read_count
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#java_tester_4.cwl
  inputs:
  - id: '#java_tester_4.input'
    source: '#QC_Integrate_RNA.integrated_QC_report'
  outputs:
  - id: '#java_tester_4.output'
  sbg:x: 1745.7955322265625
  sbg:y: 131.76416015625
- id: '#samtools_index'
  label: SAMtools Index - RNA
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#samtools_index.cwl
  inputs:
  - id: '#samtools_index.input_bam_or_cram_file'
    source: '#samtools_sort_1_6.sorted_file'
  - id: '#samtools_index.output_indexed_data'
    default: true
  - id: '#samtools_index.perc_correct_strand'
    source: '#java_tester_9.output'
  - id: '#samtools_index.perc_usable_bases'
    source: '#java_tester_8.output'
  - id: '#samtools_index.perc_ribosomal'
    source: '#java_tester_7.output'
  - id: '#samtools_index.human_percentage'
    source: '#java_tester_5.output'
  - id: '#samtools_index.human_read_count'
    source: '#java_tester_4.output'
  outputs:
  - id: '#samtools_index.indexed_data_file'
  - id: '#samtools_index.generated_index'
  sbg:x: 2178.46484375
  sbg:y: 343
- id: '#unix_cat_header'
  label: metadata_annot
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#unix_cat_header.cwl
  inputs:
  - id: '#unix_cat_header.input'
    source: '#RSEM_Calculate_Expression.sample_name_isoforms_results'
  - id: '#unix_cat_header.perc_correct_strand'
    source: '#java_tester_9.output'
  - id: '#unix_cat_header.perc_usable_bases'
    source: '#java_tester_8.output'
  - id: '#unix_cat_header.perc_ribosomal'
    source: '#java_tester_7.output'
  - id: '#unix_cat_header.human_percentage'
    source: '#java_tester_5.output'
  - id: '#unix_cat_header.human_read_count'
    source: '#java_tester_4.output'
  outputs:
  - id: '#unix_cat_header.output'
  sbg:x: 2031.29931640625
  sbg:y: 627.9285888671875
- id: '#unix_cat_header_1'
  label: metadata_annot
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#unix_cat_header_1.cwl
  inputs:
  - id: '#unix_cat_header_1.input'
    source: '#RSEM_Calculate_Expression.sample_name_genes_results'
  - id: '#unix_cat_header_1.perc_correct_strand'
    source: '#java_tester_9.output'
  - id: '#unix_cat_header_1.perc_usable_bases'
    source: '#java_tester_8.output'
  - id: '#unix_cat_header_1.perc_ribosomal'
    source: '#java_tester_7.output'
  - id: '#unix_cat_header_1.human_percentage'
    source: '#java_tester_5.output'
  - id: '#unix_cat_header_1.human_read_count'
    source: '#java_tester_4.output'
  outputs:
  - id: '#unix_cat_header_1.output'
  sbg:x: 2027.27685546875
  sbg:y: 914
- id: '#samtools_sort_1_6'
  label: SAMtools Sort
  in: []
  run: pdx-rna-tumor-only.cwl.steps/#samtools_sort_1_6.cwl
  inputs:
  - id: '#samtools_sort_1_6.input_file'
    source: '#RSEM_Calculate_Expression.sample_name_genome_bam'
  outputs:
  - id: '#samtools_sort_1_6.sorted_file'
  sbg:x: 1637.5111083984375
  sbg:y: 567.3262329101562
description: |-
  This RSEM workflow (RSEM 1.2.31) for quantifying gene expression uses the STAR aligner and is optimized to work with FASTQ input files.

  To process multiple samples, please consider running batch tasks with this workflow and aggregating the results using **Prepare Multisample Data** [workflow](https://cgc.sbgenomics.com/u/pdxnet/pdx-wf-commit2/apps/#pdxnet/pdx-wf-commit2/prepare-multisample-data).

  Note: This workflow utilizes the tool `Xenome` to removed mouse-reads from the raw-read data. `Xenome` uses host and graft reference sequences to characterize the set of all possible k-mers according to whether they belong to: only the graft (and not the host), only the host (and not the graft), both references, neither reference, and marginal asignments. This workflow uses those reads classified as 'human-only'.

  ###Essential Requirements

  The following metadata fields are essential and should be assigned to input FASTQ files:

  1. **Sample ID**: Any string. The identifier should be identical for both paired-end FASTQ files. 
  2. **Paired-end**: 1 or 2

  This workflow will process both uncompressed and compressed FASTQ files (FASTQ.GZ, FASTQ.BZ2) and has been designed for paired-end data. By default, the workflow assumes unstranded data (**Forward probability** input parameter set to 0.5). Please adjust the value of this parameter (0.0 or 1.0) based on the library prep of your data. 


  ####The following output files will be generated:

  	Gene level expression estimates
  	Isoform level expression estimates
  	RSEM model plot
  	BAM in transcript coordinates 
  	BAM in genome coordinates
  	FASTQC reports ZIP archive
  	FASTQC HTML report
  	Integrated QC report
  	Picard CollectRNASeqMetrics report
  	Somalier extracted sites file for input to Somalier `relate` cohort QC tool (see notes below)

  ###Reference Files and Workflow Details

  Required reference input files:

  1. **Xenome** is used to classify reads as human or mouse. Xenome indices are built on hg38 and pseudoNOD genome (based on SNP incorporation into mm10 genome from Sanger [ftp://ftp-mouse.sanger.ac.uk/REL-1505-SNPs_Indels/]). The default value of k=25 is used during the indices preparation. Default file input: Xenome_indices_for_RNAseq_WGSbased.tar.gz

  2. STAR indices archive prepared by **RSEM Prepare Reference** (v.1.2.31). The default input file (GRCh38.91.chr_patch_hapl_scaf_rsem-1.2.31.star-index-archive.tar) was built using a GRCh38 FASTA file (primary assembly, EBV, alt contigs, decoys, and HLA contigs) and an annotation GRCh38 GTF file from Ensembl (release 91) (ftp://ftp.ensembl.org/pub/release-91/gtf/homo_sapiens/Homo_sapiens.GRCh38.91.chr_patch_hapl_scaff.gtf.gz) 

  3. refFlat file (hg38) used by **Picard CollectRnaSeqMetrics** tool. Downloaded from:
  http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/refFlat.txt.gz Default file input: refFlat.ucsc_hg38.txt

  4. Ribosomal intervals (hg38) used by **Picard CollectRnaSeqMetrics** tool. Default file input: rRNA_hg38.interval

  5. Somalier sites file.
  This is a VCF of known polymorphic sites in VCF format. A good set is provided in the tools [releases](https://github.com/brentp/somalier/releases) but any set of common variants will work. Ensure that Hg38 is used.
   

  ###Workflow Steps and Notable Parameters

  ####Step 1: Optional input preprocessing

  If FASTQ.BZ2 files are provided as inputs, the files will be decompressed before further analysis (as Xenome will only accept FASTQ and FASTQ.GZ files). FASTQ.GZ and uncompressed FASTQ input files will be passed on to other tools in the workflow.

  ####Step 2: FASTQC analysis

  Quality of the input FASTQ files is checked with **FASTQC**. 

  ####Step 3: Xenome classification of reads

  FASTQ pairs are split (**SBG Split Pair by Metadata**) based on the appropriate paired_end metadata field values and classified by **Xenome** as mouse or human. **QC Xenome Check** tool checks that a sufficient number of reads have been classified as human. By default, minimum number of human reads required is set to 1000000, however this parameter is exposed (Minimum number of human-specific reads) and can be adjusted by the user.
  *Note*: If the **Minimum number of human-specific reads** cutoff is not met, the tasks will fail. If your expect <1000000 human reads in your input data, or are testing the workflow with subsetted files, please adjust this parameter accordingly.

  ####Step 4: RSEM expression estimation

  Expression is estimated using **RSEM Calculate Expression** tool (RSEM 1.2.31), with STAR as the aligner. Please ensure that the reference indices archive supplied to the tool has been prepared accordingly. **RSEM Plot Model** tool is used to generate RSEM plots.

  Please note that by default, the workflow is setup to process unstranded data (**Forward probability** input parameter set to 0.5). Please make sure to adjust the value of this parameter (0.0, 0.5 or 1.0) based on the library-prep used.

  ####Step 5: Additional QC

  Additional QC reports are collected from **Picard CollectRnaSeqMetrics** tool and **Xenome**.

  Note, select QC metrics are annotated to the metadata of the genomic coordinate BAM, gene level and isoform level counts files. 

  #### Step 5: Somalier Extract

  From the Somalier documentation: 
  The tool takes a list of known polymorphic sites, and extracts regions for each sample. Even a few hundred (or dozen) sites can be a very good indicator of relatedness. The best sites are those with a population allele frequency close to 0.5 as that maximizes the probability that any 2 samples will differ. A list of such sites is provided in the tool release for GRCh37 and hg38. The relate step (available as a separate tool on CGC) is run on a group of outputs from the extract command, and will produce pairwise relatedness among.
sbg:appVersion:
- sbg:draft-2
sbg:canvas_x: 442
sbg:canvas_y: 172
sbg:canvas_zoom: 0.7999999999999998
sbg:categories:
- RNA
- Quantification
sbg:content_hash: aafe8fd77bc5003b6977274b6059c9282724540d3062aa4e39e5d5a3c0c62f7f5
sbg:contributors:
- brownm28
sbg:createdBy: brownm28
sbg:createdOn: 1638826097
sbg:id: d3b-bixu/open-targets-pdx-workflow-dev/pdx-rna-tumor-only/0
sbg:image_url:
sbg:latestRevision: 0
sbg:license: ''
sbg:links:
- id: http://deweylab.github.io/RSEM/
  label: RSEM Homepage
- id: https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-12-323
  label: RSEM Publications
- id: http://deweylab.github.io/RSEM/README.html
  label: RSEM Documentation
sbg:modifiedBy: brownm28
sbg:modifiedOn: 1638826097
sbg:original_source: |-
  https://cavatica-api.sbgenomics.com/v2/apps/d3b-bixu/open-targets-pdx-workflow-dev/pdx-rna-tumor-only/0/raw/
sbg:project: d3b-bixu/open-targets-pdx-workflow-dev
sbg:projectName: Open Targets PDX Workflow Dev
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: https://github.com/d3b-center/d3b-ot-pdx-tumor-only-processing
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: brownm28
  sbg:modifiedOn: 1638826097
  sbg:revision: 0
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: https://github.com/d3b-center/d3b-ot-pdx-tumor-only-processing
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:toolAuthor: JAX
sbg:toolkit: ''
sbg:toolkitVersion: ''
sbg:validationErrors: []
