cwlVersion: sbg:draft-2
class: CommandLineTool
label: SAMtools Sort
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
- id: '#input_file'
  label: Input file
  type:
  - File
  inputBinding:
    position: 99
    separate: true
    sbg:cmdInclude: true
  description: The input BAM/SAM/CRAM file to be sorted.
  sbg:category: File inputs
  sbg:fileTypes: BAM, CRAM, SAM
- id: '#threads'
  label: Number of threads
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --threads
    position: 10
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if($job.inputs.threads){
            return $job.inputs.threads - 1
          }
          else{
            return
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: |-
    SAMtools uses argument --threads/-@ to specify number of additional threads. This parameter sets total number of threads (and CPU cores). Command line argument will be reduced by 1 to set number of additional threads. By default, operation is single-threaded.
  sbg:altPrefix: -@
  sbg:category: Execution
  sbg:toolDefaultValue: '1'
- id: '#compression_level'
  label: Compression level
  type:
  - 'null'
  - int
  inputBinding:
    prefix: -l
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Set the desired compression level for the final output file, ranging from 0 (uncompressed) or 1 (fastest but minimal compression) to 9 (best compression but slowest to write), similarly to gzip's compression level setting.
  sbg:category: Config Inputs
- id: '#sort_by_read_name'
  label: Sort by read name
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: -n
    position: 2
    separate: true
    sbg:cmdInclude: true
  description: |-
    Sort by read names (i.e., the QNAME field) rather than by chromosomal coordinates.
  sbg:category: Config Inputs
- id: '#output_format'
  label: Output format
  type:
  - 'null'
  - name: output_format
    type: enum
    symbols:
    - BAM
    - SAM
    - CRAM
  inputBinding:
    prefix: --output-fmt
    position: 7
    separate: true
    sbg:cmdInclude: true
  description: Write the final output as SAM, BAM, or CRAM.
  sbg:altPrefix: -O
  sbg:category: Config Inputs
- id: '#max_mem_per_thread'
  label: Memory per thread
  type:
  - 'null'
  - string
  inputBinding:
    prefix: -m
    position: 1
    separate: true
    sbg:cmdInclude: true
  description: |-
    Approximately the maximum required memory per thread, specified with a G, M, or K suffix. To prevent sort from creating a huge number of temporary files, it enforces a minimum value of 1M for this setting.
  sbg:category: Execution
  sbg:toolDefaultValue: 768M
- id: '#sort_by_tag'
  label: Sort by vaue of tag
  type:
  - 'null'
  - string
  inputBinding:
    prefix: -t
    position: 3
    separate: true
    sbg:cmdInclude: true
  description: |-
    Sort first by the value in the alignment tag, then by position or name (if also using -n).
  sbg:category: Config Inputs
- id: '#output_filename'
  label: Output filename
  type:
  - 'null'
  - string
  inputBinding:
    prefix: -o
    position: 4
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.output_filename){
            return $job.inputs.output_filename
          }
          else{
            input_filename = [].concat($job.inputs.input_file)[0].path.split('/').pop()
            if ($job.inputs.output_format){
              ext = $job.inputs.output_format.toLowerCase()
            }
            else{
              ext = 'bam'
            }
            return input_filename.slice(0,input_filename.lastIndexOf('.')) + '.sorted.' + ext
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: Define a filename of the output.
  sbg:category: Config Inputs
- id: '#input_fmt_option'
  label: Input file format option
  type:
  - 'null'
  - string
  inputBinding:
    prefix: --input-fmt-option
    position: 6
    separate: true
    sbg:cmdInclude: true
  description: Specify a single input file format option in the form of OPTION or
    OPTION=VALUE.
  sbg:category: Config Inputs
- id: '#output_fmt_option'
  label: Output file format option
  type:
  - 'null'
  - string
  inputBinding:
    prefix: --output-fmt-option
    position: 8
    separate: true
    sbg:cmdInclude: true
  description: |-
    Specify a single output file format option in the form of OPTION or OPTION=VALUE.
  sbg:category: Config Inputs
- id: '#reference_file'
  label: Reference file
  type:
  - 'null'
  - File
  inputBinding:
    prefix: --reference
    position: 9
    separate: true
    sbg:cmdInclude: true
  description: |-
    Reference file. This file is used for compression/decompression of CRAM files. Please provide reference file when using CRAM input/output file.
  sbg:category: File inputs
  sbg:fileTypes: FASTA, FASTA.GZ, FASTA.BGZF, GZ, BGZF
  sbg:stageInput: link

outputs:
- id: '#sorted_file'
  label: Sorted file
  type:
  - File
  outputBinding:
    glob:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.output_filename){
            return $job.inputs.output_filename
          }
          else{
            input_filename = [].concat($job.inputs.input_file)[0].path.split('/').pop()
            if ($job.inputs.output_format){
              ext = $job.inputs.output_format.toLowerCase()
            }
            else{
              ext = 'bam'
            }
            return input_filename.slice(0,input_filename.lastIndexOf('.')) + '.sorted.' + ext
          }
        }
    sbg:inheritMetadataFrom: '#input_file'
  description: Sorted file.
  sbg:fileTypes: BAM, SAM, CRAM

