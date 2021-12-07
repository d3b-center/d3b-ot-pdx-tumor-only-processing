cwlVersion: sbg:draft-2
class: CommandLineTool
label: RSEM Calculate Expression
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
- id: '#time'
  label: Time
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --time
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Output time consumed by each step of RSEM to 'sample_name.time'.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: off
- id: '#tag'
  label: Tag name
  type:
  - 'null'
  - string
  inputBinding:
    prefix: --tag
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    The name of the optional field used in the SAM input for identifying a read with too many valid alignments. The field should have the format <tagName>:i:<value>, where a <value> bigger than 0 indicates a read with too many alignments.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: None
- id: '#strand_specific'
  label: Strand specific
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --strand-specific
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    The RNA-Seq protocol used to generate the reads is strand specific, i.e. all (upstream) reads are derived from the forward strand. With this option set, if RSEM runs the Bowtie/Bowtie 2 aligner, the '--norc' Bowtie/Bowtie 2 option will be used, which disables alignment to the reverse strand of transcripts.
  required: false
  sbg:category: Basic options
  sbg:toolDefaultValue: off
- id: '#star_output_genome_bam'
  label: Output STAR genome BAM
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --star-output-genome-bam
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    (STAR parameter) Save the BAM file from STAR alignment under genomic coordinate to 'sample_name.STAR.genome.bam'. This file is NOT sorted by genomic coordinate. In this file, according to STAR's manual, 'paired ends of an alignment are always adjacent, and multiple alignments of a read are adjacent as well'.
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: off
- id: '#star'
  label: STAR
  type:
  - 'null'
  - boolean
  inputBinding:
    position: 0
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        { 
          var arr = [].concat($job.inputs.read_files)
          var ext = arr[0].path.split('.').pop().toLowerCase()

          if (ext=='bam' || ext=='sam' || ext=='cram') {
            return ""
          } else if ($job.inputs.star) {
            return "--star"
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: |-
    Use STAR to align reads. Alignment parameters are from ENCODE3's STAR-RSEM pipeline. To save computational time and memory resources, STAR's Output BAM file is unsorted. It is stored in RSEM's temporary directory with the name as 'sample_name.bam'. Each STAR job will have its own private copy of the genome in memory.
  required: false
  sbg:category: Basic options
  sbg:toolDefaultValue: off
- id: '#sort_bam_by_read_name'
  label: Sort BAM by read name
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --sort-bam-by-read-name
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Sort BAM file aligned under transcript coordidate by read name. Setting this option on will produce determinstic maximum likelihood estimations from independet runs. Note that sorting will take long time and lots of memory.
  required: false
  sbg:category: Output options
  sbg:toolDefaultValue: off
- id: '#sort_bam_by_coordinate'
  label: Sort BAM by coordinate
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --sort-bam-by-coordinate
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Sort RSEM generated transcript and genome BAM files by coordinates and build associated indices.
  required: false
  sbg:category: Output options
  sbg:toolDefaultValue: off
- id: '#solexa_quals'
  label: Solexa qualities
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --solexa-quals
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Input quality scores are solexa encoded.
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: off
- id: '#single_cell_prior'
  label: Single cell prior
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --single-cell-prior
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    By default, RSEM uses Dirichlet(1) as the prior to calculate posterior mean estimates and credibility intervals. However, much less genes are expressed in single cell RNA-Seq data. Thus, if you want to compute posterior mean estimates and/or credibility intervals and you have single-cell RNA-Seq data, you are recommended to turn on this option. RSEM will then use Dirichlet(0.1) as the prior which encourage the sparsity of the expression levels.
  required: false
  sbg:category: Basic options
  sbg:toolDefaultValue: off
- id: '#seed_length'
  label: Seed length
  type:
  - 'null'
  - int
  inputBinding:
    prefix: -seed-length
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Seed length used by the read aligner.  Providing the correct value is important for RSEM. If RSEM runs Bowtie, it uses this value for Bowtie's seed length parameter. Any read with its or at least one of its mates' (for paired-end reads) length less than this value will be ignored. If the references are not added poly(A) tails, the minimum allowed value is 5, otherwise, the minimum allowed value is 25.
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: '25'
- id: '#seed'
  label: Random number generator seed
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --seed
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Set the seed for the random number generators used in calculating posterior mean estimates and credibility intervals. The seed must be a non-negative 32 bit interger.
  required: false
  sbg:category: Basic options
  sbg:toolDefaultValue: off
- id: '#sampling_for_bam'
  label: Sampling for BAM
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --sampling-for-bam
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    When RSEM generates a BAM file, instead of outputing all alignments a read has with their posterior probabilities, one alignment is sampled according to the posterior probabilities. The sampling procedure includes the alignment to the "noise" transcript, which does not appear in the BAM file. Only the sampled alignment has a weight of 1. All other alignments have the weight of 0. If the "noise" transcript is sampled, all alignments appeared in the BAM file should have weight 0.
  required: false
  sbg:category: Output options
  sbg:toolDefaultValue: off
- id: '#rsem_prepare_reference_archive'
  label: Archive of all files outputed by RSEM prepare reference
  type:
  - File
  description: |-
    Bundle of files outputed by RSEM prepare reference, including (if specified) Bowtie/Bowtie2/STAR indices.
  required: true
  sbg:fileTypes: TAR
  sbg:stageInput: link
- id: '#read_files'
  label: Read files
  type:
  - 'null'
  - type: array
    items: File
  inputBinding:
    position: 98
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.read_files) {
           
          function get_meta_map(m, file, meta) {
            if (meta in file.metadata) {
              return m[file.metadata[meta]]
            } else {
              return m['Undefined']
            }
          }

          function create_new_map(map, file, meta) {
            if (meta in file.metadata) {
              map[file.metadata[meta]] = {}
              return map[file.metadata[meta]]
            } else {
              map['Undefined'] = {}
              return map['Undefined']
            }
          }
            
          var list = [].concat($job.inputs.read_files)
          var ext = list[0].path.split('.').pop().toLowerCase()
          
          if (ext=='bam' || ext=='sam' || ext=='cram') {
            if ($job.inputs.paired_end_alignment) {
              return "--alignments --paired-end " + list[0].path
            } else {
              return "--alignments " + list[0].path
            }
          }
            
            
          if ($job.inputs.star && ext=='gz') {
            var zip_pref = "--star-gzipped-read-file "
          } else if ($job.inputs.star && ext=='bz2') {
            var zip_pref = "--star-bzipped-read-file "
          } else {
            var zip_pref = ""
          }
          
          arr = list
            map = {}
            
            if (arr.length==1) {
              return zip_pref + arr[0].path
            }

            for (i in arr) {

                sm_map = get_meta_map(map, arr[i], 'sample_id')
                if (!sm_map) sm_map = create_new_map(map, arr[i], 'sample_id')

                lb_map = get_meta_map(sm_map, arr[i], 'library_id')
                if (!lb_map) lb_map = create_new_map(sm_map, arr[i], 'library_id')

                pu_map = get_meta_map(lb_map, arr[i], 'platform_unit_id')
                if (!pu_map) pu_map = create_new_map(lb_map, arr[i], 'platform_unit_id')

                if ('file_segment_number' in arr[i].metadata) {
                    if (pu_map[arr[i].metadata['file_segment_number']]) {
                        a = pu_map[arr[i].metadata['file_segment_number']]
                        ar = [].concat(a)
                        ar = ar.concat(arr[i])
                        pu_map[arr[i].metadata['file_segment_number']] = ar
                    } else pu_map[arr[i].metadata['file_segment_number']] = [].concat(arr[i])
                } else {
                    if (pu_map['Undefined']) {
                        a = pu_map['Undefined']
                        ar = [].concat(a)
                        ar = ar.concat(arr[i])
                        pu_map['Undefined'] = ar
                    } else {
                        pu_map['Undefined'] = [].concat(arr[i])
                    }
                }
            }
            tuple_list = []
            for (sm in map)
                for (lb in map[sm])
                    for (pu in map[sm][lb]) {
                        list = []
                        for (fsm in map[sm][lb][pu]){
                            list = map[sm][lb][pu][fsm]
                        	tuple_list.push(list)
                        }
                    }
            
          pe_1 = []
          pe_2 = []
          se = []

          if (tuple_list[0].length==1) {
            for (i=0; i<tuple_list.length; i++) {
              se = se.concat(tuple_list[i][0].path)
            }
          }
          for (i=0; i<tuple_list.length; i++) {
            for (j=0; j<tuple_list[i].length; j++) {
              if (tuple_list[i][j].metadata.paired_end==1) {
                pe_1 = pe_1.concat(tuple_list[i][j].path)
              } else if (tuple_list[i][j].metadata.paired_end==2) {
                pe_2 = pe_2.concat(tuple_list[i][j].path)
              }
            }
          }
          
          //return tuple_list
          //return pe_1
          
          if(pe_2.length == 0){
              if (se.length > 0) {
                tmp = se
              } else if (pe_1.length > 0) {
                tmp = pe_1
              }
              return zip_pref + tmp
          	} else if (pe_2.length > 0) {
              return zip_pref + "--paired-end " + pe_1 + " " + pe_2
            } else {
              return ""
            }
          }
          
        }
    separate: true
    itemSeparator: ','
    sbg:cmdInclude: true
  description: |-
    List of files containing single-end or paired-end data. By default, these files are assumed to be in FASTQ format. If 'No qualities' option is set, FASTA format is expected. Also, 'paired-end' metadata field in the input files should be properly set on the platform('1' and '2' for paired end or ' - ' for single end).
  required: false
  sbg:fileTypes: FASTA, FASTQ, FA, FQ, FASTQ.GZ, FQ.GZ, FASTQ.BZ2, FQ.BZ2, BAM, SAM,
    CRAM
