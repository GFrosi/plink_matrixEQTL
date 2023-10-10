#!bin/bash

#=========================== Description ============================
#Linkage Disequilibrium: check the SNPs in LD
#
#Important to run the PCA
#====================================================================


#First - run LD anlysis to check the LD disequilibrium
# mkdir /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD

module load plink/1.9b_6.21-x86_64

#do linkage disequilibrium pruning
#Passing the filtered (QC and duplicates) file as input for both steps. 
#Run each step passing the original snp and stand snp files


plink \
      --bfile /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_filtered_no_dup \
      --indep 50 5 2 \
      --out /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD/BEGAING_ld_pruned

plink \
      --bfile /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_snp_stand_filtered_no_dup \
      --indep 50 5 2 \
      --out /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD/BEGAING_ld_snp_stand_pruned



#Second - check relatedness (--genome)
# --ped ../PLINK_starting_files_from_gs_final_report/plus_minus_report.ped \
# --map ../PLINK_starting_files_from_gs_final_report/plus_minus_report.map \


plink \
      --bfile /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_filtered_no_dup \
      --genome \
      --extract /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD/BEGAING_ld_pruned.prune.in \
      --out /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD/BEGAING_relatedness 


plink \
      --bfile /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_filter/BEGAIN_snp_stand_filtered_no_dup \
      --genome \
      --extract /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD/BEGAING_ld_snp_stand_pruned.prune.in \
      --out /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD/BEGAING_snp_stand_relatedness 
      

#Sorting the relatedness files (original snp and stand snp)
sort -nrk 10,10 /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD/BEGAING_relatedness.genome > /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD/BEGAING_relatedness.genome.sorted
sort -nrk 10,10 /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD/BEGAING_snp_stand_relatedness.genome > /home/frosig/projects/rrg-gturecki/frosig/begain_laura/post_LD/BEGAING_snp_stand_relatedness.genome.sorted


