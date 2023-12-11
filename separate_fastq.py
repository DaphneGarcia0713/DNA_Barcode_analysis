'''
Separate fastq

for Cooper lab barcoding analysispipeline
By Daphne Garcia
last modified: 7/20/23

Purpose:
    This takes in the aligned fasta files from geneious, and sorts them by 
    sample tag. The sample tags are inputted as a list called "pattern_list".

Input:
    No command line input, but change the pattern_list to have your primers. 
    These ones are the primers Michelle used for the 10/22 experiment, and 
    apparently also the 300 barcode experiment. Also reads in the fasta input
    file from geneious, change input file name on line 45.

Output:
    This outputs many fastq files (not fasta!) for however many sample tags 
    there were in the pattern_list. Change output file path on line 44.

'''

import re, sys, os, regex
from Bio import SeqIO
from itertools import tee, chain
 

# ######## START OF PROGRAM #########

print("starting program")
primer_count = 0

pattern_list = ["CGAGAAGGCTAGA","TATGTGGTAATGA","AGTACCCAAACGT","ACGACAGGTACCC","GCCGCAGTATAAG",
"AGGCGCCGTAGCA","CTAACACTTAATT","AACGACCCATGAC","TTCGACGAATAGG","ACAATCTTTCAAC","GGCGCTCACTAAC",
"CGCCCATGGTTAC","TGCCGTAAATAAC","GAACAAACGACCC","CAGATGTGAGATA","ACGCGAATACAGA","TTCTACTCTTCCT",
"CGCATCCGGGCTA","TTAAGAACCAAAA","TACCGTGTCGTTT","CTCCACGTTTATC","ACCAGATAAACTC","TCACTGTGCAGCG",
"GCGAGTACTGCGG","CTCAGGTACGGTT","GTCCATGCTCGCC","GTGGTTTAGCGAC","TAACAACAAGGAG","TTTGGCCCCAAGT","GGACTCACTGCTA",
"TGATCCATTGGCG","ACCTATTTTCTCA","ATTGCATGTTGCG","ATAGCAAAATGAG","TTTACGCACAAAG","GTTTAATCGTGTT", "CCGCTTGGGAGTA"]

for pattern in pattern_list:
    print(pattern)
    regex_pattern = f"({pattern}){{e<=2}}"      ## get the primer for the pattern, and allow for 2 mismatches (e<=2)
    fq_path = "R." + "{}".format(primer_count) + "Jul20reads.fastq"     #change name of the output files
    with open("R1_noPhix.fasta", "r") as fasta, open(fq_path, "w") as fastq:    #while reading fasta, write to fastq
        for record in SeqIO.parse(fasta, "fasta"):                                  #for each fasta type in "fasta" file ,
            if regex.search(regex_pattern, str(record.seq)):                             #if finding the pattern returns true
                record.letter_annotations["phred_quality"] = [40] * len(record)     #add quality to fasta
                SeqIO.write(record, fastq, "fastq")                                 #write it as a fastq to "fastq" file

    #NOTE:  if you're not appending 2 unpaired fastas together, you don't need the bottom chunk.
    #       I used this to append R1 and R2 fastas for the same sample

    # with open("R2_noPhix.fasta", "r") as fasta, open(fq_path, "a") as fastq:    #while reading fasta, write to fastq
    #     for record in SeqIO.parse(fasta, "fasta"):                                  #for each fasta type in "fasta" file ,
    #         if regex.search(regex_pattern, str(record.seq)):                             #if finding the pattern returns true
    #             record.letter_annotations["phred_quality"] = [40] * len(record)     #add quality to fasta
    #             SeqIO.write(record, fastq, "fastq")                                 #write it as a fastq to "fastq" file
    
    primer_count +=1
