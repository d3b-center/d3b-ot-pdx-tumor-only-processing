cwlVersion: sbg:draft-2
class: CommandLineTool
label: Picard CollectRnaSeqMetrics
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- id: '#cwl-js-engine'
  class: ExpressionEngineRequirement
  requirements:
  - class: DockerRequirement
    dockerPull: rabix/js-engine
- class: InlineJavascriptRequirement

inputs:
- id: '#verbosity'
  label: Verbosity
  type:
  - 'null'
  - name: verbosity
    type: enum
    symbols:
    - ERROR
    - WARNING
    - INFO
    - DEBUG
  inputBinding:
    prefix: VERBOSITY=
    position: 6
    separate: false
    sbg:cmdInclude: true
  description: |-
    Control verbosity of logging. Default value: INFO. This option can be set to 'null' to clear the default value. Possible values: {ERROR, WARNING, INFO, DEBUG}.
  required: false
  sbg:category: Options
  sbg:toolDefaultValue: INFO
- id: '#validation_stringency'
  label: Validation stringency
  type:
  - 'null'
  - name: validation_stringency
    type: enum
    symbols:
    - STRICT
    - LENIENT
    - SILENT
  inputBinding:
    prefix: VALIDATION_STRINGENCY=
    position: 4
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.validation_stringency)
          {
            return $job.inputs.validation_stringency
          }
          else
          {
            return "SILENT"
          }
        }
    separate: false
    sbg:cmdInclude: true
  description: |-
    Validation stringency for all SAM files read by this program. Setting stringency to SILENT can improve performance when processing a BAM file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded. Default value: STRICT. This option can be set to 'null' to clear the default value. Possible values: {STRICT, LENIENT, SILENT}.
  required: false
  sbg:category: Options
  sbg:toolDefaultValue: SILENT
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
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    This parameter is to be set when using strand-specific library preparations. If the unpaired reads are expected to be on the transcription strand, the FIRST_READ_TRANSCRIPTION_STRAND option must be used.
  required: true
  sbg:altPrefix: STRAND
  sbg:category: Options
  sbg:toolDefaultValue: STRAND
- id: '#stop_after'
  label: Stop after
  type:
  - 'null'
  - int
  inputBinding:
    prefix: STOP_AFTER=
    position: 9
    separate: false
    sbg:cmdInclude: true
  description: |-
    Stop after processing N reads, mainly for debugging. Default value: 0. This option can be set to 'null' to clear the default value.
  required: false
  sbg:category: Options
  sbg:toolDefaultValue: '0'
- id: '#rrna_fragment_percentage'
  label: Rrna fragment percentage
  type:
  - 'null'
  - float
  inputBinding:
    prefix: RRNA_FRAGMENT_PERCENTAGE=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    This parameter sets the percentage of fragment length that must overlap one of the ribosomal intervals to consider a read or read pair as rRNA.
  required: false
  sbg:category: Options
  sbg:toolDefaultValue: '0.8'
- id: '#ribosomal_intervals'
  label: Ribosomal intervals
  type:
  - 'null'
  - File
  inputBinding:
    prefix: RIBOSOMAL_INTERVALS=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    Provide the location of rRNA sequences in genome, in an interval_list format.  If this parameter is not specified no bases will be identified as being ribosomal.  Format described here: http://samtools.github.io/htsjdk/javadoc/htsjdk/htsjdk/samtools/util/IntervalList.html.
  required: false
  sbg:category: File inputs
  sbg:fileTypes: INTERVAL_LIST
- id: '#reference'
  label: Reference sequence
  type:
  - 'null'
  - File
  inputBinding:
    prefix: REFERENCE_SEQUENCE=
    position: 3
    separate: false
    sbg:cmdInclude: true
  description: |-
    Reference sequence file. Note that while this argument is not required, without it only a small subset of the metrics will be calculated.  Default value: null.
  required: false
  sbg:altPrefix: R
  sbg:category: File inputs
  sbg:fileTypes: FASTA, FA, FASTA.GZ
- id: '#ref_flat'
  label: Ref flat
  type:
  - File
  inputBinding:
    prefix: REF_FLAT=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    Gene annotations in refFlat form.  Format described here: http://genome.ucsc.edu/goldenPath/gbdDescriptionsOld.html#RefFlat . It can be generated using this script hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/gtfToGenePred.
  required: true
  sbg:category: File inputs
  sbg:fileTypes: TXT