- id: '#phred64_quals'
  label: Phred+64 qualities
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --phred64-quals
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Input quality scores are encoded as Phred+64.
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: off
- id: '#phred33_quals'
  label: Phred+33 qualities
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --phred33-quals
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Input quality scores are encoded as Phred+33.
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: on
- id: '#paired_end_alignment'
  label: Paired End Alignment
  type:
  - 'null'
  - boolean
  description: |-
    Specify this option if you are supplying aligned BAM/SAM/CRAM file as input instead of FASTQ reads and your aligned file came from paired end data. For paired-end reads, RSEM also requires the two mates of any alignment to be adjacent.
  required: false
  sbg:category: Basic options
  sbg:toolDefaultValue: off
- id: '#output_genome_bam'
  label: Output genome BAM
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --output-genome-bam
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Generate a BAM file, 'sample_name.genome.bam', with alignments mapped to genomic coordinates and annotated with their posterior probabilities. In addition, RSEM will call samtools (included in RSEM package) to sort and index the bam file. 'sample_name.genome.sorted.bam' and 'sample_name.genome.sorted.bam.bai' will be generated.
  required: false
  sbg:category: Output options
  sbg:toolDefaultValue: off
- id: '#num_rspd_bins'
  label: Number of bins in the RSPD
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --num-rspd-bins
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Only relevant when '-Estimate RSPD' option is specified.  Use of the default setting is recommended.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: '20'
- id: '#no_qualities'
  label: No qualities
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --no-qualities
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Input reads do not contain quality scores.
  required: false
  sbg:category: Basic options
  sbg:toolDefaultValue: off
