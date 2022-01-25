cwlVersion: sbg:draft-2
class: CommandLineTool
label: QC Integrate RNA
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
      #!/usr/bin/perl
      use strict;
      use warnings;

      open(FILEIN1, $ARGV[0]) || die "cannot open the $ARGV[0]";####Xenome Report
      open(FILEIN2, $ARGV[1]) || die "cannot open the $ARGV[1]";####Picard Report

      my $flag = 0;

      while(my $readFile1 = <FILEIN1>)
      {
       if(($readFile1 =~ /^\s*count.*?percent.*?class.*$/) && ($flag == 0))
       {
          $flag = 1;
          print "####Xenome Report####\n";
          print "####$readFile1";
          next;
       }
       elsif($flag == 1)
       {

         print "$readFile1";

       }

      }

       $flag = 0;

      my @header = ();

      while(my $readFile2 = <FILEIN2>)
      {
       if(($readFile2 =~ /^## METRICS CLASS/) && ($flag == 0))
       {
          $flag = 1;
          print "\n\n####Picard CollectRnaSeqMetrics Report####\n";
          #print "$#header\n";
          #print "$readFile2";
          next;
       }
       elsif($flag == 1)
       {
         chomp $readFile2;
         @header = split("\t", $readFile2);
         $flag = 2;
         next;
       }
       elsif($flag == 2)
       {
      my $i= 0;
          my @array = split("\t", $readFile2);

          for(; $i <=$#array-4; $i++)
          {
             print "$header[$i]\t$array[$i]\n";

          }
          if($i == $#array-3)
          {
            chomp $header[$i];
            print "$header[$i]\t$array[$i]\n"
          }

      $flag = 3;
       }

      }
    filename: QC_report.pl
- class: InlineJavascriptRequirement

inputs:
- id: '#XenomeReport'
  label: QC Integrate RNA
  type:
  - File
  inputBinding:
    position: 1
    separate: true
    sbg:cmdInclude: true
  required: true
- id: '#PicardCollectRNASeqMetrics'
  type:
  - File
  inputBinding:
    position: 2
    separate: true
    sbg:cmdInclude: true
  required: true

outputs:
- id: '#integrated_QC_report'
  label: Integrated QC report
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.Integrated.QC.report.txt'
    sbg:inheritMetadataFrom: '#XenomeReport'
  description: Integrated QC report.
  sbg:fileTypes: TXT

baseCommand:
- perl
- QC_report.pl
arguments:
- position: 10
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        if (($job.inputs.XenomeReport.metadata) && ($job.inputs.XenomeReport.metadata['sample_id']))
        {
          return " > ".concat($job.inputs.XenomeReport.metadata['sample_id'], ".Integrated.QC.report.txt")
        }
        else
        {
          return " > Sample.Integrated.QC.report.txt"
        }
      }
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
id: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/qc-integrate-rna/1
appUrl: |-
  /u/anuj_srivastava/rna-expression-estimation/apps/#anuj_srivastava/rna-expression-estimation/integrate-qc-report/1
sbg:appVersion:
- sbg:draft-2
sbg:cmdPreview: |-
  perl QC_report.pl  /path/to/StatsFIle.ext  /path/to/PicardMarkDupReport.ext   > Sample.Integrated.QC.report.txt
sbg:contributors:
- jelena_randjelovic
sbg:createdBy: jelena_randjelovic
sbg:createdOn: 1538394631
sbg:id: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/qc-integrate-rna/1
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 1
    mem: 1000
  inputs:
    PicardCollectRNASeqMetrics:
      class: File
      secondaryFiles: []
      path: /path/to/PicardMarkDupReport.ext
      size: 0
    XenomeReport:
      class: File
      secondaryFiles: []
      path: /path/to/StatsFIle.ext
      size: 0
sbg:latestRevision: 1
sbg:modifiedBy: jelena_randjelovic
sbg:modifiedOn: 1538401500
sbg:project: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow
sbg:projectName: PDXnet - Polishing JAX RNA-seq workflow
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: c4.2 100GB storage, dynamic output naming
sbg:revisionsInfo:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538394631
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538401500
  sbg:revision: 1
  sbg:revisionNotes: c4.2 100GB storage, dynamic output naming
sbg:sbgMaintained: false
sbg:validationErrors: []
successCodes:
- 0
x: 1288.1376139322924
y: 303.05779774983745
