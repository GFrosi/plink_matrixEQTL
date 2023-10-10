#installing packages
#Biocmanager
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install()

install.packages("MatrixEQTL")

#loading libraries
library("MatrixEQTL")


#loading test set
base.dir = "/Users/gfrosi/scratch/Douglas_projects/test_matrix_eqtl/laura_files"
SNP_file_name = paste0(base.dir,"/stand_plink_to_EQTL/BEGAIN_snp_stand.txt") #sample in columns, snps in rows
expression_file_name = paste0(base.dir,"/stand_plink_to_EQTL/BEGAIN_ge.txt") #sample in columns, genes in rows
covariates_file_name = paste0(base.dir, "/stand_plink_to_EQTL/BEGAIN_cvrt.txt") #samples in columns, age... sex... in rows (1 -male, 2 -female?)


#you need to define the model (e.g linear model), snp_file and expression_file
useModel = modelLINEAR #the stand ones

#out name file 
output_file_name = "/Users/gfrosi/scratch/Douglas_projects/test_matrix_eqtl/laura_files/output_eqtl/BEGAIN_eqtl_snp_stand.txt"

# The p-value threshold determines which gene-SNP associations are
# saved in the output file output_file_name.
# Note that for larger datasets the threshold should be lower.
# Setting the threshold to a high value for a large dataset may
# cause excessively large output files.
pvOutputThreshold = 1e-2 #is that good? or use 0.05?

# Finally, define the covariance matrix for the error term.
# This parameter is rarely used.
# If the covariance matrix is a multiple of identity, set it to numeric().

errorCovariance = numeric()

#loading snp data
snps = SlicedData$new()
snps$fileDelimiter = "\t"      # the TAB character
snps$fileOmitCharacters = "NA" # denote missing values
snps$fileSkipRows = 1          # one row of column labels
snps$fileSkipColumns = 1       # one column of row labels
snps$fileSliceSize = 2000      # read file in pieces of 2,000 rows
snps$LoadFile(SNP_file_name)


#loading gene data
gene = SlicedData$new()
gene$fileDelimiter = "\t"      # the TAB character
gene$fileOmitCharacters = "NA" # denote missing values
gene$fileSkipRows = 1          # one row of column labels
gene$fileSkipColumns = 1       # one column of row labels
gene$fileSliceSize = 2000      # read file in pieces of 2,000 rows
gene$LoadFile( expression_file_name )


#loading covariates
cvrt = SlicedData$new()
cvrt$fileDelimiter = "\t"      # the TAB character
cvrt$fileOmitCharacters = "NA" # denote missing values
cvrt$fileSkipRows = 1          # one row of column labels
cvrt$fileSkipColumns = 1       # one column of row labels
cvrt$fileSliceSize = 2000      # read file in pieces of 2,000 rows
cvrt$LoadFile (covariates_file_name)


#plot matrix
me = Matrix_eQTL_engine(
  snps = snps,
  gene = gene,
  cvrt = cvrt,
  output_file_name = output_file_name,
  pvOutputThreshold = pvOutputThreshold,
  errorCovariance = errorCovariance,
  useModel = useModel,
  verbose = TRUE,
  pvalue.hist = TRUE,
  min.pv.by.genesnp = FALSE,
  noFDRsaveMemory = FALSE)