- id: '#no_bam_output'
  label: No BAM output
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --no-bam-output
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Do not output any BAM file.
  required: false
  sbg:category: Output options
  sbg:toolDefaultValue: off
- id: '#keep_intermediate_files'
  label: Keep temporary files generated by RSEM
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --keep-intermediate-files
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    RSEM creates a temporary directory, 'sample_name.temp', into which it puts all intermediate output files. If this directory already exists, RSEM overwrites all files generated by previous RSEM runs inside of it. By default, after RSEM finishes, the temporary directory is deleted.  Set this option to prevent the deletion of this directory and the intermediate files inside of it.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: off
- id: '#gibbs_sampling_gap'
  label: Gibbs sampling gap
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --gibbs-sampling-gap
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    The number of rounds between two succinct count vectors RSEM collects. If the count vector after round N is collected, the count vector after round N + <inputed_integer> will also be collected.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: '1'
- id: '#gibbs_number_of_samples'
  label: Gibbs number of samples
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --gibbs-number-of-samples
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: The total number of count vectors RSEM will collect from its Gibbs
    samplers.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: '1000'
- id: '#gibbs_burnin'
  label: Gibbs burn-in
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --gibbs-burnin
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    The number of burn-in rounds for RSEM's Gibbs sampler. Each round passes over the entire data set once. If RSEM can use multiple threads, multiple Gibbs samplers will start at the same time and all samplers share the same burn-in number.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: '200'
- id: '#fragment_length_sd'
  label: Fragment length standard deviation
  type:
  - 'null'
  - float
  inputBinding:
    prefix: --fragment-length-sd
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    For single-end data only. The standard deviation of the fragment length distribution, which is assumed to be a Gaussian.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: |-
    0, which assumes that all fragments are of the same length,            given by the rounded value of 'Mean fragment length'
