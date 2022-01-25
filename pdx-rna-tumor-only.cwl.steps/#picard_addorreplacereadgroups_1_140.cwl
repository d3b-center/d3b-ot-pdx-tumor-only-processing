cwlVersion: sbg:draft-2
class: CommandLineTool
label: Picard AddOrReplaceReadGroups
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- id: '#cwl-js-engine'
  class: ExpressionEngineRequirement
  requirements:
  - class: DockerRequirement
    dockerPull: rabix/js-engine
  engineCommand: cwl-engine.js
- class: InlineJavascriptRequirement

inputs:
- id: '#input_bam'
  label: Input
  type:
  - File
  - type: array
    items: File
  inputBinding:
    prefix: INPUT=
    position: 1
    separate: false
    sbg:cmdInclude: true
  description: Input file (bam or sam or a GA4GH url).
  sbg:altPrefix: I
  sbg:category: File inputs
  sbg:fileTypes: BAM
- id: '#read_group_predicted_insert_size'
  label: Read group predicted insert size
  type:
  - 'null'
  - int
  inputBinding:
    prefix: RGPI=
    position: 4
    separate: false
    sbg:cmdInclude: true
  description: Read group predicted insert size.
  sbg:altPrefix: PI
  sbg:category: Options
- id: '#read_group_run_date'
  label: Read group run date
  type:
  - 'null'
  - string
  inputBinding:
    prefix: RGDT=
    position: 4
    separate: false
    sbg:cmdInclude: true
  description: Read group run date.
  sbg:altPrefix: DT
  sbg:category: Options
- id: '#read_group_decription'
  label: Read group description
  type:
  - 'null'
  - string
  inputBinding:
    prefix: RGDS=
    position: 4
    separate: false
    sbg:cmdInclude: true
  description: Read group description.
  sbg:altPrefix: DS
  sbg:category: Options
- id: '#read_group_center_name'
  label: Read group sequencing center name
  type:
  - 'null'
  - string
  inputBinding:
    prefix: RGCN=
    position: 4
    separate: false
    sbg:cmdInclude: true
  description: Read group sequencing center name.
  sbg:altPrefix: CN
  sbg:category: Options
- id: '#read_group_platform_unit'
  label: Read group platform unit
  type:
  - string
  inputBinding:
    prefix: RGPU=
    position: 4
    separate: false
    sbg:cmdInclude: true
  description: Read group platform unit (eg. run barcode).
  sbg:altPrefix: PU
  sbg:category: Options
- id: '#read_group_platform'
  label: Read group platform
  type:
  - string
  inputBinding:
    prefix: RGPL=
    position: 4
    separate: false
    sbg:cmdInclude: true
  description: Read group platform (e.g. illumina, Solid).
  sbg:altPrefix: PL
  sbg:category: Options
- id: '#read_group_lib'
  label: Read group library
  type:
  - string
  inputBinding:
    prefix: RGLB=
    position: 4
    separate: false
    sbg:cmdInclude: true
  description: Read group library.
  sbg:altPrefix: LB
  sbg:category: Options
- id: '#read_group_id'
  label: Read Group ID
  type:
  - 'null'
  - string
  inputBinding:
    prefix: RGID=
    position: 3
    separate: false
    sbg:cmdInclude: true
  description: This parameter indicates the read group ID.
  sbg:altPrefix: ID
  sbg:category: Options
  sbg:toolDefaultValue: '1'
- id: '#output_type'
  label: Output format
  type:
  - 'null'
  - name: output_type
    type: enum
    symbols:
    - BAM
    - SAM
    - SAME AS INPUT
  description: |-
    Since Picard tools can output both SAM and BAM files, user can choose the format of the output file.
  sbg:category: Options
  sbg:toolDefaultValue: SAME AS INPUT
- id: '#sort_order'
  label: Sort order
  type:
  - 'null'
  - name: sort_order
    type: enum
    symbols:
    - unsorted
    - queryname
    - coordinate
  inputBinding:
    prefix: SORT_ORDER=
    position: 3
    separate: false
    sbg:cmdInclude: true
  description: |-
    This optional parameter indicates the sort order for the output. If not supplied OUTPUT is in the same order as INPUT. Possible values: {unsorted, queryname, coordinate, duplicate}.
  sbg:altPrefix: SO
  sbg:category: Options
