cwlVersion: sbg:draft-2
class: CommandLineTool
label: SAMtools Index - RNA
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- id: '#cwl-js-engine'
  class: ExpressionEngineRequirement
  requirements:
  - class: DockerRequirement
    dockerPull: rabix/js-engine
- class: CreateFileRequirement
  fileDef:
  - fileContent: |-
      import sys

      with open(sys.argv[1]) as f:
          for line in f:
              line = line.rstrip('\n')
              if 'PERCENT_DUPLICATION' in line:
                  PERCENT_DUPLICATION = line.split(sep='\t')[1]
                  print(PERCENT_DUPLICATION)
              if 'MEAN_TARGET_COVERAGE' in line:
                  MEAN_TARGET_COVERAGE = line.split(sep='\t')[1]
                  print(MEAN_TARGET_COVERAGE)
              if 'PCT_TARGET_BASES_20X' in line:
                  PCT_TARGET_BASES_20X = line.split(sep='\t')[1]
                  print(PCT_TARGET_BASES_20X)
    filename: log_parse.py
- class: InlineJavascriptRequirement

inputs:
- id: '#input_bam_or_cram_file'
  label: BAM/CRAM input file
  type:
  - File
  inputBinding:
    position: 8
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if($job.inputs.input_index_file){
            index_ext = [].concat($job.inputs.input_index_file)[0].path.substr([].concat($job.inputs.input_index_file)[0].path.lastIndexOf('.')+1)
            input_ext = [].concat($job.inputs.input_bam_or_cram_file)[0].path.substr([].concat($job.inputs.input_bam_or_cram_file)[0].path.lastIndexOf('.')+1)
            index_format = 'BAI'
            if($job.inputs.index_file_format){
              index_format = $job.inputs.index_file_format
            }
            if($job.inputs.minimum_interval_size){
              index_format = ''
            }
            
            if((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
              (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')){
              return 
            }
            else{
              return $job.inputs.input_bam_or_cram_file.path
            }
          }
          else{
            return $job.inputs.input_bam_or_cram_file.path
          } 
        }
    separate: true
    sbg:cmdInclude: true
  description: BAM/CRAM input file.
  sbg:category: File Inputs
  sbg:fileTypes: BAM, CRAM
  sbg:stageInput: link
- id: '#output_indexed_data'
  label: Output indexed data file
  type:
  - 'null'
  - boolean
  description: |-
    Setting this parameter to True will provide BAM file (and BAI file as secondary file) at Indexed data file output port. The default value is False.
  sbg:category: Config Inputs
- id: '#input_index_file'
  label: Input index file
  type:
  - 'null'
  - File
  description: |-
    Input index file (CSI, CRAI, or BAI). If an input BAM/CRAM file is already indexed, index file can be provided at this port. If it is provided, the tool will just pass it through. This option is useful for workflows when it is not know in advance if the input BAM/CRAM file has accompanying index file present in the project.
  sbg:category: File Inputs
  sbg:fileTypes: BAI, CSI, CRAI
  sbg:stageInput: link
- id: '#minimum_interval_size'
  label: Minimum interval size (2^INT)
  type:
  - 'null'
  - int
  inputBinding:
    prefix: -m
    position: 1
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if($job.inputs.minimum_interval_size){
            if($job.inputs.input_index_file){
              index_ext = [].concat($job.inputs.input_index_file)[0].path.substr([].concat($job.inputs.input_index_file)[0].path.lastIndexOf('.')+1)
              input_ext = [].concat($job.inputs.input_bam_or_cram_file)[0].path.substr([].concat($job.inputs.input_bam_or_cram_file)[0].path.lastIndexOf('.')+1)
              index_format = 'BAI'
              if($job.inputs.index_file_format){
                index_format = $job.inputs.index_file_format
              }
              if($job.inputs.minimum_interval_size){
                index_format = ''
              }

              if((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
                (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')){
                return 
              }
              else{
                return $job.inputs.minimum_interval_size
              }
            }
            else{
              return $job.inputs.minimum_interval_size
            } 
          }
          else{
            return
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: |-
    Set minimum interval size for CSI indices to 2^INT. Default value is 14. Setting this value will force generating CSI index file (if the input file is BAM) regardless of the value of the parameter Format of index file (for BAM files).
  sbg:category: Config Inputs
  sbg:toolDefaultValue: '14'
- id: '#index_file_format'
  label: Format of index file (for BAM files)
  type:
  - 'null'
  - name: index_file_format
    type: enum
    symbols:
    - BAI
    - CSI
  inputBinding:
    position: 0
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if($job.inputs.index_file_format){
            if($job.inputs.input_index_file){
              index_ext = [].concat($job.inputs.input_index_file)[0].path.substr([].concat($job.inputs.input_index_file)[0].path.lastIndexOf('.')+1)
              input_ext = [].concat($job.inputs.input_bam_or_cram_file)[0].path.substr([].concat($job.inputs.input_bam_or_cram_file)[0].path.lastIndexOf('.')+1)
              index_format = $job.inputs.index_file_format
              if($job.inputs.minimum_interval_size){
                index_format = ''
              }
              
              if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
                  (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')){
                return
              }
              else{
                if ($job.inputs.index_file_format === 'BAI'){
                  return '-b'
                }
                else if ($job.inputs.index_file_format === 'CSI'){
                  return '-c'
                }
              }
            }
            else{
              if ($job.inputs.index_file_format === 'BAI'){
                return '-b'
              }
              else if ($job.inputs.index_file_format === 'CSI'){
                return '-c'
              }
            }
          }
          else{
            return
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: |-
    Choose which file format will be generated for index file (BAI or CSI) if the input is BAM file. In case the input is CRAM file, this will be ignored and the tool will generate CRAI file.
  sbg:category: Config Inputs
- id: '#threads'
  label: Number of threads
  type:
  - 'null'
  - int
  inputBinding:
    prefix: -@
    position: 0
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if($job.inputs.threads){
            if($job.inputs.input_index_file){
              index_ext = [].concat($job.inputs.input_index_file)[0].path.substr([].concat($job.inputs.input_index_file)[0].path.lastIndexOf('.')+1)
              input_ext = [].concat($job.inputs.input_bam_or_cram_file)[0].path.substr([].concat($job.inputs.input_bam_or_cram_file)[0].path.lastIndexOf('.')+1)
              index_format = 'BAI'
              if($job.inputs.index_file_format){
                index_format = $job.inputs.index_file_format
              }
              if($job.inputs.minimum_interval_size){
                index_format = ''
              }

              if((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
                (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')){
                return 
              }
              else{
                return $job.inputs.threads
              }
            }
            else{
              return $job.inputs.threads
            } 
          }
          else{
            return
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: Number of threads.
  sbg:category: Execution
- id: '#perc_correct_strand'
  type:
  - 'null'
  - string
- id: '#perc_usable_bases'
  type:
  - 'null'
  - string
- id: '#perc_ribosomal'
  type:
  - 'null'
  - string
- id: '#human_percentage'
  type:
  - 'null'
  - string
- id: '#human_read_count'
  type:
  - 'null'
  - string
- id: '#read_count'
  type:
  - 'null'
  - string

outputs:
- id: '#indexed_data_file'
  label: Indexed data file
  type:
  - 'null'
  - File
  outputBinding:
    secondaryFiles:
    - .bai
    - .crai
    - ^.bai
    - ^.crai
    - .csi
    - ^.csi
    glob:
      class: Expression
      engine: '#cwl-js-engine'
      script: |+
        {
          if ($job.inputs.output_indexed_data === true){
        	return [].concat($job.inputs.input_bam_or_cram_file)[0].path.split("/").pop()
          } 
          else{
            return ''
          }
        }


    sbg:inheritMetadataFrom: '#input_bam_or_cram_file'
    sbg:metadata:
      num_human_reads:
        class: Expression
        engine: '#cwl-js-engine'
        script: |-
          {
              if ($job.inputs.human_read_count) {

                  return String($job.inputs.human_read_count).replace( /[\r\n]+/gm, "")

                  
              } else {
                  return String('NA')
              }
              
          }
      perc_human_reads:
        class: Expression
        engine: '#cwl-js-engine'
        script: |-
          {
              if ($job.inputs.human_percentage) {

                  return String($job.inputs.human_percentage).replace( /[\r\n]+/gm, "")

                  
              } else {
                  return String('NA')
              }
              
          }
      prop_correct_strand_reads:
        class: Expression
        engine: '#cwl-js-engine'
        script: "{\nreturn String($job.inputs.perc_correct_strand).replace( /[\\r\\\
          n]+/gm, \"\")\n}"
      prop_ribosomal_bases:
        class: Expression
        engine: '#cwl-js-engine'
        script: "{\nreturn String($job.inputs.perc_ribosomal).replace( /[\\r\\n]+/gm,\
          \ \"\")\n}"
      prop_usable_bases:
        class: Expression
        engine: '#cwl-js-engine'
        script: "{\nreturn String($job.inputs.perc_usable_bases).replace( /[\\r\\\
          n]+/gm, \"\")\n}"
  description: Output BAM/CRAM, along with its index as secondary file.
  sbg:fileTypes: BAM, CRAM
- id: '#generated_index'
  label: Generated index file
  type:
  - 'null'
  - File
  outputBinding:
    glob:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          input_ext = [].concat($job.inputs.input_bam_or_cram_file)[0].path.substr([].concat($job.inputs.input_bam_or_cram_file)[0].path.lastIndexOf('.')+1)
          if(input_ext.toUpperCase() === 'CRAM'){
            return '*.crai'
          }
          else if(input_ext.toUpperCase() === 'BAM'){
            index_format = 'BAI'
            if($job.inputs.index_file_format){
              index_format = $job.inputs.index_file_format
            }
            if($job.inputs.minimum_interval_size){
              index_format = 'CSI'
            } 
            return '*.' + index_format.toLowerCase()
          }
        }
    sbg:inheritMetadataFrom: '#input_bam_or_cram_file'
  description: Generated index file (without the indexed data).
  sbg:fileTypes: BAI, CRAI, CSI

baseCommand:
- class: Expression
  engine: '#cwl-js-engine'
  script: |-
    {
      if($job.inputs.input_index_file)
      {
        index_ext = [].concat($job.inputs.input_index_file)[0].path.substr([].concat($job.inputs.input_index_file)[0].path.lastIndexOf('.')+1)
        input_ext = [].concat($job.inputs.input_bam_or_cram_file)[0].path.substr([].concat($job.inputs.input_bam_or_cram_file)[0].path.lastIndexOf('.')+1)
        index_format = 'BAI'
        if($job.inputs.index_file_format){
          index_format = $job.inputs.index_file_format
        }
        if($job.inputs.minimum_interval_size){
          index_format = ''
        }
        
        if((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
          (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')){
          return "echo Skipping index step because an index file is provided on the input."
        }
        else{
          return "/opt/samtools-1.6/samtools index"
        }
      }
      else{
        return "/opt/samtools-1.6/samtools index"
      } 
    }

hints:
- class: sbg:CPURequirement
  value:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        threads = 1
        if ($job.inputs.threads){
          threads = $job.inputs.threads
        }

        if($job.inputs.input_index_file)
        {
          index_ext = [].concat($job.inputs.input_index_file)[0].path.substr([].concat($job.inputs.input_index_file)[0].path.lastIndexOf('.')+1)
          input_ext = [].concat($job.inputs.input_bam_or_cram_file)[0].path.substr([].concat($job.inputs.input_bam_or_cram_file)[0].path.lastIndexOf('.')+1)
          index_format = 'BAI'
          if($job.inputs.index_file_format){
            index_format = $job.inputs.index_file_format
          }
          if($job.inputs.minimum_interval_size){
            index_format = ''
          }
          
          if((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
            (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')){
            return 1
          }
          else{
            return threads
          }
        }
        else{
          return threads
        } 
      }
- class: sbg:MemRequirement
  value: 1500
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/milana_kaljevic/samtools:1.6
  dockerImageId: 2fb927277493
id: michael_lloyd/sample-and-cohort-level-qc/samtools-index/3
description: |-
  **SAMtools Index** tool is used to index a coordinate-sorted BAM or CRAM file for fast random access. (Note that this does not work with SAM files even if they are bgzip compressed — to index such files, use tabix instead.) This index is needed when region arguments are used to limit **SAMtools View** and similar commands to particular regions of interest. For a CRAM file aln.cram, index file aln.cram.crai will be created; for a BAM file aln.bam, either aln.bam.bai or aln.bam.csi will be created, depending on the index format selected. [1]

  *A list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of the page.*

  ###Common Use Cases 

  - When using this tool as a standalone tool, **Input index file** should not be provided. This input is given as an option that is convenient to use in workflows. 
  - When using this tool in a workflow, **Input index file** can be provided. In case it is provided, the tool execution will be skipped and it will just pass the inputs through. This is useful for workflows which use tools that require index file when it is not known in advance if the input BAM/CRAM file will have accompanying index file present in the project. If the next tool in the workflow requires index file as a secondary file, parameter **Output indexed data file** should be set to True. This will provide BAM/CRAM file at **Indexed data file** output port along with its index file (BAI/CSI/CRAI) as secondary file.
  - If a CRAM file is provided at **BAM/CRAM input file** port, the tool will generate CRAI index file. If a BAM file is provided, the tool will generate BAI or CSI index file depending on parameter **Format of index file (for BAM files)** (`-b/-c`). If no value is set, the tool will generate BAI index file. Setting a parameter **Minimum interval size (2^INT)** (`-m`) will force CSI format regardless of the value of the parameter **Format of index file (for BAM files)**.

  ###Changes Introduced by Seven Bridges

  - Parameter output filename is omitted from the wrapper. For a CRAM file aln.cram, output filename will be aln.cram.crai; for a BAM file aln.bam, it will be either aln.bam.bai or aln.bam.csi, depending on the index format selected.
  - Parameter **Output indexed data file** and file input **Input index file** are added to provide additional options for integration with other tools within a workflow. 

  ###Common Issues and Important Notes

  - **BAM/CRAM input file** should be sorted by coordinates, not by name. Otherwise, the task will fail.
  - **When using this tool in a workflow, if the next tool in the workflow requires index file as a secondary file, parameter Output indexed data file should be set to True. This will provide BAM/CRAM file at Indexed data file output port along with its index file (BAI/CSI/CRAI) as secondary file.**

  ###Performance Benchmarking

  Multithreading can be enabled by setting parameter **Number of threads** (`-@`). In the following table you can find estimates of **SAMtools Index** running time and cost.

  *Cost can be significantly reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*  

  | Input type | Input size | # of reads | Read length |  # of threads | Duration | Cost | Instance (AWS)|
  |---------------|--------------|---------------|------------------|---------------------|-------------|--------|-------------|
  |  BAM | 5.26 GB | 71.5M | 76 | 1 | 5min. | \$0.03 | c4.2xlarge |
  |  BAM | 11.86 GB | 161.2M | 101| 1 | 8min. | \$0.05 | c4.2xlarge |
  |  BAM | 18.36 GB | 179M | 76 | 1 | 12min. | \$0.08 | c4.2xlarge |
  |  BAM | 58.61 GB | 845.6M | 150 | 1 | 30min. | \$0.20 | c4.2xlarge |
  |  BAM | 5.26 GB | 71.5M | 76 | 8 | 4min. | \$0.03 | c4.2xlarge |
  |  BAM | 11.86 GB | 161.2M | 101| 8 | 6min. | \$0.04 | c4.2xlarge |
  |  BAM | 18.36 GB | 179M | 76 | 8 | 12min. | \$0.08 | c4.2xlarge |
  |  BAM | 58.61 GB | 845.6M | 150 | 8 | 20min. | \$0.13 | c4.2xlarge |

  ###References

  [1] [SAMtools documentation](http://www.htslib.org/doc/samtools-1.6.html)
sbg:appVersion:
- sbg:draft-2
sbg:categories:
- SAM/BAM-Processing
- Indexing
sbg:cmdPreview: echo Skipping index step because an index file is provided on the
  input.
sbg:content_hash: a3d7bd9c74e948966f668de3612435fdeebe07ebf97bd9656a7a48dbea3cf70d2
sbg:contributors:
- michael_lloyd
sbg:createdBy: michael_lloyd
sbg:createdOn: 1579279828
sbg:id: michael_lloyd/sample-and-cohort-level-qc/samtools-index/3
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 1
    mem: 1500
  inputs:
    index_file_format: BAI
    input_bam_or_cram_file:
      class: File
      secondaryFiles: []
      path: path/to/input.cram
      size: 0
    input_index_file:
      class: File
      secondaryFiles: []
      path: /path/to/input.bam.crai
      size: 0
    minimum_interval_size: 56
    output_indexed_data: true
    threads: 7
sbg:latestRevision: 3
sbg:license: MIT License
sbg:links:
- id: http://www.htslib.org/
  label: Homepage
- id: https://github.com/samtools/samtools
  label: Source Code
- id: https://github.com/samtools/samtools/wiki
  label: Wiki
- id: https://sourceforge.net/projects/samtools/files/
  label: Download
- id: http://www.ncbi.nlm.nih.gov/pubmed/19505943
  label: Publication
- id: http://www.htslib.org/doc/samtools-1.6.html
  label: Documentation
sbg:modifiedBy: michael_lloyd
sbg:modifiedOn: 1600450530
sbg:project: michael_lloyd/sample-and-cohort-level-qc
sbg:projectName: Sample and Cohort Level QC
sbg:publisher: sbg
sbg:revision: 3
sbg:revisionNotes: added remove '\n' from metadata strings
sbg:revisionsInfo:
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579279828
  sbg:revision: 0
  sbg:revisionNotes: Copy of michael_lloyd/sample-and-cohort-level-qc/samtools-index-1-6/11
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579280094
  sbg:revision: 1
  sbg:revisionNotes: changed metadata to RNA relavent fields
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579280352
  sbg:revision: 2
  sbg:revisionNotes: removed read count from metadata
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600450530
  sbg:revision: 3
  sbg:revisionNotes: added remove '\n' from metadata strings
sbg:sbgMaintained: false
sbg:toolAuthor: |-
  Heng Li (Sanger Institute), Bob Handsaker (Broad Institute), Jue Ruan (Beijing Genome Institute), Colin Hercus, Petr Danecek
sbg:toolkit: SAMtools
sbg:toolkitVersion: '1.6'
sbg:validationErrors: []