- id: '#fragment_length_min'
  label: Minimum fragment length
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --fragment-length-min
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Minimum read/insert length allowed. This is also the value for the Bowtie/Bowtie2 -I option.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: '1'
- id: '#fragment_length_mean'
  label: Mean fragment length
  type:
  - 'null'
  - float
  inputBinding:
    prefix: --fragment-length-mean
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    For single-end data only. The mean of the fragment length distribution, which is assumed to be a Gaussian.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: -1, which disables use of the fragment length distribution
- id: '#fragment_length_max'
  label: Maximum fragment length
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --fragment-length-max
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Maximum read/insert length allowed. This is also the value for the Bowtie/Bowtie 2 -X option.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: '1000'
- id: '#forward_prob'
  label: Forward probability
  type:
  - 'null'
  - float
  inputBinding:
    prefix: --forward-prob
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Probability of generating a read from the forward strand of a transcript. Set to 1 for a strand-specific protocol where all (upstream) reads are derived from the forward strand, 0 for a strand-specific protocol where all (upstream) read are derived from the reverse strand, or 0.5 for a non-strand-specific protocol.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: '0.5'
- id: '#fai'
  label: SAM header info
  type:
  - 'null'
  - File
  inputBinding:
    prefix: --fai
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    RSEM reads header information from the SAM input by default. If this input is supplied, header information is read from the specified file. For the format of the FAI file, please refer to the SAM official website.
  required: false
  sbg:fileTypes: FAI
- id: '#estimate_rspd'
  label: Estimate RSPD
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --estimate-rspd
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Set this option if you want to estimate the read start position distribution (RSPD) from data. Otherwise, RSEM will use a uniform RSPD.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: off
- id: '#ci_number_of_samples_per_count_vector'
  label: Credibility intervals number of samples per count vector
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --ci-number-of-samples-per-count-vector
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    The number of read generating probability vectors sampled per sampled count vector. The crebility intervals are calculated by first sampling P(C|D) and then sampling P(Theta|C) for each sampled count vector. This option controls how many Theta vectors are sampled per sampled count vector.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: '50'
- id: '#ci_memory'
  label: Credibility intervals memory
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --ci-memory
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Maximum size (in memory, MB) of the auxiliary buffer used for computing credibility intervals (CI).
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: '1024'
- id: '#ci_credibility_level'
  label: Credibility intervals credibility level
  type:
  - 'null'
  - float
  inputBinding:
    prefix: --ci-credibility-level
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: The credibility level for credibility intervals.
  required: false
  sbg:category: Advanced options
  sbg:toolDefaultValue: '0.95'
- id: '#calc_pme'
  label: Calculate posterior mean estimates
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --calc-pme
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Dirichlet(0.1) as the prior which encourage the sparsity of the expression levels.
  required: false
  sbg:category: Basic options
  sbg:toolDefaultValue: off
- id: '#calc_ci'
  label: Calculate credibility intervals
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --calc-ci
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Calculate 95% credibility intervals and posterior mean estimates. The credibility level can be changed in advanced options under 'CI credibility levels'.
  required: false
  sbg:category: Basic options
  sbg:toolDefaultValue: off