- id: '#create_index'
  label: Create index
  type:
  - 'null'
  - name: create_index
    type: enum
    symbols:
    - 'True'
    - 'False'
  inputBinding:
    prefix: CREATE_INDEX=
    position: 5
    separate: false
    sbg:cmdInclude: true
  description: |-
    This parameter indicates whether to create a BAM index when writing a coordinate-sorted BAM file. Default value: False. This option can be set to 'null' to clear the default value. Possible values: {True, False}.
  sbg:category: Options
  sbg:toolDefaultValue: 'False'
- id: '#quiet'
  label: Quiet
  type:
  - 'null'
  - name: quiet
    type: enum
    symbols:
    - 'True'
    - 'False'
  inputBinding:
    prefix: QUIET=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    This parameter indicates whether to suppress job-summary info on System.err. Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false}.
  sbg:category: Options
  sbg:toolDefaultValue: 'False'
- id: '#validation_stringency'
  label: Validation stringency
  type:
  - 'null'
  - name: validation_stringency
    type: enum
    symbols:
    - STRICT
    - LENIENT
    - SILENT
  inputBinding:
    prefix: VALIDATION_STRINGENCY=
    position: 0
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.validation_stringency)
          {
            return $job.inputs.validation_stringency
          }
          else
          {
            return "SILENT"
          }
        }
    separate: false
    sbg:cmdInclude: true
  description: |-
    Validation stringency for all SAM files read by this program. Setting stringency to SILENT can improve performance when processing a BAM file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded. Default value: STRICT. This option can be set to 'null' to clear the default value. Possible values: {STRICT, LENIENT, SILENT}.
  sbg:category: Options
  sbg:toolDefaultValue: SILENT
- id: '#compression_level'
  label: Compression level
  type:
  - 'null'
  - int
  inputBinding:
    prefix: COMPRESSION_LEVEL=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    Compression level for all compressed files created (e.g. BAM and GELI). Default value: 5. This option can be set to 'null' to clear the default value.
  sbg:category: Options
  sbg:toolDefaultValue: '5'
- id: '#max_records_in_ram'
  label: Max records in RAM
  type:
  - 'null'
  - int
  inputBinding:
    prefix: MAX_RECORDS_IN_RAM=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: |-
    When writing SAM files that need to be sorted, this parameter will specify the number of records stored in RAM before spilling to disk. Increasing this number reduces the number of file handles needed to sort a SAM file, and increases the amount of RAM needed. Default value: 500000. This option can be set to 'null' to clear the default value.
  sbg:category: Options
  sbg:toolDefaultValue: '500000'
- id: '#memory_per_job'
  label: Memory per job
  type:
  - 'null'
  - int
  description: |-
    Amount of RAM memory to be used per job. Defaults to 2048 MB for single threaded jobs.
  sbg:category: Execution options
  sbg:toolDefaultValue: '2048'
- id: '#read_group_program_group'
  label: Read group program group
  type:
  - 'null'
  - string
  inputBinding:
    prefix: RGPG=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: Read group program group.
  sbg:altPrefix: PG
  sbg:category: Options
- id: '#read_group_platform_model'
  label: Read group platform model
  type:
  - 'null'
  - string
  inputBinding:
    prefix: RGPM=
    position: 0
    separate: false
    sbg:cmdInclude: true
  description: Read group platform model.
  sbg:altPrefix: PM
  sbg:category: Options

outputs:
- id: '#edited_bam'
  label: Edited BAM
  type:
  - 'null'
  - File
  outputBinding:
    secondaryFiles:
    - ^.bai
    - .bai
    glob: '*.edited.?am'
    sbg:inheritMetadataFrom: '#input_bam'
    sbg:metadata:
      __inherit__: input_file
  description: Output file (BAM or SAM).
  sbg:fileTypes: BAM, SAM

baseCommand:
- java
- class: Expression
  engine: '#cwl-js-engine'
  script: |-
    {   
      if($job.inputs.memory_per_job){
        return '-Xmx'.concat($job.inputs.memory_per_job, 'M')
      }   
      	return '-Xmx2048M'
    }
- -jar
- /opt/picard-tools-1.140/picard.jar
- AddOrReplaceReadGroups
arguments:
- prefix: OUTPUT=
  position: 0
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        if ($job.inputs.input_bam) 
        {
        filename = $job.inputs.input_bam.path
        ext = $job.inputs.output_type
        filebase = filename.split('.').slice(0, -1)

      if (ext === "BAM")
      {
          return filebase.concat("edited.bam").join(".").replace(/^.*[\\\/]/, '')
          }

      else if (ext === "SAM")
      {
          return filebase.concat("edited.sam").join('.').replace(/^.*[\\\/]/, '')
      }

      else 
      {
      	return filebase.concat("edited."+filename.split('.').slice(-1)[0]).join(".").replace(/^.*[\\\/]/, '')
      }
        }
      }
  separate: false
