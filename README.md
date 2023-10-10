# plink_matrixEQTL


## Scripts to perform QC metrics for plink files, generate the new filtered ones. Also, to standardize the plink files to use them as input to run the MatrixEQTL (R)


### sh_plink

- This folder contains two .sh files
    - **plink_pipeline.sh**: performs the QC metrics filter, and generates the .traw plink file to be used as genotype input file in MatrixEQTL
    - **plink_LD.sh**: performs the Linkage Disequilibrium (LD) and Relatedness check/filters (in that case, you need to use the QC and duplicates filtered files - .bed, .bim, .fam)


### R_scripts (MatrixEQTl)

For more references, please check `https://github.com/andreyshabalin/MatrixEQTL/blob/master/README.md`

- This folders contains two .R scripts
    - **stand_plink_files.R** : standardizes the .traw (genotype file), gene expression and covariate files as necessary to run the MatrixEQTl package
    - **matrix_eqtl_plink.R** : script based on the github page cited above. This scripts generates a EQTl matrix using the default thresholds from tutorial. 
