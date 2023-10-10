#installing packages
#loading libraries
library("dplyr")
library("tibble")


#loading plink file (.traw - genotype) 
SNP_begain = read.table("scratch/Douglas_projects/test_matrix_eqtl/laura_files/input_matrix_eqtl/BEGAIN_snp_stand_filtered_no_dup_R.traw", header = TRUE)
SNP_begain_filter <- SNP_begain[, -c(1,3:6)] #dropping undesired cols
colnames(SNP_begain_filter) <- sub("_CAN_.*","",colnames(SNP_begain_filter)) #standardizing samples names to match the GE.txt 

#Gene expression 
GE_begain <- read.table("scratch/Douglas_projects/test_matrix_eqtl/laura_files/input_matrix_eqtl/GE.txt", header = TRUE)
colnames(GE_begain)[1] <- "geneid"  #rename Gene_ID by geneid (as the tutorial)

#get intersection file to filter the .traw based on samples available in GE_begain
common_samples <- intersect(colnames(SNP_begain_filter), colnames(GE_begain))
length(common_samples) #142 for all transcripts, 141 for begain_201_t0

#generating final SNP
SNP_begain_filter_cols <- SNP_begain_filter[, which((colnames(SNP_begain_filter) %in% common_samples)==TRUE)] #getting common samples
SNP_begain_filter_cols <- SNP_begain_filter_cols[names(GE_begain[-1])] #reordering cols as GE position
SNP_begain_filter_cols['snpid'] <- SNP_begain_filter['SNP'] #adding snp info
SNP_begain_filter_cols <- SNP_begain_filter_cols %>% select('snpid', everything()) #put snpid as first column

#covariate files - age and sex
cvrt_begain <- read.table("scratch/Douglas_projects/test_matrix_eqtl/laura_files/input_matrix_eqtl/BEGAIN_GE_metadata.txt",header = TRUE, sep = "\t")
cvrt_begain <- cvrt_begain[,c(8,2:3)]
cvrt_begain_t <- setNames(data.frame(t(cvrt_begain[,-1])), cvrt_begain[,1]) #transposing and keeping cols names
cvrt_begain_t <- cvrt_begain_t[,colSums(is.na(cvrt_begain_t))<nrow(cvrt_begain_t)] #removing cols with all cells as NA
cvrt_begain_t_cols <- cvrt_begain_t[names(GE_begain[-1])] #reordering samples as GE position
cvrt_begain_t_cols <- tibble::rownames_to_column(cvrt_begain_t_cols, "id") #rownames as id column (first column)

#check the col names, excluding first
snp_names <- colnames(SNP_begain_filter_cols)[-1]
ge_names <- colnames(GE_begain)[-1]
cvrt_names <- colnames(cvrt_begain_t_cols)[-1]

#check if the column names are the same in the same order
if(identical(snp_names, ge_names) && identical(ge_names, cvrt_names)) {
  cat("Column names are the same in the same order (excluding the first column) for all three dataframes.")
} else {
  cat("Column names are not the same in the same order for all three dataframes.")
}

#Save files to run the ME
#SNP - genotype
write.table(SNP_begain_filter_cols, "/Users/gfrosi/scratch/Douglas_projects/test_matrix_eqtl/laura_files/stand_plink_to_EQTL/BEGAIN_snp_stand.txt", sep="\t" ,quote = F, row.names = F) #snp
write.table(GE_begain, "/Users/gfrosi/scratch/Douglas_projects/test_matrix_eqtl/laura_files/stand_plink_to_EQTL/BEGAIN_ge.txt", sep="\t" ,quote = F, row.names = F) #ge
write.table(cvrt_begain_t_cols, "/Users/gfrosi/scratch/Douglas_projects/test_matrix_eqtl/laura_files/stand_plink_to_EQTL/BEGAIN_cvrt.txt", sep="\t" ,quote = F, row.names = F) #cvrt