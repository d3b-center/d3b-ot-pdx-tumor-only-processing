cwlVersion: sbg:draft-2
class: CommandLineTool
label: perc_correct_strand
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
              if 'PCT_CORRECT_STRAND_READS' in line:
                  PCT_CORRECT_STRAND_READS = line.split('\t')[1].rstrip()
                  print(PCT_CORRECT_STRAND_READS)
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
id: michael_lloyd/sample-and-cohort-level-qc/java-tester-9/3
sbg:appVersion:
- sbg:draft-2
sbg:content_hash: a0a1e8278a5111e8614fd9c4da869395cd9a472fd79bc5fb816be09ff62dfbe93
sbg:contributors:
- michael_lloyd
sbg:createdBy: michael_lloyd
sbg:createdOn: 1579281583
sbg:id: michael_lloyd/sample-and-cohort-level-qc/java-tester-9/3
sbg:image_url:
sbg:latestRevision: 3
sbg:modifiedBy: michael_lloyd
sbg:modifiedOn: 1600450313
sbg:project: michael_lloyd/sample-and-cohort-level-qc
sbg:projectName: Sample and Cohort Level QC
sbg:publisher: sbg
sbg:revision: 3
sbg:revisionNotes: fixed py error
sbg:revisionsInfo:
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579281583
  sbg:revision: 0
  sbg:revisionNotes: Copy of michael_lloyd/sample-and-cohort-level-qc/java-tester-8/1
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579281616
  sbg:revision: 1
  sbg:revisionNotes: change to PCT_CORRECT_STRAND_READS
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600440685
  sbg:revision: 2
  sbg:revisionNotes: removed carriage return
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600450313
  sbg:revision: 3
  sbg:revisionNotes: fixed py error
sbg:sbgMaintained: false
sbg:validationErrors: []
