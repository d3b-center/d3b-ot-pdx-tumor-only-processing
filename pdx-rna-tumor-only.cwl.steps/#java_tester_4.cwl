cwlVersion: sbg:draft-2
class: CommandLineTool
label: human_read_count
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
              if 'human' in line:
                  human_reads = line.split('\t')[0].rstrip()
                  print(human_reads)
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
id: michael_lloyd/sample-and-cohort-level-qc/java-tester-4/3
sbg:appVersion:
- sbg:draft-2
sbg:content_hash: affdf02882a327be1dd09ae78dc509890624223406283d9da318b905894a9b85b
sbg:contributors:
- michael_lloyd
sbg:createdBy: michael_lloyd
sbg:createdOn: 1579009212
sbg:id: michael_lloyd/sample-and-cohort-level-qc/java-tester-4/3
sbg:image_url:
sbg:latestRevision: 3
sbg:modifiedBy: michael_lloyd
sbg:modifiedOn: 1600450299
sbg:project: michael_lloyd/sample-and-cohort-level-qc
sbg:projectName: Sample and Cohort Level QC
sbg:publisher: sbg
sbg:revision: 3
sbg:revisionNotes: fixed py error
sbg:revisionsInfo:
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579009212
  sbg:revision: 0
  sbg:revisionNotes: Copy of michael_lloyd/sample-and-cohort-level-qc/java-tester-2/2
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579009473
  sbg:revision: 1
  sbg:revisionNotes: changed to human read count
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600440731
  sbg:revision: 2
  sbg:revisionNotes: removed carriage return
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600450299
  sbg:revision: 3
  sbg:revisionNotes: fixed py error
sbg:sbgMaintained: false
sbg:validationErrors: []
