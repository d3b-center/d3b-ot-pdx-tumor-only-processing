cwlVersion: sbg:draft-2
class: CommandLineTool
label: SBG Split Pair by Metadata
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
- id: '#metadata_criteria'
  label: Metadata criteria
  type:
  - name: metadata_criteria
    type: record
    fields:
    - label: Output 1
      name: output_1
      type:
      - 'null'
      - string
      description: Output 1 metadta name:value pair.
      sbg:category: Execution
    - label: Output 2
      name: output_2
      type:
      - 'null'
      - string
      description: Output 2 metadta name:value pair.
      sbg:category: Execution
  description: Metadata name:value pair for splitting the pair.
  required: true
  sbg:category: Execution
- id: '#input_pair'
  label: Input pair
  type:
  - type: array
    items: File
  description: Input pair to be split on two outputs.
  required: true
  sbg:category: File Input
  sbg:stageInput: link

outputs:
- id: '#output_files_2'
  label: Output Files 2
  type:
  - 'null'
  - type: array
    items: File
  outputBinding:
    outputEval:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
         //return $job.inputs.metadata_criteria
          outlist = []
          
          if ($job.inputs.metadata_criteria.output_2){
            
            parts = $job.inputs.metadata_criteria.output_2.split(':')
            
            if (parts.length < 2){
              
              return ''
              
            }
            
            for (i=0;i<$job.inputs.input_pair.length;i++){
            
            
            	if ($job.inputs.input_pair[i].metadata[parts[0]] == parts[1]) {
              
              		outlist.push($job.inputs.input_pair[i])
              
            	}
            }
            
          }
          
          return outlist
        }
    sbg:inheritMetadataFrom: '#input_pair'
  description: Output files 2 based on the appropriate metadata.
- id: '#output_files_1'
  label: Output files 1
  type:
  - 'null'
  - type: array
    items: File
  outputBinding:
    outputEval:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
         //return $job.inputs.metadata_criteria
          outlist = []
          
          if ($job.inputs.metadata_criteria.output_1){
            
            parts = $job.inputs.metadata_criteria.output_1.split(':')
            
            if (parts.length < 2){
              
              return ''
              
            }
            
            for (i=0;i<$job.inputs.input_pair.length;i++){
            
            
            	if ($job.inputs.input_pair[i].metadata[parts[0]] == parts[1]) {
              
              		outlist.push($job.inputs.input_pair[i])
              
            	}
            }
            
          }
          
          return outlist
        }
    sbg:inheritMetadataFrom: '#input_pair'
  description: Output files 1 based on the appropriate metadata.

baseCommand: []

hints:
- class: sbg:CPURequirement
  value: 1
- class: sbg:MemRequirement
  value: 1000
- class: DockerRequirement
  dockerPull: ubuntu:14.04
id: |-
  jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/sbg-split-pair-by-metadata/0
appUrl: |-
  /u/jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/apps/#jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/sbg-split-pair-by-metadata/0
description: |-
  This tool is a "junction" tool sorting files from a single array input into multiple arrays. It shouldn't be used as a single tool.
  Because of the general purpose the input files do not have any set requirements and they depend on the use case and pipeline. The splitting criteria is given in the "key:value" form, and each output contains all the files that have metadat[key]==value.
  Built-in metadat fields are all written in lower case with underscores instead of spaces (Sample type is "sample_type"), while custom metadata fields can be written with any desired string.
sbg:appVersion:
- sbg:draft-2
sbg:cmdPreview: ''
sbg:contributors:
- jelena_randjelovic
sbg:createdBy: jelena_randjelovic
sbg:createdOn: 1538394635
sbg:id: |-
  jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/sbg-split-pair-by-metadata/0
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 1
    mem: 1000
  inputs:
    input_pair:
    - class: File
      secondaryFiles: []
      metadata:
        sample_type: Primary Tumor
      path: /path/to/input_pair-1.ext
      size: 0
    - class: File
      secondaryFiles: []
      metadata:
        sample_type: nada
      path: /path/to/input_pair-2.ext
      size: 0
    - class: File
      secondaryFiles: []
      metadata:
        sample_type: nada
      path: akajsdhkasdksj
      size: 0
    - class: File
      secondaryFiles: []
      metadata:
        sample_type: stagod
      path: alksjdlaksdlk
      size: 0
    metadata_criteria:
      output_1: paired_end:1
      output_2: paired_end:2
sbg:latestRevision: 0
sbg:license: Internal
sbg:modifiedBy: jelena_randjelovic
sbg:modifiedOn: 1538394635
sbg:project: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow
sbg:projectName: PDXnet - Polishing JAX RNA-seq workflow
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes:
sbg:revisionsInfo:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538394635
  sbg:revision: 0
  sbg:revisionNotes:
sbg:sbgMaintained: false
sbg:toolAuthor: Seven Bridges
sbg:validationErrors: []
x: 496.66679382324253
y: 421.6667683919273
