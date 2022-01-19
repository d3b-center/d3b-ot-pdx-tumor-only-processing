This RSEM workflow (RSEM 1.2.31) for quantifying gene expression uses the STAR aligner and is optimized to work with FASTQ input files.

To process multiple samples, please consider running batch tasks with this workflow and aggregating the results using **Prepare Multisample Data** [workflow](https://cgc.sbgenomics.com/u/pdxnet/pdx-wf-commit2/apps/#pdxnet/pdx-wf-commit2/prepare-multisample-data).

Note: This workflow utilizes the tool `Xenome` to removed mouse-reads from the raw-read data. `Xenome` uses host and graft reference sequences to characterize the set of all possible k-mers according to whether they belong to: only the graft (and not the host), only the host (and not the graft), both references, neither reference, and marginal asignments. This workflow uses those reads classified as 'human-only'.

### Essential Requirements

The following metadata fields are essential and should be assigned to input FASTQ files:

1. **Sample ID**: Any string. The identifier should be identical for both paired-end FASTQ files. 
2. **Paired-end**: 1 or 2

This workflow will process both uncompressed and compressed FASTQ files (FASTQ.GZ, FASTQ.BZ2) and has been designed for paired-end data. By default, the workflow assumes unstranded data (**Forward probability** input parameter set to 0.5). Please adjust the value of this parameter (0.0 or 1.0) based on the library prep of your data. 


#### The following output files will be generated:

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

### Reference Files and Workflow Details

Required reference input files:

1. **Xenome** is used to classify reads as human or mouse. Xenome indices are built on hg38 and pseudoNOD genome (based on SNP incorporation into mm10 genome from Sanger [ftp://ftp-mouse.sanger.ac.uk/REL-1505-SNPs_Indels/]). The default value of k=25 is used during the indices preparation. Default file input: Xenome_indices_for_RNAseq_WGSbased.tar.gz

2. STAR indices archive prepared by **RSEM Prepare Reference** (v.1.2.31). The default input file (GRCh38.91.chr_patch_hapl_scaf_rsem-1.2.31.star-index-archive.tar) was built using a GRCh38 FASTA file (primary assembly, EBV, alt contigs, decoys, and HLA contigs) and an annotation GRCh38 GTF file from Ensembl (release 91) (ftp://ftp.ensembl.org/pub/release-91/gtf/homo_sapiens/Homo_sapiens.GRCh38.91.chr_patch_hapl_scaff.gtf.gz) 

3. refFlat file (hg38) used by **Picard CollectRnaSeqMetrics** tool. Downloaded from:
http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/refFlat.txt.gz Default file input: refFlat.ucsc_hg38.txt

4. Ribosomal intervals (hg38) used by **Picard CollectRnaSeqMetrics** tool. Default file input: rRNA_hg38.interval

5. Somalier sites file.
This is a VCF of known polymorphic sites in VCF format. A good set is provided in the tools [releases](https://github.com/brentp/somalier/releases) but any set of common variants will work. Ensure that Hg38 is used.
 

### Workflow Steps and Notable Parameters

#### Step 1: Optional input preprocessing

If FASTQ.BZ2 files are provided as inputs, the files will be decompressed before further analysis (as Xenome will only accept FASTQ and FASTQ.GZ files). FASTQ.GZ and uncompressed FASTQ input files will be passed on to other tools in the workflow.

#### Step 2: FASTQC analysis

Quality of the input FASTQ files is checked with **FASTQC**. 

#### Step 3: Xenome classification of reads

FASTQ pairs are split (**SBG Split Pair by Metadata**) based on the appropriate paired_end metadata field values and classified by **Xenome** as mouse or human. **QC Xenome Check** tool checks that a sufficient number of reads have been classified as human. By default, minimum number of human reads required is set to 1000000, however this parameter is exposed (Minimum number of human-specific reads) and can be adjusted by the user.
*Note*: If the **Minimum number of human-specific reads** cutoff is not met, the tasks will fail. If your expect <1000000 human reads in your input data, or are testing the workflow with subsetted files, please adjust this parameter accordingly.

#### Step 4: RSEM expression estimation

Expression is estimated using **RSEM Calculate Expression** tool (RSEM 1.2.31), with STAR as the aligner. Please ensure that the reference indices archive supplied to the tool has been prepared accordingly. **RSEM Plot Model** tool is used to generate RSEM plots.

Please note that by default, the workflow is setup to process unstranded data (**Forward probability** input parameter set to 0.5). Please make sure to adjust the value of this parameter (0.0, 0.5 or 1.0) based on the library-prep used.

#### Step 5: Additional QC

Additional QC reports are collected from **Picard CollectRnaSeqMetrics** tool and **Xenome**.

Note, select QC metrics are annotated to the metadata of the genomic coordinate BAM, gene level and isoform level counts files. 

#### Step 5: Somalier Extract

From the Somalier documentation: 
The tool takes a list of known polymorphic sites, and extracts regions for each sample. Even a few hundred (or dozen) sites can be a very good indicator of relatedness. The best sites are those with a population allele frequency close to 0.5 as that maximizes the probability that any 2 samples will differ. A list of such sites is provided in the tool release for GRCh37 and hg38. The relate step (available as a separate tool on CGC) is run on a group of outputs from the extract command, and will produce pairwise relatedness among.