- id: '#bowtie_n'
  label: Bowtie N
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --bowtie-n
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: 'Bowtie parameter. Maximum number of mismatches in the seed (Range:
    0-3).'
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: '2'
- id: '#bowtie_m'
  label: Bowtie M
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --bowtie-m
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Bowtie parameter. Suppress all alignments for a read if more than M valid alignments exist.
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: '200'
- id: '#bowtie_e'
  label: Bowtie E
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --bowtie-e
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Bowtie parameter. Maximum sum of mismatch quality scores across the
    alignment.
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: '99999999'
- id: '#bowtie_chunkmbs'
  label: Bowtie chunk MBs
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --bowtie-chunkmbs
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Bowtie parameter. Memory allocated for best first alignment calculation.
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: '0'
- id: '#bowtie2_sensitivity_level'
  label: Bowtie 2 sensitivity level
  type:
  - 'null'
  - string
  inputBinding:
    prefix: --bowtie2-sensitivity-level
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    Bowtie 2 parameter. Set Bowtie 2's preset options in 'end-to-end' mode. This option controls how hard Bowtie 2 tries to find alignments. The input string must be one of "very_fast", "fast", "sensitive" and "very_sensitive".
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: '"sensitive"'
- id: '#bowtie2_mismatch_rate'
  label: Bowtie 2 mismatch rate
  type:
  - 'null'
  - float
  inputBinding:
    prefix: --bowtie2-mismatch-rate
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Bowtie 2 parameter. Maximum mismatch rate allowed.
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: '0.1'
- id: '#bowtie2_k'
  label: Bowtie 2 K
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --bowtie2-k
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: Bowtie 2 parameter. Find up to K alignments per read.
  required: false
  sbg:category: Aligner options
  sbg:toolDefaultValue: '200'
- id: '#bowtie2'
  label: Bowtie 2
  type:
  - 'null'
  - boolean
  inputBinding:
    position: 0
    valueFrom:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        { 
          var arr = [].concat($job.inputs.read_files)
          var ext = arr[0].path.split('.').pop().toLowerCase()

          if (ext=='bam' || ext=='sam' || ext=='cram') {
            return ""
          } else if ($job.inputs.bowtie2) {
            return "--bowtie2"
          }
        }
    separate: true
    sbg:cmdInclude: true
  description: |-
    Use Bowtie 2 instead of Bowtie to align reads. Since currently RSEM does not handle indel, local and discordant alignments, the Bowtie2 parameters are set in a way to avoid those alignments.
  required: false
  sbg:category: Basic options
  sbg:toolDefaultValue: off
- id: '#append_names'
  label: Append names
  type:
  - 'null'
  - boolean
  inputBinding:
    prefix: --append-names
    position: 0
    separate: true
    sbg:cmdInclude: true
  description: |-
    If 'gene_name'/'transcript_name' is available, append it to the end of 'gene_id'/'transcript_id' (separated by '_') in files 'sample_name.isoforms.results' and 'sample_name.genes.results'.
  required: false
  sbg:category: Basic options
  sbg:toolDefaultValue: off

outputs:
- id: '#star_log_files'
  label: STAR log files
  type:
  - 'null'
  - type: array
    items: File
  outputBinding:
    glob: '*.temp/*Log*.out'
    sbg:inheritMetadataFrom: '#read_files'
  description: |-
    Log files produced during STAR alignment. STAR log files are outputted only if 'STAR' option is set and 'Keep Intermediate Files' option is set. These logs are useful for further downstream analysis with tools such as MultiQC.
  sbg:fileTypes: OUT
- id: '#sample_name_transcript_bam'
  label: BAM in transcript coordinates
  type:
  - 'null'
  - File
  outputBinding:
    glob:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.sort_bam_by_coordinate) {
            return "*.transcript.sorted.bam" 
          } else {
            return "*.transcript.bam"
          }
        }
    sbg:inheritMetadataFrom: '#read_files'
    sbg:metadata:
      reference_genome:
        class: Expression
        engine: '#cwl-js-engine'
        script: '[].concat($job.inputs.rsem_prepare_reference_archive)[0].metadata.reference_name'
  description: |-
    BAM file in transcript coordinates. By default this file is unsorted, but it can be sorted if the parameter "Sort BAM by coordinate' is turned on.
  sbg:fileTypes: BAM
