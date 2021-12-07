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
      && xenome classify
      -T $(inputs.cores)
      -P $(inputs.idx_prefix)
      --host-name mouse
      --graft-name human
      -i $(inputs.fastq_reads.path)
      -M ${ return inputs.ram/2 }
      --preserve-read-order
      --output-filename-prefix $(inputs.output_basename)
      > $(inputs.output_basename).Xenome.Classification.Stats.txt

inputs:
  xenome_index: {type: File, doc: "Xenome index made form host and graft fasta"}
  idx_prefix: {type: string, doc: "String prefix of index files when decompressed"}
  fastq_reads: {type: File, doc: "Sequencing reads to classify"}
  output_basename: string
  cores: {type: "int?", doc: "Num cores to use", default: 16}
  ram: {type: "int?", doc: "Mem to use in GB", default: 64}

outputs:
  output_fastqs:
    type: File
    outputBinding:
      glob: '*.fastq'
  output_stats:
    type: File
    outputBinding:
      glob: '*.Xenome.Classification.Stats.txt'
