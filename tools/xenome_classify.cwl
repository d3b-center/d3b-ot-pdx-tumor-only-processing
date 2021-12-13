cwlVersion: v1.2
class: CommandLineTool
id: xenome_classify
requirements:
  - class: ShellCommandRequirement
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: ${ return inputs.ram * 1000 }
    coresMin: $(inputs.cores)
  - class: DockerRequirement
    dockerPull: 'pgc-images.sbgenomics.com/d3b-bixu/xenome2'
baseCommand: [tar, -xzvf]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      $(inputs.xenome_index.path) --strip-components 1
  - position: 3
    shellQuote: false
    valueFrom: >-
      && xenome classify
      --host-name mouse
      --graft-name human
      --pairs
      -M ${ return Math.floor(inputs.ram * (4/5)) }
      --output-filename-prefix $(inputs.output_basename)
  - position: 5
    shellQuote: false
    valueFrom: >-
      > $(inputs.output_basename).Xenome.Classification.Stats.txt

inputs:
  xenome_index: {type: File, inputBinding: {position: 2}, doc: "Xenome index made form host and graft fasta"}
  cores: {type: "int?", inputBinding: {prefix: -T, position: 4}, doc: "Num cores to use", default: 16}
  ram: {type: "int?", doc: "Mem to use in GB", default: 32}
  idx_prefix: {type: string, inputBinding: {prefix: -P, position: 4}, doc: "String prefix of index files when decompressed"}
  fastq_reads: 
    type:
      type: array
      items: File
      inputBinding:
        prefix: -i
    inputBinding:
      position: 4
  output_basename: string

outputs:
  output_fastqs:
    type: File
    outputBinding:
      glob: '*.fastq'
  output_stats:
    type: File
    outputBinding:
      glob: '*.Xenome.Classification.Stats.txt'