- id: '#sample_name_isoforms_results'
  label: Isoform level expression estimates
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.isoforms.results'
    sbg:inheritMetadataFrom: '#read_files'
  description: File containing isoform level expression estimates.
- id: '#sample_name_genome_bam'
  label: BAM in genome coordinates
  type:
  - 'null'
  - File
  outputBinding:
    glob:
      class: Expression
      engine: '#cwl-js-engine'
      script: |-
        {
          if ($job.inputs.sort_bam_by_coordinate) {
            return "*.genome.sorted.bam" 
          } else {
            return "*.genome.bam"
          }
        }
    sbg:inheritMetadataFrom: '#read_files'
    sbg:metadata:
      reference_genome:
        class: Expression
        engine: '#cwl-js-engine'
        script: '[].concat($job.inputs.rsem_prepare_reference_archive)[0].metadata.reference_name'
  description: |-
    BAM file in genome coordinates. By default this file is unsorted, but it can be sorted if the parameter "Sort BAM by coordinate' is turned on.
  sbg:fileTypes: BAM
- id: '#sample_name_genes_results'
  label: Gene level expression estimates
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.genes.results'
    sbg:inheritMetadataFrom: '#read_files'
  description: File containing gene level expression estimates.
- id: '#sample_name_alleles_results'
  label: Allele level expression estimates
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.alleles.results'
    sbg:inheritMetadataFrom: '#read_files'
  description: |-
    File containing gene level expression estimates. This file contains allele level expression estimates for allele-specific expression calculation.
