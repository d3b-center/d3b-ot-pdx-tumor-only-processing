cwlVersion: sbg:draft-2
class: CommandLineTool
label: SBG Decompressor
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
- id: '#input_archive_file'
  label: Input archive file
  type:
  - File
  inputBinding:
    position: 0
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          var available_ext = ['tar', 'tar.gz', 'tgz', 'tar.bz2', 'tbz2', 'gz', 'bz2', 'zip']
          var file = $job.inputs.input_archive_file.path.toLowerCase()
          if (available_ext.indexOf(file.split('.').pop()) > -1) { 
          	return '--input_archive_file ' + $job.inputs.input_archive_file.path
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: The input archive file to be unpacked.
  required: true
  sbg:fileTypes: TAR, TAR.GZ, TGZ, TAR.BZ2, TBZ2, GZ, BZ2, ZIP

outputs:
- id: '#output_files'
  label: Output files
  type:
  - type: array
    items: File
  outputBinding:
    glob:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          var available_ext = ['tar', 'tar.gz', 'tgz', 'tar.bz2', 'tbz2', 'gz', 'bz2', 'zip']
          var file = $job.inputs.input_archive_file.path.toLowerCase()
          if (available_ext.indexOf(file.split('.').pop()) > -1) { 
            return 'decompressed_files/!(*.meta)'
          }
          else {
            return $job.inputs.input_archive_file.path
          }
        }
    sbg:inheritMetadataFrom: '#input_archive_file'
  description: Unpacked files from the input archive.

baseCommand:
- class: Expression
  engine: '#cwl-js-engine'
  script: |-
    {
      var available_ext = ['tar', 'tar.gz', 'tgz', 'tar.bz2', 'tbz2', 'gz', 'bz2', 'zip']
      var file = $job.inputs.input_archive_file.path.toLowerCase()
      if (available_ext.indexOf(file.split('.').pop()) > -1) { 
        return 'python /opt/sbg_decompressor.py'
      }
    }
arguments:
- position: 1
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        var available_ext = ['tar', 'tar.gz', 'tgz', 'tar.bz2', 'tbz2', 'gz', 'bz2', 'zip']
        var file = $job.inputs.input_archive_file.path.toLowerCase()
        if (available_ext.indexOf(file.split('.').pop()) > -1) { 
        	return "; find ./decompressed_files -mindepth 2 -type f -exec mv -i '{}' ./decompressed_files ';'; mkdir ./decompressed_files/dummy_to_delete ;rm -R -- ./decompressed_files/*/ "
        }
      }
  separate: false

hints:
- class: sbg:CPURequirement
  value: 1
- class: sbg:MemRequirement
  value: 1000
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/markop/sbg-decompressor:1.0
  dockerImageId: 58b79c627f95
id: pdxnet/nci-pdx2/sbg-decompressor-1-0/0
description: |-
  SBG Decompressor performs the extraction of the input archive file. 
  Supported formats are:
  1. TAR
  2. TAR.GZ (TGZ)
  3. TAR.BZ2 (TBZ2)
  4. GZ
  5. BZ2
  6. ZIP

  If the archive contains folder structure, it is going to be flatten because CWL doesn't support folders at the moment. In that case the output would contain all the files from all the folders from the archive.
sbg:appVersion:
- sbg:draft-2
sbg:categories:
- Other
sbg:cmdPreview: |-
  python /opt/sbg_decompressor.py  --input_archive_file input_file.tar ; find ./decompressed_files -mindepth 2 -type f -exec mv -i '{}' ./decompressed_files ';'; mkdir ./decompressed_files/dummy_to_delete ;rm -R -- ./decompressed_files/*/
sbg:content_hash: a4d9b7ff86d6a6686b12886d40416a9d7db9159ec306800d40bb44c0773940fb3
sbg:contributors:
- michael_lloyd
sbg:copyOf: admin/sbg-public-data/sbg-decompressor-1-0/5
sbg:createdBy: michael_lloyd
sbg:createdOn: 1552075948
sbg:homepage: https://igor.sbgenomics.com/
sbg:id: pdxnet/nci-pdx2/sbg-decompressor-1-0/0
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 1
    mem: 1000
  inputs:
    input_archive_file:
      class: File
      secondaryFiles: []
      path: input_file.tar
      size: 0
sbg:latestRevision: 0
sbg:license: Apache License 2.0
sbg:modifiedBy: michael_lloyd
sbg:modifiedOn: 1552075948
sbg:project: pdxnet/nci-pdx2
sbg:projectName: NCI_PDX2
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: Copy of admin/sbg-public-data/sbg-decompressor-1-0/5
sbg:revisionsInfo:
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1552075948
  sbg:revision: 0
  sbg:revisionNotes: Copy of admin/sbg-public-data/sbg-decompressor-1-0/5
sbg:sbgMaintained: false
sbg:toolAuthor: Marko Petkovic, Seven Bridges Genomics
sbg:toolkit: SBGTools
sbg:toolkitVersion: v1.0
sbg:validationErrors: []
x: 371.6666803757352
y: 340.0000017616486