- position: 1000
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        filename = $job.inputs.input_bam.path
        
        /* figuring out output file type */
        ext = $job.inputs.output_type
        if (ext === "BAM")
        {
          out_extension = "BAM"
        }
        else if (ext === "SAM")
        {
          out_extension = "SAM"
        }
        else 
        {
      	out_extension = filename.split('.').slice(-1)[0].toUpperCase()
        }  
        
        /* if exist moving .bai in bam.bai */
        if ($job.inputs.create_index === 'True' && ($job.inputs.sort_order === 'coordinate' || typeof($job.inputs.sort_order) === "undefined") && out_extension == "BAM")
        {
          
          old_name = filename.split('.').slice(0, -1).concat('edited.bai').join('.').replace(/^.*[\\\/]/, '')
          new_name = filename.split('.').slice(0, -1).concat('edited.bam.bai').join('.').replace(/^.*[\\\/]/, '')
          return "; mv " + " " + old_name + " " + new_name
        }

      }
  separate: true
- prefix: RGSM=
  position: 4
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
          filename = $job.inputs.input_bam.path.split('/').pop()
          primename = filename.split('.bam')[0]
          return primename
      }
  separate: true

hints:
- class: sbg:CPURequirement
  value: 1
- class: sbg:MemRequirement
  value:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        if($job.inputs.memory_per_job){
        	return $job.inputs.memory_per_job
        }
        	return 2048
      }
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/mladenlsbg/picard:1.140
  dockerImageId: eab0e70b6629
id: michael_lloyd/sample-and-cohort-level-qc/picard-addorreplacereadgroups-1-140/0
description: |-
  Picard AddOrReplaceReadGroups replaces all read groups in the input file with a single new read group and assigns all reads to this read group in the output BAM file (*.bam).
sbg:appVersion:
- sbg:draft-2
sbg:categories:
- SAM/BAM-Processing
sbg:cmdPreview: |-
  java -Xmx2048M -jar /opt/picard-tools-1.140/picard.jar AddOrReplaceReadGroups OUTPUT=example.edited.bam INPUT=/root/dir/example.bam
sbg:content_hash: a1afb5a881157a9622d20f4c732e2f12abdb9a08337006e29113984e6fb68dea2
sbg:contributors:
- michael_lloyd
sbg:copyOf: michael_lloyd/mantis/picard-addorreplacereadgroups-1-140/5
sbg:createdBy: michael_lloyd
sbg:createdOn: 1578496032
sbg:id: michael_lloyd/sample-and-cohort-level-qc/picard-addorreplacereadgroups-1-140/0
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 1
    mem: 2048
  inputs:
    create_index:
    input_bam:
      path: /root/dir/example.bam
    output_type: SAME AS INPUT
    read_group_platform_model: read_group_platform_model
    read_group_program_group: read_group_program_group
    sort_order:
sbg:latestRevision: 0
sbg:license: MIT License, Apache 2.0 Licence
sbg:links:
- id: http://broadinstitute.github.io/picard/
  label: Homepage
- id: https://github.com/broadinstitute/picard/releases/tag/1.140
  label: Source Code
- id: http://broadinstitute.github.io/picard/
  label: Wiki
- id: https://github.com/broadinstitute/picard/zipball/master
  label: Download
- id: http://broadinstitute.github.io/picard/
  label: Publication
sbg:modifiedBy: michael_lloyd
sbg:modifiedOn: 1578496032
sbg:project: michael_lloyd/sample-and-cohort-level-qc
sbg:projectName: Sample and Cohort Level QC
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: Copy of michael_lloyd/mantis/picard-addorreplacereadgroups-1-140/5
sbg:revisionsInfo:
- sbg:modifiedBy: michael_lloyd
  sbg:modifiedOn: 1578496032
  sbg:revision: 0
  sbg:revisionNotes: Copy of michael_lloyd/mantis/picard-addorreplacereadgroups-1-140/5
sbg:sbgMaintained: false
sbg:toolAuthor: Broad Institute
sbg:toolkit: Picard
sbg:toolkitVersion: '1.140'
sbg:validationErrors: []
