cwlVersion: sbg:draft-2
class: CommandLineTool
label: RSEM Plot Model
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
- id: '#rsem_calculate_expression_archive'
  label: Archive of all files produced by 'RSEM Calculate Expression'
  type:
  - File
  description: Bundle of all files outputed by 'RSEM Calculate Expression'.
  required: true
  sbg:fileTypes: TAR
  sbg:stageInput: link

outputs:
- id: '#rsem_model_plot'
  label: PDF plot model file
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.pdf'
    sbg:inheritMetadataFrom: '#rsem_calculate_expression_archive'
  description: PDF file with plots generated from the model.
  sbg:fileTypes: PDF

baseCommand:
- tar
- -xf
- class: Expression
  engine: '#cwl-js-engine'
  script: |-
    {
    var str = [].concat($job.inputs.rsem_calculate_expression_archive)[0].path.split("/").pop();
    return str

    }
- '&&'
- rsem-plot-model
arguments:
- position: 1
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: '[].concat($job.inputs.rsem_calculate_expression_archive)[0].metadata.sample_name'
  separate: true
- position: 2
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        var x = [].concat($job.inputs.rsem_calculate_expression_archive)[0].metadata.sample_name
        return x + "_plot_model.pdf" 
      }
  separate: true

hints:
- class: sbg:AWSInstanceType
  value: c4.2xlarge;ebs-gp2;200
- class: sbg:CPURequirement
  value: 1
- class: sbg:MemRequirement
  value: 1000
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/uros_sipetic/rsem:1.2.31
  dockerImageId: 67d3a6c01e92210f43c8ef809c2a245a75bf7d5a52762823cdc3b2e784de576c
id: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/rsem-plot-model/1
appUrl: /public/apps/#tool/admin/sbg-public-data/rsem-plot-model-1-2-31/5
description: |-
  RSEM Plot Model generates plots for visualising the model learned by RSEM. The plots depend on read type and user configuration and may include fragment length distribution, read length distribution, read start position distribution, quality score vs observed quality given a reference base, position vs percentage of sequencing error given a reference base, and histogram of reads with different number of alignments.

  ###Common issues###
  None
sbg:appVersion:
- sbg:draft-2
sbg:categories:
- Plotting-and-Rendering
- RNA
sbg:cmdPreview: |-
  tar -xf input_files.ext && rsem-plot-model  sample_name  sample_name_plot_model.pdf
sbg:contributors:
- jelena_randjelovic
sbg:createdBy: jelena_randjelovic
sbg:createdOn: 1538394629
sbg:id: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/rsem-plot-model/1
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 1
    mem: 1000
  inputs:
    rsem_calculate_expression_archive:
      class: File
      secondaryFiles: []
      metadata:
        sample_name: sample_name
      path: /path/to/input_files.ext
      size: 0
sbg:latestRevision: 1
sbg:license: GNU General Public License v3.0 only
sbg:links:
- id: http://deweylab.github.io/RSEM/
  label: RSEM Homepage
- id: https://github.com/deweylab/RSEM
  label: RSEM Source Code
- id: https://github.com/deweylab/RSEM/archive/v1.2.31.tar.gz
  label: RSEM Download
- id: https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-12-323
  label: RSEM Publications
- id: http://deweylab.github.io/RSEM/README.html
  label: RSEM Documentation
sbg:modifiedBy: jelena_randjelovic
sbg:modifiedOn: 1538401718
sbg:project: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow
sbg:projectName: PDXnet - Polishing JAX RNA-seq workflow
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: c4.2xlarge 200 GB storage
sbg:revisionsInfo:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538394629
  sbg:revision: 0
  sbg:revisionNotes: Updated description.
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538401718
  sbg:revision: 1
  sbg:revisionNotes: c4.2xlarge 200 GB storage
sbg:sbgMaintained: false
sbg:toolAuthor: Bo Li, Colin Dewey
sbg:toolkit: RSEM
sbg:toolkitVersion: 1.2.31
sbg:validationErrors: []
x: 1138.4319051106777
y: 562.2112274169925
