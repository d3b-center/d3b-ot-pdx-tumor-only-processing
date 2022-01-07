This Whole Exome Sequencing (WES) tumor-normal workflow first uses the [Broad Institute's](https://software.broadinstitute.org/gatk/best-practices/) best-practices workflow for read alignment, and then analyzes those data in several ways. 

1.  Identifies variants from a human exome experiment with GATK-4 [Mutect2](https://software.broadinstitute.org/gatk/documentation/tooldocs/4.0.5.1/org_broadinstitute_hellbender_tools_walkers_mutect_Mutect2.php) for variant calling. 
2. Calculates microsatellite instability (MSI) status using [MSIsensor2](https://github.com/niu-lab/msisensor2)
3. Calculates tumor mutation burden (TMB) score using filtered variants.

Note: This workflow utilizes the tool `Xenome` to removed mouse-reads from the raw-read data. `Xenome` uses host and graft reference sequences to characterize the set of all possible k-mers according to whether they belong to: only the graft (and not the host), only the host (and not the graft), both references, neither reference, and marginal asignments. This workflow uses those reads classified as 'human-only'.

---

### Essential Requirements

  The following metadata fields are required and should be assigned to input read files:

1. **Sample ID**: Any string. As this is the biospecimen identifier, it should be different for PDX (tumor) and normal sample. The workflow will run even if the strings are the same, however, please consider using different identifiers.
2. **Paired-end**: 1 or 2
3. **Sample type**: Any string. Please make sure to also provide the chosen tumor and normal sample types to the *SBG Split Pair by Metadata* tool (see below for details), if this is the field you wish to use to separate tumor and normal files. 

#### Optional (but recommended) Metadata
1. **Case ID**. Any string. This allows for the tracking of case's. It is not required for running; however, the workflow will append this metadata field to the front of most outputs if present. 

The workflow will process both uncompressed and compressed FASTQ files.

---

#### The following output files will be generated:

       ---VARIANT OUTPUTS---
       Tumor FASTQC reports
       Tumor BAM file
       Tumor QC reports - integrated and exome
       Final annotated VCF and TAB files

       ---MSI---
       MSI Score File

       ---TMB---
      TMB Score File

---

### Reference Files and Workflow Details

Required reference input files:

1. **Xenome** is used to classify reads as human or mouse. Xenome indices are built on hg38 and pseudoNOD genome (based on SNP incorporation into mm10 genome from Sanger [ftp://ftp-mouse.sanger.ac.uk/REL-1505-SNPs_Indels/]). The default value of k=25 is used during the indices preparation. 
Default file input: Xenome_WGS_indices.tar.gz

2. Reference FASTA file and secondary files (.FAI, .DICT). 
Default file input: Homo_sapiens_assembly38.fasta (Homo_sapiens_assembly38.fasta.fai, Homo_sapiens_assembly38.dict)
Chromosome naming in the default input file: chr1, chr2... chrX, chrY, chrM.

3. BWA indices were prepared using bwakit/0.7.15. GRCh38 files from the Broad GATK resource bundle (hg38_201601) were used. 
Default file input: BWA_ref_files.tar.gz

4. Additional reference input files (hg38-specific) from the Broad Institute GATK resource bundle (known indels):               
     Homo_sapiens_assembly38.known_indels.vcf.gz (Homo_sapiens_assembly38.known_indels.vcf.gz.tbi)     
     Mills_and_1000G_gold_standard.indels.hg38.vcf.gz (Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi)
     hsa\_dbSNP\_v151\_20170710chr\_renamed.vcf.gz (hsa\_dbSNP\_v151\_20170710chr\_renamed.vcf.gz.tbi)     

5. dbSNP v151 (20170710) file:
Default file input: hsa_dbSNP_v151_20170710chr_renamed.vcf.gz (hsa_dbSNP_v151_20170710chr_renamed.vcf.gz.tbi)

6. ExAC sites (lifted over to GRCh38 and formatted to match the reference FASTA). Original file was downloaded from Ensembl (http://ftp.ensembl.org/pub/data_files/homo_sapiens/GRCh38/variation_genotype/ExAC.0.3.GRCh38.vcf.gz).
Default file input: ExAC.0.3.GRCh38_chr_added_bad_lift_over_removed_reorder_primary_only.vcf.gz (ExAC.0.3.GRCh38_chr_added_bad_lift_over_removed_reorder_primary_only.vcf.gz.tbi)

7. Annotation database file for SnpEff (v4.3):
     snpEff_v4_3_hg38.zip

8. Annotation database files for SnpSift:
     a) dbNSFP (by default, the workflow uses dbNSFP v3.2 (academic release): dbNSFP3.2a.txt.gz)
     b) COSMIC (default file: Sorted_Cosmicv80_Coding_Noncoding.processed.vcf.gz, with .tbi index)

9. Target region files (BED and INTERVALS_LIST format)
The BED file should correspond to the data being processed. Chromosome naming in the BED file should match the reference FASTA used to process the data (if using the default input FASTA file, please ensure that chromosome names begin with 'chr'). If a corresponding INTERVALS_LIST file (as used by Picard toolkit) is not available, it can easily be generated using the **GATK BedToIntervalList** tool.

---

### Workflow Steps

#### Step 1: **SBG Split Pair by Metadata**

The first step separates tumor and normal FASTQ files for downstream processing, based on specified metadata criteria which should be supplied as inputs (normal_metadata and tumor_metadata) in the format metadata_key:value. For example, for files to be classified based on Sample type metadata (sample_type field), with the values "tumor" and "normal", the inputs should read: sample_type:normal and sample_type:tumor (for normal_metadata and tumor_metadata parameters, respectively).

#### Step 2:  **Tumor Alignment and Target Coverage** 

In the next step, tumor (PDX model) and normal FASTQ files are QC-checked (**FASTQC**), trimmed (**Trimmomatic**), aligned (**BWA**, alt-aware), sorted (**Picard SortSam**) and prepared for variant calling (**Picard MarkDuplicates**, **GATK BaseRecalibrator**, **GATK ApplyBQSR**). QC is also performed on the processed BAM files using **Exome Coverage QC 1.0** tool and **Picard CalculateHsMetrics**. QC reports are aggregated with the **QC Integrate** script. The two workflows are similar, except for **Xenome** preprocessing of PDX-derived data (tumor workflow) to remove mouse reads. 

Important notes: 

1. **BWA** is set to hardcode "tumor" and "normal" as sample names (SM) in the output BAMs. This can be changed via the read group input parameter. However, please make sure to also adjust **Mutect** parameters tumor and normal sample name, if this is changed.

2. By default, QC checks require that at least 75 % of every target region be covered at 20X. If this requirement is not met, the task will fail (See Target Coverage parameter of the **QC Integrate** tool to adjust this).

#### Step 3: Indexing BAM files (**Samtools Index BAM**)  


#### Step 4: Variant calling (**GATK 4 Mutect2** and **FilterMutectCalls**)

The variant calling step has been paralellized by invoking **Mutect2** and **GATK FilterMutectCalls** on smaller intervals in paralel (scatter). The intervals are prepared with the **SBG Prepare Intervals** tool and the output VCFs are collected and merged with the **SnpSift split** tool before annotation. 

Important default parameter: As ExAC 0.3 is used, AF Of Alleles Not In Resource was set to (ExAC 0.3 ~ 60,706Exomes) = 1/(2* 60706)= 0.0000082364  

#### Step 5: Annotation 

The somatic VCF is annotated with SnpEff/SnpSift tools (v4.3). Basic annotation is done with **SnpEff** (using hg38 database). If you wish to use a different database, please make sure to also alter the Assembly input parameter of the SnpEff tool. 
**SnpSift dbNSFP** and **SnpSift annotate** tools are used to add additional annotations from the [dbNSFP](https://sites.google.com/site/jpopgen/dbNSFP) and [COSMIC](https://cancer.sanger.ac.uk/cosmic). Please note that these two annotation sources should be provided as tabix-indexed VCF.GZ files (with their .TBI index present)

For convenience, the output VCF is reformatted to hold one effect per line (script vcfEffOnePerLine.pl from SnpEff toolkit) and also converted to a tab-separated file (**SnpSift extractFields tool**).

**Please note:** the GT genotype field present in the final VCF does not represent genotype in the traditional sense. Per [GATK documentation](https://software.broadinstitute.org/gatk/documentation/article?id=11127): A somatic caller should detect low fraction alleles, can make no explicit ploidy assumption and omits genotyping in the traditional sense. Mutect2 adheres to all of these criteria. A number of cancer sample characteristics necessitate such caller features. For one, biopsied tumor samples are commonly contaminated with normal cells, and the normal fraction can be much higher than the tumor fraction of a sample. Second, a tumor can be heterogeneous in its mutations. Third, these mutations not uncommonly include aneuploid events that change the copy number of a cell's genome in patchwork fashion.  

#### Step 6: Microsattelite instability (MSI) Status Calculation

The tumor BAM file are passed to MSIsensor2 which calls MSI status. Note that the threshold as determined by the authors of the tool is- MSI high: msi score >= 20%.

#### Step 7: Tumor Mutation Burden (TMB) Calculation
TMB is calucated as the number of coding mutations per Mb of the genome. This is assessed using variants that meet all quality criteria (coverage, AF, mapping quality, strand bias etc.), are somatic and non-polymorphic, and are defined in SnpEff as 'high' or 'moderate' functional impact. As only a porition of the genome was sequenced, genome coverage (Mb) is calculated from the input target coverage BED file.