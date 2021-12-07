cwlVersion: sbg:draft-2
class: CommandLineTool
label: XenomeV2 Transcriptome
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
  label: Number of threads
  type:
  - 'null'
  - int
  inputBinding:
    prefix: -T
    position: 1
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.threads)
          {
            return $job.inputs.threads
          }
          else
          {
            return 15
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: Number of threads.
  sbg:stageInput:
  sbg:toolDefaultValue: '15'
- id: '#pairs'
  label: Treat reads from consecutive input files of the same type as pairs
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --pairs
    position: 1
    separate: true
    sbg:cmdInclude: true
  description: Treat reads from consecutive input files of the same type as pairs.
  sbg:stageInput:
- id: '#indices_name'
  label: Xenome indices prefix string
  type:
  - 'null'
  - string
  inputBinding:
    prefix: -P
    position: 0
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.indices_name)
          {
            return $job.inputs.indices_name
          }
          else
          {
            return "trans_human_GRCh38_91_NOD_based_on_mm10_k25"
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: Xenome indices prefix string.
  sbg:toolDefaultValue: trans_human_GRCh38_91_NOD_based_on_mm10_k25
- id: '#index_file'
  label: Xenome Indices
  type:
  - File
  required: true
  sbg:stageInput: copy
- id: '#host_name'
  label: Host name
  type:
  - 'null'
  - string
  inputBinding:
    prefix: --host-name
    position: 2
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.host_name)
          {
            return $job.inputs.host_name
          }
          else
          {
            return "mouse"
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: Host name
- id: '#graft_name'
  label: Graft name
  type:
  - 'null'
  - string
  inputBinding:
    prefix: --graft-name
    position: 3
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.graft_name)
          {
            return $job.inputs.graft_name
          }
          else
          {
            return "human"
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: Graft name.
- id: '#fastq_reverse'
  type:
  - File
  inputBinding:
    prefix: -i
    position: 5
    separate: true
    sbg:cmdInclude: true
  required: true
- id: '#fastq_forward'
  type:
  - File
  inputBinding:
    prefix: -i
    position: 4
    separate: true
    sbg:cmdInclude: true
  required: true
  sbg:fileTypes: fastq

outputs:
- id: '#stats_file'
  label: Xenome stats file
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.Xenome.Classification.Stats.txt'
    sbg:inheritMetadataFrom: '#fastq_forward'
  description: Xenome stats file.
  sbg:fileTypes: TXT
- id: '#human_reverse'
  label: Human Specific Fastq files
  type:
  - 'null'
  - File
  outputBinding:
    glob:
      class: Expression
      engine: '#cwl-js-engine'
      script: '"*human_2.fastq"'
    sbg:inheritMetadataFrom: '#fastq_reverse'
- id: '#human_forward'
  type:
  - 'null'
  - File
  outputBinding:
    glob:
      class: Expression
      engine: '#cwl-js-engine'
      script: '"*human_1.fastq"'
    sbg:inheritMetadataFrom: '#fastq_forward'

baseCommand:
- tar
- -xzvf
- class: Expression
  engine: '#cwl-js-engine'
  script: $job.inputs.index_file.path
- --strip-components
- 1;
- xenome
- classify
arguments:
- position: 100
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        if (($job.inputs.fastq_forward.metadata) && ($job.inputs.fastq_forward.metadata['sample_id']))
        {
          return " > ".concat($job.inputs.fastq_forward.metadata['sample_id'], '.Xenome.Classification.Stats.txt')
        }
        else
        {
          return "> Sample.Xenome.Classification.Stats.txt"
        }
      }
  separate: true

hints:
- class: sbg:AWSInstanceType
  value: c4.4xlarge;ebs-gp2;400
- class: sbg:CPURequirement
  value: 1
- class: sbg:MemRequirement
  value: 30000
- class: DockerRequirement
  dockerPull: pgc-images.sbgenomics.com/d3b-bixu/xenome2:latest
id: |-
  jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/xenomev2-transcriptome/1
sbg:appVersion:
- sbg:draft-2
sbg:cmdPreview: |-
  tar -xzvf /path/to/index_file.ext --strip-components 1; xenome classify  -i /path/to/input.ext -i /path/to/input.ext   > test_sample_id.Xenome.Classification.Stats.txt
sbg:contributors:
- jelena_randjelovic
sbg:createdBy: jelena_randjelovic
sbg:createdOn: 1538394636
sbg:id: |-
  jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/xenomev2-transcriptome/1
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 1
    mem: 30000
  inputs:
    fastq_forward:
      class: File
      secondaryFiles: []
      contents: file contents
      metadata:
        sample_id: test_sample_id
      path: /path/to/input.ext
      size: 0
    fastq_reverse:
      class: File
      secondaryFiles: []
      contents: file contents
      path: /path/to/input.ext
      size: 0
    graft_name: graft_name-string-value
    host_name: host_name-string-value
    index_file:
      class: File
      secondaryFiles: []
      path: /path/to/index_file.ext
      size: 0
    indices_name: indices_name-string-value
    pairs: true
    threads: 10
sbg:latestRevision: 1
sbg:modifiedBy: jelena_randjelovic
sbg:modifiedOn: 1538400526
sbg:project: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow
sbg:projectName: PDXnet - Polishing JAX RNA-seq workflow
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: output naming, instance hint, input wrapping for hardcoded values
sbg:revisionsInfo:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538394636
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538400526
  sbg:revision: 1
  sbg:revisionNotes: output naming, instance hint, input wrapping for hardcoded values
sbg:sbgMaintained: false
sbg:validationErrors: []
x: 651.6669718424483
y: 463.33343505859403