baseCommand:
- /opt/samtools-1.6/samtools
- sort

hints:
- class: sbg:CPURequirement
  value:
    class: Expression
    engine: '#cwl-js-engine'
    script: |
      {
        if($job.inputs.threads){
          return $job.inputs.threads
        }
        else{
          return 1
        }
      }
- class: sbg:MemRequirement
  value:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      { 
        memory_offset = 2048
        
        if($job.inputs.reference_file){
          memory_offset = memory_offset + 3000
        }

        if($job.inputs.threads){
          threads = $job.inputs.threads
        }
        else{
          threads = 1
        }
        
        memory_per_thread = 1024
        if($job.inputs.max_mem_per_thread){
          if( $job.inputs.max_mem_per_thread.indexOf("G") > 0){
            memory_per_thread = parseInt($job.inputs.max_mem_per_thread.slice(0,$job.inputs.max_mem_per_thread.indexOf('G')))*1024 
          }
          else if( $job.inputs.max_mem_per_thread.indexOf("M") > 0){
            memory_per_thread = parseInt($job.inputs.max_mem_per_thread.slice(0,$job.inputs.max_mem_per_thread.indexOf('M'))) 
          }
          else if(( $job.inputs.max_mem_per_thread.indexOf("K") > 0)){
            memory_per_thread = parseInt($job.inputs.max_mem_per_thread.slice(0,$job.inputs.max_mem_per_thread.indexOf('K')))/1024 
          }
        }
        
        return memory_offset + threads * memory_per_thread 
      }
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/milana_kaljevic/samtools:1.6
id: michael_lloyd/cnv-analysis-wustl-legacywhims/samtools-sort-1-6/0
description: |-
  **SAMtools Sort** tool is used to sort alignments by leftmost coordinates, or by read name when `-n` is used. An appropriate @HD-SO sort order header tag will be added or an existing one updated if necessary. [1]

  The sorted output is written to the file specified by the parameter **Output filename** (`-o`) or default filename (input_file.sorted.bam for input input_file.bam). 

  This command will also create temporary files tmpprefix.%d.bam as needed when the entire alignment data cannot fit into memory (as controlled via parameter **Memory per thread** (`-m`)). [1] 

  Output file format is set by the parameter **Output format** (`--output-fmt/-O`). If this parameter is not set, format is recognized from the filename defined by the parameter **Output filename** (`-o`). If the filename is not set or no format can be deduced, BAM format will be selected. 

  *A list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of the page.*

  ####Ordering Rules

  The following rules are used for ordering records. If the parameter **Sort by vaue of tag** (`-t`) is used, records are first sorted by the value of the given alignment tag, and then by position or name (if the parameter **Sort by read name** (`-n`) is set to True). For example, `-t RG` will make read group the primary sort key. The rules for ordering by tag are:  
  - Records that do not have the tag are sorted before ones that do.
  - If the types of the tags are different, they will be sorted so that single character tags (type A) come before array tags (type B), then string tags (types H and Z), then numeric tags (types f and i).
  - Numeric tags (types f and i) are compared by value. Note that comparisons of floating-point values are subject to issues of rounding and precision.
  - String tags (types H and Z) are compared based on the binary contents of the tag using the C strcmp function.
  - Character tags (type A) are compared by binary character value.
  - No attempt is made to compare tags of other types — notably type B array values will not be compared.

  When the parameter **Sort by read name** (`-n`) is set to True, records are sorted by name. Names are compared so as to give a “natural” ordering — i.e. sections consisting of digits are compared numerically while all other sections are compared based on their binary representation. This means “a1” will come before “b1” and “a9” will come before “a10”. Records with the same name will be ordered according to the values of the READ1 and READ2 flags.  
  When the parameter **Sort by read name** (`-n`) is not set to True, reads are sorted by reference (according to the order of the @SQ header records), then by position in the reference, and then by the REVERSE flag. [1]

  ###Common Use Cases

  **SAMtools Sort** is often used as preprocessing step for other tools that require coordinate or query name sorted BAM/CRAM/SAM file. Some of the tools that require coordinate sorted input are **SAMtools Index**, **SAMtools View** when using **Regions array** parameter, **SAMtools Markdup**. Some of the tools that require query name sorted input are **SAMtools Fixmate** and **SAMtools FASTQ** (not required but it is recommended for further processing of FASTQ files). 

  ###Changes Introduced by Seven Bridges

  - Parameter for temporary files prefix (`-T`) is omitted from the wrapper because it is not applicable on the platform.
  - Parameter **Number of threads** (`--threads/-@`) specifies total number of threads instead of additional threads. Command line argument (`--threads/-@`) will be reduced by 1 to set number of additional threads.

  ###Common Issues and Important Notes

  - Parameter **Memory per thread** (`-m`) should be specified either in bytes or with a K, M, or G suffix. The number that precedes suffix should be an integer. To prevent **SAMtools Sort** from creating a huge number of temporary files, it enforces a minimum value of 1M for this setting.

  ###Performance Benchmarking

  By default, **SAMtools Sort** is single-threaded. Multithreading can be enabled by setting parameter **Number of threads** (`--threads/-@`). Parameter **Memory per thread** (`-m`) does not affect execution time but larger values of this parameter will affect instance type selection which can lead to longer execution and/or larger cost. Instance type also depends on parameter **Number of threads** (`--threads/-@`). Recommended values of these parameters for optimal cost are **Number of threads** = 8, **Memory per thread** = 1G (or None for default settings). 

  In the following table you can find estimates of **SAMtools Sort** running time and cost.

  *Cost can be significantly reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*  
     
  | Input type | Input size | # of reads | Read length | Sort by read name |  # of threads | Duration | Cost | Instance (AWS)|
  |---------------|--------------|---------------|------------------|---------------------------|------------------|-------------|--------|-------------|
  | BAM | 7.06 GB | 71.5M | 76 | False | 1 | 17min. | \$0.11 | c4.2xlarge |
  | BAM | 16.21 GB | 161.2M | 101 | False | 1 | 44min. | \$0.29 | c4.2xlarge |
  | BAM | 24.05 GB | 179M | 76 | False | 1 | 1h 16min. | \$0.50 | c4.2xlarge |
  | BAM | 89.56 GB | 845.6M | 150 | False | 1 | 4h 47min. | \$1.90 | c4.2xlarge |
  | BAM | 7.06 GB | 71.5M | 76 | False | 8 | 8min. | \$0.05 | c4.2xlarge |
  | BAM | 16.21 GB | 161.2M | 101 | False | 8 | 16min. | \$0.11 | c4.2xlarge |
  | BAM | 24.05 GB | 179M | 76 | False | 8 | 25min. | \$0.17 | c4.2xlarge |
  | BAM | 89.56 GB | 845.6M | 150 | False | 8 | 1h 33min. | \$0.62 | c4.2xlarge |
  | BAM | 7.06 GB | 71.5M | 76 | False | 16 | 4min. | \$0.05 | c4.4xlarge |
  | BAM | 16.21 GB | 161.2M | 101 | False | 16 | 10min. | \$0.13 | c4.4xlarge |
  | BAM | 24.05 GB | 179M | 76 | False | 16 | 17min. | \$0.23 | c4.4xlarge |
  | BAM | 89.56 GB | 845.6M | 150 | False | 16 | 58min. | \$0.77 | c4.4xlarge |
  | BAM | 5.26 GB | 71.5M | 76 | True | 1 | 24min. | \$0.16 | c4.2xlarge |
  | BAM | 11.86 GB | 161.2M | 101 | True | 1 | 1h 1min. | \$0.40 | c4.2xlarge |
  | BAM | 18.36 GB | 179M | 76 | True | 1 | 1h 40min. | \$0.66 | c4.2xlarge |
  | BAM | 58.61 GB | 845.6M | 150 | True | 1 | 6h 16min. | \$2.49 | c4.2xlarge |
  | BAM | 5.26 GB | 71.5M | 76 | True | 8 | 9min. | \$0.06 | c4.2xlarge |
  | BAM | 11.86 GB | 161.2M | 101 | True | 8 | 19min. | \$0.13 | c4.2xlarge |
  | BAM | 18.36 GB | 179M | 76 | True | 8 | 28min. | \$0.19 | c4.2xlarge |
  | BAM | 58.61 GB | 845.6M | 150 | True | 8 | 2h 1min. | \$0.80 | c4.2xlarge |
  | BAM | 5.26 GB | 71.5M | 76 | True | 16 | 5min. | \$0.07 | c4.4xlarge |
  | BAM | 11.86 GB | 161.2M | 101 | True | 16 | 14min. | \$0.19 | c4.4xlarge |
  | BAM | 18.36 GB | 179M | 76 | True | 16 | 19min. | \$0.25 | c4.4xlarge |
  | BAM | 58.61 GB | 845.6M | 150 | True | 16 | 1h 13min. | \$0.97 | c4.4xlarge |

  ###References

  [1] [SAMtools documentation](http://www.htslib.org/doc/samtools-1.6.html)
sbg:appVersion:
- sbg:draft-2
sbg:categories:
- SAM/BAM-Processing
sbg:cmdPreview: /opt/samtools-1.6/samtools sort  input_file.bam
sbg:content_hash:
sbg:contributors:
- michael_lloyd
sbg:copyOf: admin/sbg-public-data/samtools-sort-1-6/6
sbg:createdBy: michael_lloyd
sbg:createdOn: 1551125632
sbg:id: michael_lloyd/cnv-analysis-wustl-legacywhims/samtools-sort-1-6/0
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 8
    mem: 6144
  inputs:
    compression_level:
    input_file:
      class: File
      secondaryFiles: []
      path: input_file.bam
      size: 0
    input_fmt_option: ''
    max_mem_per_thread: 512M
    output_filename: ''
    output_fmt_option: ''
    output_format: sam
    sort_by_read_name: false
    sort_by_tag: ''
    threads: 8
sbg:latestRevision: 0
sbg:license: MIT License
sbg:links:
- id: http://www.htslib.org
  label: Homepage
- id: https://github.com/samtools/samtools
  label: Source Code
- id: https://github.com/samtools/samtools/wiki
  label: Wiki
- id: https://sourceforge.net/projects/samtools/files/samtools/
  label: Download
- id: http://www.ncbi.nlm.nih.gov/pubmed/19505943
  label: Publication
- id: http://www.htslib.org/doc/samtools-1.6.html
  label: Documentation
sbg:modifiedBy: michael_lloyd
sbg:modifiedOn: 1551125632
sbg:project: michael_lloyd/cnv-analysis-wustl-legacywhims
sbg:projectName: CNV-Analysis-WUSTL-LegacyWHIMs
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: Copy of admin/sbg-public-data/samtools-sort-1-6/6
sbg:revisionsInfo:
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1551125632
  sbg:revision: 0
  sbg:revisionNotes: Copy of admin/sbg-public-data/samtools-sort-1-6/6
sbg:sbgMaintained: false
sbg:toolAuthor: |-
  Heng Li (Sanger Institute), Bob Handsaker (Broad Institute), Jue Ruan (Beijing Genome Institute), Colin Hercus, Petr Danecek
sbg:toolkit: SAMtools
sbg:toolkitVersion: '1.6'
sbg:validationErrors: []
