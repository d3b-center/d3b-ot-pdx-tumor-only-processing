cwlVersion: sbg:draft-2
class: CommandLineTool
label: FastQC
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
- id: '#threads'
  label: Threads
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --threads
    position: 0
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
        //if "threads" is not specified
        //number of threads is determined based on number of inputs
          if (! $job.inputs.threads){
            $job.inputs.threads = [].concat($job.inputs.input_fastq).length
          }
          return Math.min($job.inputs.threads,7)
        }
    separate: true
    sbg:cmdInclude: true
  description: |-
    Specifies the number of files which can be processed simultaneously.  Each thread will be allocated 250MB of memory so you shouldn't run more threads than your available memory will cope with, and not more than 6 threads on a 32 bit machine.
  required: false
  sbg:altPrefix: -t
  sbg:category: Options
  sbg:toolDefaultValue: '1'
- id: '#quiet'
  label: Quiet
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --quiet
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Supress all progress messages on stdout and only report errors.
  required: false
  sbg:altPrefix: -q
  sbg:category: Options
- id: '#nogroup'
  label: Nogroup
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --nogroup
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    Disable grouping of bases for reads >50bp. All reports will show data for every base in the read.  WARNING: Using this option will cause fastqc to crash and burn if you use it on really long reads, and your plots may end up a ridiculous size. You have been warned.
  required: false
  sbg:category: Options
- id: '#nano'
  label: Nano
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --nano
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    Files come from naopore sequences and are in fast5 format. In this mode you can pass in directories to process and the program will take in all fast5 files within those directories and produce a single output file from the sequences found in all files.
  required: false
  sbg:category: Options
- id: '#memory_per_job'
  label: Amount of memory allocated per job execution.
  type:
  - 'null'
  - int
  description: Amount of memory allocated per execution of FastQC job.
  required: false
  sbg:category: Execution parameters
  sbg:toolDefaultValue: Determined by the number of input files
- id: '#limits_file'
  label: Limits
  type:
  - 'null'
  - File
  inputBinding:
    prefix: --limits
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Specifies a non-default file which contains a set of criteria which will be used to determine the warn/error limits for the various modules.  This file can also be used to selectively remove some modules from the output all together.  The format needs to mirror the default limits.txt file found in the Configuration folder.
  required: false
  sbg:altPrefix: -l
  sbg:category: File inputs
  sbg:fileTypes: TXT
- id: '#kmers'
  label: Kmers
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --kmers
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Specifies the length of Kmer to look for in the Kmer content module. Specified Kmer length must be between 2 and 10. Default length is 7 if not specified.
  required: false
  sbg:altPrefix: -f
  sbg:category: Options
  sbg:toolDefaultValue: '7'
- id: '#input_fastq'
  label: Input file
  type:
  - type: array
    items: File
  inputBinding:
    position: 100
    separate: true
    sbg:cmdInclude: true
  description: Input file.
  required: true
  sbg:category: File inputs
  sbg:fileTypes: FASTQ, FQ, FASTQ.GZ, FQ.GZ, BAM, SAM
- id: '#format'
  label: Format
  type:
  - 'null'
  - name: format
    type: enum
    symbols:
    - bam
    - sam
    - bam_mapped
    - sam_mapped
    - fastq
  inputBinding:
    prefix: --format
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Bypasses the normal sequence file format detection and forces the program to use the specified format.  Valid formats are BAM, SAM, BAM_mapped, SAM_mapped and FASTQ.
  required: false
  sbg:altPrefix: -f
  sbg:category: Options
  sbg:toolDefaultValue: FASTQ
- id: '#cpus_per_job'
  label: Number of CPUs.
  type:
  - 'null'
  - int
  description: Number of CPUs to be allocated per execution of FastQC.
  required: false
  sbg:category: Execution parameters
  sbg:toolDefaultValue: Determined by the number of input files
- id: '#contaminants_file'
  label: Contaminants
  type:
  - 'null'
  - File
  inputBinding:
    prefix: --contaminants
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Specifies a non-default file which contains the list of contaminants to screen overrepresented sequences against. The file must contain sets of named contaminants in the form name[tab]sequence.  Lines prefixed with a hash will be ignored.
  required: false
  sbg:altPrefix: -c
  sbg:category: File inputs
  sbg:fileTypes: TXT
- id: '#casava'
  label: Casava
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --casava
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    Files come from raw casava output. Files in the same sample group (differing only by the group number) will be analysed as a set rather than individually. Sequences with the filter flag set in the header will be excluded from the analysis. Files must have the same names given to them by casava (including being gzipped and ending with .gz) otherwise they won't be grouped together correctly.
  required: false
  sbg:category: Options
- id: '#adapters_file'
  label: Adapters
  type:
  - 'null'
  - File
  inputBinding:
    prefix: --adapters
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Specifies a non-default file which contains the list of adapter sequences which will be explicity searched against the library. The file must contain sets of named adapters in the form name[tab]sequence.  Lines prefixed with a hash will be ignored.
  required: false
  sbg:altPrefix: -a
  sbg:category: File inputs
  sbg:fileTypes: TXT

