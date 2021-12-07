cwlVersion: sbg:draft-2
class: CommandLineTool
label: Somalier Extract
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
- id: '#Sites'
  type:
  - File
  inputBinding:
    prefix: -s
    position: 2
    separate: true
  description: Sites vcf file of variants to extract
  sbg:fileTypes: VCF.GZ
- id: '#Reference'
  type:
  - File
  inputBinding:
    prefix: -f
    position: 3
    separate: true
  description: Path to reference fasta file
  sbg:fileTypes: FASTA, FA
- id: '#Sample_file'
  type:
  - File
  - type: array
    items: File
  inputBinding:
    secondaryFiles:
    - .bai
    position: 3
    separate: true
  description: |-
    single-sample CRAM/BAM/GVCF file or multi/single-sample VCF from which to extract
  sbg:fileTypes: BAM

outputs:
- id: '#Somalier_File'
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.somalier'
    sbg:inheritMetadataFrom: '#Sample_file'

baseCommand:
- somalier
- extract
arguments:
- prefix: ''
  position: 7
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |+
      {
          filename = $job.inputs.Sample_file.path.split('/').pop()
          primename = filename.split('.bam')[0]
          return '&& mv *.somalier ' + primename + '.somalier'
      }

  separate: true

hints:
- class: DockerRequirement
  dockerPull: pgc-images.sbgenomics.com/d3b-bixu/somalier:v1
id: michael_lloyd/sample-and-cohort-level-qc/somalier/1
sbg:appVersion:
- sbg:draft-2
sbg:content_hash: af0185de0296977751cc6ae8b85ab060c3b89597a3f79137140d8261a95c80746
sbg:contributors:
- michael_lloyd
sbg:createdBy: michael_lloyd
sbg:createdOn: 1578491243
sbg:id: michael_lloyd/sample-and-cohort-level-qc/somalier/1
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: michael_lloyd
sbg:modifiedOn: 1578922582
sbg:project: michael_lloyd/sample-and-cohort-level-qc
sbg:projectName: Sample and Cohort Level QC
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: changes inputs to required
sbg:revisionsInfo:
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1578491243
  sbg:revision: 0
  sbg:revisionNotes: Copy of michael_lloyd/mantis/somalier/15
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1578922582
  sbg:revision: 1
  sbg:revisionNotes: changes inputs to required
sbg:sbgMaintained: false
sbg:validationErrors: []
