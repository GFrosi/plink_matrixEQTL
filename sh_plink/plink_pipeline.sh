#!bin/bash

#=================================================================== Description ==============================================================
#Script to run plink QC, filtering and generate the traw file (Inpute to MakeEQTL - R)
#The QC metrics include geno > 0.05; maf > 0.01 and HWE < 0.000001
#We need plink1 and plink2 (from /project/rrg-gturecki/Software_Installations_and_Databases/plink2 instalation)
#Compute Canada has plink2 available via module load, BUT this version does not support the --export Av parameter to generate the .traw file
#(genotype input for R)
#REMINDER: This pipeline does not include the LD (Linkeage Disequilibrium analysis). (side script)
#==============================================================================================================================================


#loading plink1
module load plink/1.9b_6.21-x86_64


#first step - QC filter
#Add --remove bad_samples.txt - when we have at least the chr X in our dataset to perform --check-sex to check for bad samples

mkdir /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter

/project/rrg-gturecki/Software_Installations_and_Databases/plink2  \
      --bfile /home/frosig/projects/rrg-gturecki/frosig/begain_laura/plink_out_drive/BEGAIN_binary \
      --chr 14 \
      --maf 0.01 \
      --geno 0.05 \
      --hwe 0.000001 \
      --ref-from-fa force \
      --fa /cvmfs/soft.mugqic/CentOS6/genomes/species/Homo_sapiens.GRCh38/genome/Homo_sapiens.GRCh38.fa \
      --normalize \
      --make-bed \
      --out /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_filtered_with_dup


#Second - check duplicates (SNP position based)
#If you get an error here regarding the Error: Duplicate ID 'rs1234', you have two options:
#1 - You can go directly in your .bim file and modify one of the duplicate's name (e.g rs1234_d)
#2 - You can use the --rm-dup option (followed by --force-first if you really want to keep one SNP. 
#But be aware because even with the same ID, the SNPs can have different information)
#It's possible that the duplicates are genuine and represent different genetic variants with the same rsID, although this is relatively rare

plink \
      --bfile /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_filtered_with_dup \
      --list-duplicate-vars ids-only suppress-first \
      --out /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_dup_post_filter


#Third - remove duplicates and generate a new .bed file - remember: forcing the REF/ALT according to reference genome 
/project/rrg-gturecki/Software_Installations_and_Databases/plink2  \
    --bfile /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_filtered_with_dup \
    --exclude /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_dup_post_filter.dupvar \
    --ref-from-fa force \
    --fa /cvmfs/soft.mugqic/CentOS6/genomes/species/Homo_sapiens.GRCh38/genome/Homo_sapiens.GRCh38.fa \
    --normalize \
    --make-bed \
    --out /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_filtered_no_dup


#Fourth - standardizing the SNP names by adding the coordinates and REF/ALT - in that case we are standardizing for hg38 genome
/project/rrg-gturecki/Software_Installations_and_Databases/plink2 \
    --bfile /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_filtered_no_dup \
    --set-all-var-ids @:#[hg38]\$r:\$a \
    --make-bed \
    --out /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_snp_stand_filtered_no_dup


#Fifth - generate the .traw file. This file will be used as input for R (Make EQTL)
/project/rrg-gturecki/Software_Installations_and_Databases/plink2 \
    --bfile /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_snp_stand_filtered_no_dup \
    --export Av \
    --out /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_snp_stand_filtered_no_dup_R



#Additional step - generate the .traw file (but not using the renamed snp ID file).
/project/rrg-gturecki/Software_Installations_and_Databases/plink2 \
    --bfile /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_filtered_no_dup \
    --export Av \
    --out /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_filtered_no_dup_R