outputs:
- id: '#report_zip'
  label: Report zip
  type:
  - 'null'
  - type: array
    items: File
  outputBinding:
    glob: '*_fastqc.zip'
    sbg:inheritMetadataFrom: '#input_fastq'
    sbg:metadata:
      __inherit__: input_fastq
  description: Zip archive of the report.
  sbg:fileTypes: ZIP
- id: '#report_html'
  label: Report HTMLs
  type:
  - 'null'
  - type: array
    items: File
  outputBinding:
    glob: '*.html'
    sbg:inheritMetadataFrom: '#input_fastq'
  description: FastQC reports in HTML format.
  sbg:fileTypes: HTML

baseCommand:
- fastqc
arguments:
- prefix: ''
  position: 0
  valueFrom: --noextract
  separate: true
- prefix: --outdir
  position: 0
  valueFrom: .
  separate: true

hints:
- class: sbg:CPURequirement
  value:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        // if cpus_per_job is set, it takes precedence
        if ($job.inputs.cpus_per_job) {
          return $job.inputs.cpus_per_job 
        }
        // if threads parameter is set, the number of CPUs is set based on that parametere
        else if ($job.inputs.threads) {
          return $job.inputs.threads
        }
        // else the number of CPUs is determined by the number of input files, up to 7 -- default
        else return Math.min([].concat($job.inputs.input_fastq).length,7)
      }
- class: sbg:MemRequirement
  value:
    class: Expression
    engine: '#cwl-js-engine'
    script: |+
      {
        // if memory_per_job is set, it takes precedence
        if ($job.inputs.memory_per_job){
          return $job.inputs.memory_per_job
        }
        // if threads parameter is set, memory req is set based on the number of threads
        else if ($job.inputs.threads){
          return 1024 + 300*$job.inputs.threads
        }
        // else the memory req is determined by the number of input files, up to 7 -- default
        else return (1024 + 300*Math.min([].concat($job.inputs.input_fastq).length,7))
      }

- class: DockerRequirement
  dockerPull: images.sbgenomics.com/mladenlsbg/fastqc:0.11.4
  dockerImageId: 759c4c8fbafd
id: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/fastqc-0-11-4/0
appUrl: |-
  /u/jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/apps/#jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/fastqc-0-11-4/0
description: |-
  FastQC reads a set of sequence files and produces a quality control (QC) report from each one. These reports consist of a number of different modules, each of which will help identify a different type of potential problem in your data. 

  Since it's necessary to convert the tool report in order to show them on Seven Bridges platform, it's recommended to use [FastQC Analysis workflow instead](https://igor.sbgenomics.com/public/apps#admin/sbg-public-data/fastqc-analysis/). 

  FastQC is a tool which takes a FASTQ file and runs a series of tests on it to generate a comprehensive QC report.  This report will tell you if there is anything unusual about your sequence.  Each test is flagged as a pass, warning, or fail depending on how far it departs from what you would expect from a normal large dataset with no significant biases.  It is important to stress that warnings or even failures do not necessarily mean that there is a problem with your data, only that it is unusual.  It is possible that the biological nature of your sample means that you would expect this particular bias in your results.
sbg:appVersion:
- sbg:draft-2
sbg:categories:
- FASTQ-Processing
- Quality-Control
- Quantification
sbg:cmdPreview: |-
  fastqc  --noextract --outdir .  /path/to/input_fastq-1.fastq  /path/to/input_fastq-2.fastq
sbg:contributors:
- jelena_randjelovic
sbg:copyOf: admin/sbg-public-data/fastqc-0-11-4/9
sbg:createdBy: jelena_randjelovic
sbg:createdOn: 1538402102
sbg:id: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/fastqc-0-11-4/0
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 2
    mem: 1624
  inputs:
    format:
    cpus_per_job:
    input_fastq:
    - class: File
      secondaryFiles: []
      path: /path/to/input_fastq-1.fastq
      size: 0
    - class: File
      secondaryFiles: []
      path: /path/to/input_fastq-2.fastq
      size: 0
    memory_per_job:
    quiet: true
    threads:
sbg:latestRevision: 0
sbg:license: GNU General Public License v3.0 only
sbg:links:
- id: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
  label: Homepage
- id: |-
    http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.4_source.zip
  label: Source Code
- id: https://wiki.hpcc.msu.edu/display/Bioinfo/FastQC+Tutorial
  label: Wiki
- id: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.4.zip
  label: Download
- id: http://www.bioinformatics.babraham.ac.uk/projects/fastqc
  label: Publication
sbg:modifiedBy: jelena_randjelovic
sbg:modifiedOn: 1538402102
sbg:project: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow
sbg:projectName: PDXnet - Polishing JAX RNA-seq workflow
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: Copy of admin/sbg-public-data/fastqc-0-11-4/9
sbg:revisionsInfo:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538402102
  sbg:revision: 0
  sbg:revisionNotes: Copy of admin/sbg-public-data/fastqc-0-11-4/9
sbg:sbgMaintained: false
sbg:toolAuthor: Babraham Institute
sbg:toolkit: FastQC
sbg:toolkitVersion: 0.11.4
sbg:validationErrors: []
x: 505.00020345052116
y: 250.00015258789077