- id: '#rsem_calculate_expression_archive'
  label: Archive of all files outputed by 'RSEM Calculate Expression'
  type:
  - 'null'
  - File
  outputBinding:
    glob: rsem_calculate_expression_archive*
    sbg:inheritMetadataFrom: '#read_files'
    sbg:metadata:
      sample_name:
        class: Expression
        engine: '#cwl-js-engine'
        script: |-
          {
            function sharedStart(array){
            var A= array.concat().sort(), 
                a1= A[0], a2= A[A.length-1], L= a1.length, i= 0;
            while(i<L && a1.charAt(i)=== a2.charAt(i)) i++;
            return a1.substring(0, i);
            }
            
            var arr = [].concat($job.inputs.read_files)
            var ext = arr[0].path.split('.').pop().toLowerCase()
            
            if (arr[0].metadata && arr[0].metadata.sample_id) {
              return arr[0].metadata.sample_id
            } else {
            
            if (ext=='bam' || ext=='sam' || ext=='cram') {
              return arr[0].path.split("/").pop().split(".")[0]
            } else {
              
            if (arr.length==1) {
              return arr[0].path.split('/').pop().split('.')[0]
            } else {
              path_list = []
              arr.forEach(function(f){return path_list.push(f.path.replace(/\\/g,'/').replace( /.*\//, '' ))})
              common_prefix = sharedStart(path_list)
              return common_prefix.replace( /\-$|\_$|\.$/, '' )
            }
            }
            }
          }
  description: |-
    Bundle of files outputed by 'RSEM Calculate Expression', to be used by other tools in the RSEM toolkit.
  sbg:fileTypes: TAR

baseCommand:
- ulimit
- -v
- unlimited
- '&&'
- tar
- -xf
- class: Expression
  engine: '#cwl-js-engine'
  script: |-
    {
    var str = [].concat($job.inputs.rsem_prepare_reference_archive)[0].path.split("/").pop();
    return str

    }
- '&&'
- rsem-calculate-expression
arguments:
- prefix: ''
  position: 99
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: '[].concat($job.inputs.rsem_prepare_reference_archive)[0].metadata.reference_name'
  separate: true
- prefix: --sort-bam-memory-per-thread
  position: 0
  valueFrom: 1500M
  separate: true
- prefix: --num-threads
  position: 0
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: '$job.inputs.star==true ? 32 : 16'
  separate: true
- position: 156
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        function sharedStart(array){
        var A= array.concat().sort(), 
            a1= A[0], a2= A[A.length-1], L= a1.length, i= 0;
        while(i<L && a1.charAt(i)=== a2.charAt(i)) i++;
        return a1.substring(0, i);
        }
        
        
        var arr = [].concat($job.inputs.read_files)
        var ext = arr[0].path.split('.').pop().toLowerCase()
        var cmd = ""
        
        if (arr[0].metadata && arr[0].metadata.sample_id) {
          var x = arr[0].metadata.sample_id
          cmd = "&& ls | grep ^" + x + ". | tar cf rsem_calculate_expression_archive." + x + ".tar -T - "
          return cmd
        }
        
        if (ext=='bam' || ext=='sam' || ext=='cram') {
          var x =  arr[0].path.split("/").pop().split(".")[0]
          cmd = "&& ls | grep ^" + x + ". | tar cf rsem_calculate_expression_archive." + x + ".tar -T - "
          return cmd
        } else {
        
          if (arr.length==1) {
            common_prefix = arr[0].path.split('/').pop().split('.')[0]
          } else {
            path_list = []
            arr.forEach(function(f){return path_list.push(f.path.replace(/\\/g,'/').replace( /.*\//, '' ))})
            common_prefix = sharedStart(path_list)
          }
          var x = common_prefix.replace( /\-$|\_$|\.$/, '' )
          cmd = "&& ls | grep ^" + x + ". | tar cf rsem_calculate_expression_archive." + x + ".tar -T - "
          return cmd
        }
         
      }
  separate: true
- position: 100
  valueFrom:
    class: Expression
    engine: '#cwl-js-engine'
    script: |-
      {
        function sharedStart(array){
        var A= array.concat().sort(), 
            a1= A[0], a2= A[A.length-1], L= a1.length, i= 0;
        while(i<L && a1.charAt(i)=== a2.charAt(i)) i++;
        return a1.substring(0, i);
        }
        
        var arr = [].concat($job.inputs.read_files)
        var ext = arr[0].path.split('.').pop().toLowerCase()
        
        if (arr[0].metadata && arr[0].metadata.sample_id) {
          return arr[0].metadata.sample_id
        } else {
        
        if (ext=='bam' || ext=='sam' || ext=='cram') {
          return arr[0].path.split("/").pop().split(".")[0]
        } else {
          
        if (arr.length==1) {
          return arr[0].path.split('/').pop().split('.')[0]
        } else {
          path_list = []
          arr.forEach(function(f){return path_list.push(f.path.replace(/\\/g,'/').replace( /.*\//, '' ))})
          common_prefix = sharedStart(path_list)
          return common_prefix.replace( /\-$|\_$|\.$/, '' )
        }
        }
        }
      }
  separate: true

hints:
- class: sbg:CPURequirement
  value:
    class: Expression
    engine: '#cwl-js-engine'
    script: '$job.inputs.star==true ? 32 : 16'
- class: sbg:MemRequirement
  value:
    class: Expression
    engine: '#cwl-js-engine'
    script: '$job.inputs.star==true ? 60000 : 30000'
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/uros_sipetic/rsem:1.2.31
  dockerImageId: 67d3a6c01e92210f43c8ef809c2a245a75bf7d5a52762823cdc3b2e784de576c
id: |-
  jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/rsem-calculate-expression/0
appUrl: |-
  /u/jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/apps/#jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/rsem-calculate-expression/0
description: |-
  RSEM Calculate Expression aligns input reads against a reference transcriptome with a specified aligner and calculates expression values using the alignments. It is based on the Expectation-Maximization algorithm for quantifying abundances of the transcripts from single-end or paired-end RNA-Seq data. It fractionally assigns reads (also correctly handles multi-reads) mapped to a transcriptome for estimation of isoform expression levels; these are later further used to estimate gene expression levels. This tool does not require a reference genome and is therefore of particular interest for studying species without sequenced genomes.

  The aligners that RSEM can internally call are Bowtie 1.1.2, Bowtie2 2.2.6 and STAR 2.5.1b. 

  ###Common issues###

  1. Users must run 'rsem-prepare-reference' with the appropriate reference before using this program.

  2. For single-end data, it is strongly recommended that the user provide the fragment length distribution parameters (--fragment-length-mean and --fragment-length-sd).  For paired-end data, RSEM will automatically learn a fragment length distribution from the data.

  3. Some aligner parameters have default values different from their original settings.

  4. With the '--calc-pme' option, posterior mean estimates will be calculated in addition to maximum likelihood estimates.

  5. With the '--calc-ci' option, 95% credibility intervals and posterior mean estimates will be calculated in addition to maximum likelihood estimates.

  6. The temporary directory and all intermediate files will be removed when RSEM finishes unless '--keep-intermediate-files' is specified.

  7. If "STAR" parameter is set, a larger instance will be required by the tool. 

  8. In case of paired-end alignment it is crucial to set metadata 'paired-end' field to 1/2.

  9. For FASTQ reads in multi-file format (i.e. two FASTQ files for paired-end 1 and two FASTQ files for paired-end2), the proper metadata needs to be set (the following hierarchy is valid: sample_id/library_id/platform_unit_id/file_segment_number).
sbg:appVersion:
- sbg:draft-2
sbg:categories:
- RNA
- Alignment
sbg:cmdPreview: |-
  ulimit -v unlimited && tar -xf hg19.human_prepare_reference_archive.tar.gz && rsem-calculate-expression --sort-bam-memory-per-thread 1500M --num-threads 32  hg19.human  SampleA  && ls | grep ^SampleA. | tar cf rsem_calculate_expression_archive.SampleA.tar -T -
sbg:contributors:
- jelena_randjelovic
sbg:createdBy: jelena_randjelovic
sbg:createdOn: 1538394632
sbg:id: |-
  jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow/rsem-calculate-expression/0
sbg:image_url:
sbg:job:
  allocatedResources:
    cpu: 32
    mem: 60000
  inputs:
    append_names: false
    bowtie2: false
    bowtie2_k:
    bowtie2_mismatch_rate:
    bowtie2_sensitivity_level: ''
    bowtie_chunkmbs:
    bowtie_e:
    bowtie_m:
    bowtie_n:
    calc_ci: false
    calc_pme: false
    ci_credibility_level:
    ci_memory:
    ci_number_of_samples_per_count_vector:
    estimate_rspd: false
    forward_prob:
    fragment_length_max:
    fragment_length_mean:
    fragment_length_min:
    fragment_length_sd:
    gibbs_burnin:
    gibbs_number_of_samples:
    gibbs_sampling_gap:
    keep_intermediate_files: false
    no_bam_output: false
    no_qualities: false
    num_rspd_bins:
    output_genome_bam: false
    paired_end_alignment: false
    phred33_quals: false
    phred64_quals: false
    read_files:
    - class: File
      secondaryFiles: []
      metadata:
        paired_end: '1'
        platform_unit_id: '1'
        sample_id: SampleA
      path: /path/to/sampleA_lane1_pe1.fastq
      size: 0
    rsem_prepare_reference_archive:
      class: File
      secondaryFiles: []
      metadata:
        reference_name: hg19.human
      path: /path/to/hg19.human_prepare_reference_archive.tar.gz
      size: 0
    sampling_for_bam: false
    seed:
    seed_length:
    single_cell_prior: false
    solexa_quals: false
    sort_bam_by_coordinate: true
    sort_bam_by_read_name: false
    star: true
    star_output_genome_bam: false
    strand_specific: false
    tag: ''
    time: false
sbg:latestRevision: 0
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
sbg:modifiedOn: 1538394632
sbg:project: jelena_randjelovic/pdxnet-polishing-jax-rna-seq-workflow
sbg:projectName: PDXnet - Polishing JAX RNA-seq workflow
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes:
sbg:revisionsInfo:
- sbg:modifiedBy: jelena_randjelovic
  sbg:modifiedOn: 1538394632
  sbg:revision: 0
  sbg:revisionNotes:
sbg:sbgMaintained: false
sbg:toolAuthor: Bo Li, Colin Dewey
sbg:toolkit: RSEM
sbg:toolkitVersion: 1.2.31
sbg:validationErrors: []
x: 815.1965332031255
y: 695.0187174479171
