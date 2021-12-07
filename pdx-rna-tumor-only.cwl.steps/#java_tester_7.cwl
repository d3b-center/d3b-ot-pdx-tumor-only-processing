cwlVersion: sbg:draft-2
class: CommandLineTool
label: perc_ribosomal_bases
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
              if 'PCT_RIBOSOMAL_BASES' in line:
                  PCT_RIBOSOMAL_BASES = line.split('\t')[1].rstrip()
                  print(PCT_RIBOSOMAL_BASES)
    filename: log_parse.py
- class: InlineJavascriptRequirement

inputs:
- id: '#input'
  type:
  - 'null'
  - File
  inputBinding:
    position: 0
    separate: true

outputs:
- id: '#output'
  type:
  - 'null'
  - string
  outputBinding:
    glob: '*.txt'
    outputEval:
      class: Expression
      engine: '#cwl-js-engine'
      script: "{\n  if ($self)\n  {\n    var str = $self[0].contents\n    return str\n\
        \  }\n}\n"
    loadContents: true

baseCommand:
- python
- log_parse.py
arguments:
- prefix: ''
  position: 1
  valueFrom: '> perc.txt'
  separate: true

hints:
- class: DockerRequirement
  dockerPull: pgc-images.sbgenomics.com/d3b-bixu/allele_depth_filter:v2
id: michael_lloyd/sample-and-cohort-level-qc/java-tester-7/3
sbg:appVersion:
- sbg:draft-2
sbg:content_hash: a5c96ffdd82731307b5106d2bd71ff0277b87c923e9d5b50852cbc1625020f40c
sbg:contributors:
- michael_lloyd
sbg:createdBy: michael_lloyd
sbg:createdOn: 1579281372
sbg:id: michael_lloyd/sample-and-cohort-level-qc/java-tester-7/3
sbg:image_url:
sbg:latestRevision: 3
sbg:modifiedBy: michael_lloyd
sbg:modifiedOn: 1600450327
sbg:project: michael_lloyd/sample-and-cohort-level-qc
sbg:projectName: Sample and Cohort Level QC
sbg:publisher: sbg
sbg:revision: 3
sbg:revisionNotes: fixed py error
sbg:revisionsInfo:
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579281372
  sbg:revision: 0
  sbg:revisionNotes: Copy of michael_lloyd/sample-and-cohort-level-qc/java-tester-3/3
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579281503
  sbg:revision: 1
  sbg:revisionNotes: change to perc ribosomal
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600440660
  sbg:revision: 2
  sbg:revisionNotes: removed carriage return
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600450327
  sbg:revision: 3
  sbg:revisionNotes: fixed py error
sbg:sbgMaintained: false
sbg:validationErrors: []
