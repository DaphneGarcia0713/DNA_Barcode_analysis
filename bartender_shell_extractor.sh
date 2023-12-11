# #!/bin/bash


#              bartender shell extractor
#
#  for Cooper lab barcoding analysis pipeline
#  By Daphne Garcia
#  last modified: 7/20/23
#
#  Purpose:
#    This takes in all of the sample-separated fasta files and formats them 
#    for the clusterer function in bartender, outputting them into separate files.
#    returns error and number of extractions in SUMMARY.txt
#
#  Input:
#    The script will ask you what output folder you want all of the extracted
#    files to go into. This folder must already exist before running the program,
#    you can create this file on the command like using mkdir.
#    Also, reads in from FILES on line 30
#
#  Output:
#    This outputs many files with the extracted data to be used by 
#    bartender_single (the clusterer), which go inside the output folder you 
#    specified in input.



echo "Name of output folder (must already exist): "
read outfile
FILES="/home/daphne13/bartender11/samples_R1R2Jul20/*.fastq"
for f in $FILES
do
  name="${f##*/}"
  name="${name%.*}"
  name="${name}_extracted"
  folder="${outfile}/${name}"

  #NOTE: top is for non-umi, bottom is for umi. 

  bartender_extractor_com -f $f -o $folder -q ? -p GGGG[4-7]AA[4-7]AA[4-7]TT[4-7]CACT -m 2 >> "${outfile}/SUMMARY.txt"
 # bartender_extractor_com -f $f -o $folder -q ? -p GGGG[4-7]AA[4-7]AA[4-7]TT[4-7]CACT -m 2 -u 33,8 >> "${outfile}/SUMMARY.txt"
done
echo Done!