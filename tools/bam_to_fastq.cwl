class: CommandLineTool
cwlVersion: v1.0
id: bamtofastq_pe
doc: |-
  Simple tool to take in a paired-end aligned bam and convert to forward ans reverse fastq files
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 1000
  - class: DockerRequirement
    dockerPull: 'pgc-images.sbgenomics.com/d3b-bixu/bwa-bundle:dev'
  - class: InlineJavascriptRequirement
baseCommand: ["/bin/bash", "-c"]
arguments:
  - position: 0
    shellQuote: false
    valueFrom: |-
      set -eo pipefail

      samtools view -H $(inputs.input_bam.path) | grep ^@RG > rg.txt

      bamtofastq tryoq=1 filename=$(inputs.input_bam.path) F=$(inputs.input_bam.nameroot)_R1.fastq.gz F2=$(inputs.input_bam.nameroot)_R2.fastq.gz gz=1

inputs:
  input_bam: { type: File, doc: "Input bam file, paired-end" }
outputs:
  output: { type: 'File[]', outputBinding: { glob: '*.fastq.gz' } }
  rg_string:
    type: File
    outputBinding:
      glob: rg.txt
