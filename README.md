# Open Targets PDX PRocessing Pipelines

This repo contains code and information related to the processing of DNA and RNA data from patient-derived xenografts (PDX).

## DNA Workflows
Simply ported over from https://cgc.sbgenomics.com/public/apps/.
 - Common workflow language (CWL) implemented for use on Cavatica from [Seven Bridges](https://cgc.sbgenomics.com/public/apps/pdxnet/pdx-wf-commit2/pdx-wes-tumor-only-xenome-with-variant-calling-msi-and-tmb-score); developed by Jackson Labs. Reference and tool details contained in workflow link
 - Ported code is in `pdx-wes-tumor-only.cwl`

## RNA Workflows
Also ported over from https://cgc.sbgenomics.com/public/apps/ and additionally, [Kids First DRC RNAseq](https://github.com/kids-first/kf-rnaseq-workflow) used as a submodule

 - [Jackson labs pipeline](https://cgc.sbgenomics.com/public/apps/pdxnet/pdx-wf-commit2/pdx-rna-expression-estimation-workflow) was ported over for use on Cavatica. Ported code is in `pdx-rna-tumor-only.cwl`
 - Kids First pipeline was modified to include the Xenome tool and related references. Workflow script found here: `workflows/kfdrc-pdx-RNAseq-workflow.cwl`

## [Cavatica Development Project](https://cavatica.sbgenomics.com/u/d3b-bixu/open-targets-pdx-workflow-dev) 
PDX data from the paper "Genomic Profiling of Childhood Tumor Patient-Derived Xenograft Models to Enable Rational Clinical Trial Design", DOI: https://doi.org/10.1016/j.celrep.2019.09.071 are here as well as workflows used
