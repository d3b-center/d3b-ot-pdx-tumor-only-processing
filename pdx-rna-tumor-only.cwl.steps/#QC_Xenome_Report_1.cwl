cwlVersion: sbg:draft-2
class: CommandLineTool
label: QC Xenome Check
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
      use strict;
      use warnings;


      open(FILEIN1, $ARGV[0]) || die "cannot open the $ARGV[0]";

      my $flag = 0;
      my $humanCount = 0;
      my $humanPercentage;

      while(my $readFile = <FILEIN1>)
      {
       if(($readFile =~ /^\s*count.*?percent.*?class.*$/) && ($flag == 0))
       {
          $flag = 1;
          next;
       }
       elsif($flag == 1)
       {
         chomp $readFile;

         if($readFile =~ /^\s*(.*?)\s+(.*?)\s+.*$/)
         {
           $humanCount = $1;
           $humanPercentage = $2;

         }
        last;
       }
      }

      if($humanCount < $ARGV[1])
      {
        die "Total number of human reads is less than given cut-off of $ARGV[1] : The human reads are $humanCount.\n";
      }

      elsif($humanCount >= $ARGV[1])
      {
        print "QC Genome Report Passed \n";
      }
    filename: QC_Xenome.pl
- class: InlineJavascriptRequirement

inputs:
- id: '#stats_file'
  label: Xenome stats file
  type:
  - File
  inputBinding:
    position: 1
    separate: true
    sbg:cmdInclude: true
  description: Xenome stats file.
  required: true
- id: '#ReadTotal'
  label: Minimum number of human-specific reads
  type:
  - 'null'
  - int
  inputBinding:
    position: 2
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        { 
          if ($job.inputs.ReadTotal)
          {
            return $job.inputs.ReadTotal
          }
         else
         {
           return 1000000
         }
        }
    separate: true
    sbg:cmdInclude: true
  description: Number of human-specific reads from Xenome (default is 1M paired-end
    reads).
  sbg:toolDefaultValue: '1000000'

outputs:
- id: '#integrated_QC_report'
  label: Integrated QC report
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.Integrated.QC.report.txt'
    sbg:inheritMetadataFrom: '#stats_file'
  description: Integrated QC report.
  sbg:fileTypes: TXT
- id: '#error_log'
  label: Error logs
  type:
  - 'null'
  - type: array
    items: File
  outputBinding:
    glob: '*.log'
    outputEval:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {n=false;e=0;j=0;for(i in $self){if($self[i].path.includes('exit_code.log'))e=i;if ($self[i].path.includes('job.err.log'))j=i;};if(!(parseInt($self[e].contents) === 0))n=true;if(n==true){s='\n\n#####     ERROR!     #####\n';throw s + $self[j].contents};return $self;}
    loadContents: true
  description: Exit code log and error log
  sbg:fileTypes: LOG

baseCommand:
- perl
- QC_Xenome.pl
arguments:
- prefix: ''
  position: 3
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        if (($job.inputs.stats_file.metadata) && ($job.inputs.stats_file.metadata['sample_id']))
        {
          return " > ".concat($job.inputs.stats_file.metadata['sample_id'], ".Integrated.QC.report.txt")
        }
        else
        {
          return " > Sample.Integrated.QC.report.txt"
        }
      }
  separate: true
- prefix: ;
  position: 10
  valueFrom: echo $? > exit_code.log
  separate: true

hints:
- class: sbg:AWSInstanceType
  value: c4.2xlarge;ebs-gp2;100
- class: sbg:CPURequirement
  value: 1
- class: sbg:MemRequirement
  value: 1000
- class: DockerRequirement
  dockerPull: perl
id: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/qc-xenome-report-1/1
sbg:appVersion:
- sbg:draft-2
sbg:cmdPreview: |-
  perl QC_Xenome.pl  /path/to/xenome_stats_file.ext   > test_sample_id.Integrated.QC.report.txt ; echo $? > exit_code.log
sbg:contributors:
- jelena_randjelovic
sbg:createdBy: jelena_randjelovic
sbg:createdOn: 1538394637
sbg:id: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/qc-xenome-report-1/1
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 1
    mem: 1000
  inputs:
    ReadTotal: 3
    stats_file:
      class: File
      secondaryFiles: []
      metadata:
        sample_id: test_sample_id
      path: /path/to/xenome_stats_file.ext
      size: 0
sbg:latestRevision: 1
sbg:modifiedBy: jelena_randjelovic
sbg:modifiedOn: 1538401183
sbg:project: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow
sbg:projectName: PDXnet - Polishing JAX RNA-seq workflow
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: |-
  dynamic output naming, instance c4.2 with 100 GB storage, inherit metadata from input, input id changed
sbg:revisionsInfo:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538394637
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538401183
  sbg:revision: 1
  sbg:revisionNotes: |-
    dynamic output naming, instance c4.2 with 100 GB storage, inherit metadata from input, input id changed
sbg:sbgMaintained: false
sbg:validationErrors: []
successCodes:
- 0
x: 850.0002034505213
y: 483.33343505859403
