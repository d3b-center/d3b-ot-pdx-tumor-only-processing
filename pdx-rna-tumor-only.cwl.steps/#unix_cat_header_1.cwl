cwlVersion: sbg:draft-2
class: CommandLineTool
label: metadata_annot
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
- id: '#input'
  type:
  - 'null'
  - File
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

outputs:
- id: '#output'
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.results'
    sbg:inheritMetadataFrom: '#input'
    sbg:metadata:
      num_human_reads:
        class: Expression
        engine: '#cwl-js-engine'
        script: |-
          {
              if ($job.inputs.human_read_count) {

                  return String($job.inputs.human_read_count).replace( /[\r\n]+/gm, "" )

                  
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

                  return String($job.inputs.human_percentage).replace( /[\r\n]+/gm, "" )

                  
              } else {
                  return String('NA')
              }
              
          }
      prop_correct_strand_reads:
        class: Expression
        engine: '#cwl-js-engine'
        script: "{\nreturn String($job.inputs.perc_correct_strand).replace( /[\\r\\\
          n]+/gm, \"\" )\n}"
      prop_ribosomal_bases:
        class: Expression
        engine: '#cwl-js-engine'
        script: "{\nreturn String($job.inputs.perc_ribosomal).replace( /[\\r\\n]+/gm,\
          \ \"\" )\n}"
      prop_usable_bases:
        class: Expression
        engine: '#cwl-js-engine'
        script: "{\nreturn String($job.inputs.perc_usable_bases).replace( /[\\r\\\
          n]+/gm, \"\" )\n}"

baseCommand:
- mv
- class: Expression
  engine: '#cwl-js-engine'
  script: $job.inputs.input.path
- class: Expression
  engine: '#cwl-js-engine'
  script: |+
    {
    	input_1 = [].concat($job.inputs.input)
      	filename = $job.inputs.input.path.split('/').slice(-1)[0];
      	pass_value = filename.split('.txt')[0]
      	return filename
    }



hints:
- class: sbg:CPURequirement
  value: 1
- class: sbg:MemRequirement
  value: 1000
- class: DockerRequirement
  dockerPull: pgc-images.sbgenomics.com/d3b-bixu/ubuntu:v1
id: michael_lloyd/sample-and-cohort-level-qc/unix-cat-header/5
sbg:appVersion:
- sbg:draft-2
sbg:cmdPreview: |-
  cat /path/to/segmentFile.ext /path/to/filtered_sequenza.txt > filtered_sequenza_header.txt
sbg:content_hash: a334819111d74f77f452a80686af50c706c80944f89cc5a627be0d6c5743fee9c
sbg:contributors:
- michael_lloyd
sbg:createdBy: michael_lloyd
sbg:createdOn: 1579280435
sbg:id: michael_lloyd/sample-and-cohort-level-qc/unix-cat-header/5
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 1
    mem: 1000
  inputs:
    Filtered_Sequenza_Segments:
      class: File
      secondaryFiles: []
      path: /path/to/filtered_sequenza.txt
      size: 0
    Seqz_Header_File:
      class: File
      secondaryFiles: []
      path: /path/to/segmentFile.ext
      size: 0
sbg:latestRevision: 5
sbg:modifiedBy: michael_lloyd
sbg:modifiedOn: 1600451426
sbg:project: michael_lloyd/sample-and-cohort-level-qc
sbg:projectName: Sample and Cohort Level QC
sbg:publisher: sbg
sbg:revision: 5
sbg:revisionNotes: updated to remove '\n' from metadata
sbg:revisionsInfo:
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579280435
  sbg:revision: 0
  sbg:revisionNotes: Copy of michael_lloyd/jax-pdx-cnv/unix-cat-header/3
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579281350
  sbg:revision: 1
  sbg:revisionNotes: initial
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579613754
  sbg:revision: 2
  sbg:revisionNotes: removed strings from command line
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579614717
  sbg:revision: 3
  sbg:revisionNotes: removed redirect
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579616913
  sbg:revision: 4
  sbg:revisionNotes: adjusted grob
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600451426
  sbg:revision: 5
  sbg:revisionNotes: updated to remove '\n' from metadata
sbg:sbgMaintained: false
sbg:validationErrors: []
