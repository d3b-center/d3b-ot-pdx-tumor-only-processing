cwlVersion: sbg:draft-2
class: CommandLineTool
label: perc_usable_bases
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
              if 'PCT_USABLE_BASES' in line:
                  PCT_USABLE_BASES = line.split('\t')[1].rstrip()
                  print(PCT_USABLE_BASES)
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
id: michael_lloyd/sample-and-cohort-level-qc/java-tester-8/5
sbg:appVersion:
- sbg:draft-2
sbg:content_hash: a86304a60ffe01d0855a78110274ab224cac6d7517949b34121c4da362a0f211f
sbg:contributors:
- michael_lloyd
sbg:createdBy: michael_lloyd
sbg:createdOn: 1579281523
sbg:id: michael_lloyd/sample-and-cohort-level-qc/java-tester-8/5
sbg:image_url:
sbg:latestRevision: 5
sbg:modifiedBy: michael_lloyd
sbg:modifiedOn: 1600450345
sbg:project: michael_lloyd/sample-and-cohort-level-qc
sbg:projectName: Sample and Cohort Level QC
sbg:publisher: sbg
sbg:revision: 5
sbg:revisionNotes: fixed py error
sbg:revisionsInfo:
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579281523
  sbg:revision: 0
  sbg:revisionNotes: Copy of michael_lloyd/sample-and-cohort-level-qc/java-tester-7/1
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1579281566
  sbg:revision: 1
  sbg:revisionNotes: change to PCT_USABLE_BASES
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600440505
  sbg:revision: 2
  sbg:revisionNotes: removed carriage return
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600440539
  sbg:revision: 3
  sbg:revisionNotes: removed carriage return
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600440597
  sbg:revision: 4
  sbg:revisionNotes: removed carriage return
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1600450345
  sbg:revision: 5
  sbg:revisionNotes: fixed py error
sbg:sbgMaintained: false
sbg:validationErrors: []