- id: '#quiet'
  label: Quiet
  type:
  - 'null'
  - name: quiet
    type: enum
    symbols:
    - 'true'
    - 'false'
  inputBinding:
    prefix: QUIET=
    position: 4
    separate: false
    sbg:cmdInclude: true
  description: |-
    Whether to suppress job-summary info on System.err. Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false}.
  required: false
  sbg:category: Options
  sbg:toolDefaultValue: 'False'
- id: '#minimum_length'
  label: Minimum length
  type:
  - 'null'
  - int
  inputBinding:
    prefix: MINIMUM_LENGTH=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    This option specifies the minimum transcript length to be used when calculating coverage based values (e.g coverage CV).
  required: false
  sbg:category: Options
  sbg:toolDefaultValue: '500'
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
    sbg:cmdInclude: true
  description: |-
    This option sets the level(s) at which metrics are accumulated. Default value: [ALL_READS]. This option can be set to 'null' to clear the default value. Possible values: {ALL_READS, SAMPLE, LIBRARY, READ_GROUP} This option may be specified to 0 or more times. This option can be set to 'null' to clear the default list.
  required: false
  sbg:altPrefix: LEVEL
  sbg:category: Options
  sbg:toolDefaultValue: ALL_READS
- id: '#memory_per_job'
  label: Memory per job
  type:
  - 'null'
  - int
  description: |-
    Amount of RAM memory to be used per job. Defaults to 2048 MB for single threaded jobs.
  required: false
  sbg:category: Execution options
  sbg:toolDefaultValue: '2048'
- id: '#max_records_in_ram'
  label: Max records in RAM
  type:
  - 'null'
  - int
  inputBinding:
    prefix: MAX_RECORDS_IN_RAM=
    position: 4
    separate: false
    sbg:cmdInclude: true
  description: |-
    When writing SAM files that need to be sorted, this will specify the number of records stored in RAM before spilling to disk. Increasing this number reduces the number of file handles needed to sort a SAM file, and increases the amount of RAM needed. Default value: 500000. This option can be set to 'null' to clear the default value.
  required: false
  sbg:category: Options
  sbg:toolDefaultValue: '500000'
- id: '#input_bam'
  label: Input file
  type:
  - File
  inputBinding:
    prefix: INPUT=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: Input SAM or BAM file.  Required.
  required: true
  sbg:altPrefix: I
  sbg:category: File inputs
  sbg:fileTypes: BAM, SAM
- id: '#ignore_sequence'
  label: Ignore sequence
  type:
  - 'null'
  - type: array
    items: string
  inputBinding:
    prefix: IGNORE_SEQUENCE=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    If a read maps to a sequence specified with this option, all the bases in that read are counted as ignored bases.
  required: false
  sbg:category: Options
- id: '#compression_level'
  label: Compression level
  type:
  - 'null'
  - int
  inputBinding:
    prefix: COMPRESSION_LEVEL=
    position: 4
    separate: false
    sbg:cmdInclude: true
  description: |-
    Compression level for all compressed files created (e.g. BAM and GELI). Default value: 5. This option can be set to 'null' to clear the default value.
  required: false
  sbg:category: Options
  sbg:toolDefaultValue: '5'
- id: '#assume_sorted'
  label: Assume sorted
  type:
  - 'null'
  - name: assume_sorted
    type: enum
    symbols:
    - 'true'
    - 'false'
  inputBinding:
    prefix: ASSUME_SORTED=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    If true is selected, the sort order in the header file will be ignored. Default value: true. This option can be set to 'null' to clear the default value. Possible values: {true, false}.
  required: false
  sbg:altPrefix: AS
  sbg:category: Options
  sbg:toolDefaultValue: 'True'

outputs:
- id: '#rna_seq_metrics'
  label: Rna seq metrics
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.rna_seq_metrics.txt'
    sbg:inheritMetadataFrom: '#input_bam'
  description: File to which the output will be written.
  sbg:fileTypes: TXT
- id: '#chart_output'
  label: Chart
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.rna_seq_metrics.chart.pdf'
    sbg:inheritMetadataFrom: '#input_bam'
  description: The PDF file to write out a plot of normalized position vs. coverage.
  sbg:fileTypes: PDF

baseCommand:
- java
- class: Expression
  engine: '#cwl-js-engine'
  script: |-
    {   
      if($job.inputs.memory_per_job){
        return '-Xmx'.concat($job.inputs.memory_per_job, 'M')
      }   
      	return '-Xmx2048M'
    }
- -jar
- /opt/picard-tools-1.140/picard.jar
- CollectRnaSeqMetrics
arguments:
- prefix: OUTPUT=
  position: 0
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |
      {
        if ($job.inputs.input_bam)
        {
          filename = $job.inputs.input_bam.path

          return filename.split('.').slice(0, -1).concat("rna_seq_metrics.txt").join(".").replace(/^.*[\\\/]/, '')
        }
      }
  separate: false
- prefix: CHART_OUTPUT=
  position: 0
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        if ($job.inputs.input_bam)
        {
          filename = $job.inputs.input_bam.path

          return filename.split('.').slice(0, -1).concat("rna_seq_metrics.chart.pdf").join(".").replace(/^.*[\\\/]/, '')
        }
      }
  separate: false

hints:
- class: sbg:AWSInstanceType
  value: c4.2xlarge;ebs-gp2;200
- class: sbg:CPURequirement
  value: 1
- class: sbg:MemRequirement
  value:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        if($job.inputs.memory_per_job){
        	return $job.inputs.memory_per_job
        }
        	return 2048
      }
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/mladenlsbg/picard:1.140
  dockerImageId: eab0e70b6629
id: |-
  jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/picard-collectrnaseqmetrics/1
appUrl: |-
  /u/anuj_srivastava/rna-expression-estimation/apps/#anuj_srivastava/rna-expression-estimation/picard-collectrnaseqmetrics-1-140/0
description: |-
  Picard CollectRnaSeqMetrics collects metrics about the alignment of RNA to various functional classes of loci in the genome: coding, intronic, UTR, intergenic, and ribosomal. This tool also determines strand-specificity for strand-specific libraries.
sbg:appVersion:
- sbg:draft-2
sbg:categories:
- SAM/BAM-Processing
- Quality-Control
- Quantification
sbg:cmdPreview: |-
  java -Xmx2048M -jar /opt/picard-tools-1.140/picard.jar CollectRnaSeqMetrics STRAND_SPECIFICITY=NONE REF_FLAT=ref_flat.ext INPUT=/root/dir/example.bam OUTPUT=example.rna_seq_metrics.txt CHART_OUTPUT=example.rna_seq_metrics.chart.pdf
sbg:contributors:
- jelena_randjelovic
sbg:createdBy: jelena_randjelovic
sbg:createdOn: 1538394631
sbg:id: |-
  jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/picard-collectrnaseqmetrics/1
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 1
    mem: 2048
  inputs:
    ignore_sequence:
    - ignore_sequence
    input_bam:
      path: /root/dir/example.bam
    memory_per_job: 0
    metric_accumulation_level:
    - adadsa
    - ''
    minimum_length: 0
    ref_flat:
      class: File
      secondaryFiles: []
      path: ref_flat.ext
      size: 0
    ribosomal_intervals:
      class: File
      secondaryFiles: []
      path: ribosomal_intervals.ext
      size: 0
    rrna_fragment_percentage: 0
    strand_specificity: NONE
sbg:latestRevision: 1
sbg:license: MIT License, Apache 2.0 Licence
sbg:links:
- id: http://broadinstitute.github.io/picard/index.html
  label: Homepage
- id: https://github.com/broadinstitute/picard/releases/tag/1.140
  label: Source Code
- id: http://broadinstitute.github.io/picard/
  label: Wiki
- id: https://github.com/broadinstitute/picard/zipball/master
  label: Download
- id: http://broadinstitute.github.io/picard/
  label: Publication
sbg:modifiedBy: jelena_randjelovic
sbg:modifiedOn: 1538401616
sbg:project: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow
sbg:projectName: PDXnet - Polishing JAX RNA-seq workflow
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: c4.2 200GB storage
sbg:revisionsInfo:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538394631
  sbg:revision: 0
  sbg:revisionNotes: Copy of admin/sbg-public-data/picard-collectrnaseqmetrics-1-140/3
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538401616
  sbg:revision: 1
  sbg:revisionNotes: c4.2 200GB storage
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: Picard
sbg:toolkitVersion: '1.140'
sbg:validationErrors: []
x: 1173.137512207032
y: 411.8813069661461
