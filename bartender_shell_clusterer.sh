# #!/bin/bash

#              bartender shell clusterer
#
#  for Cooper lab barcoding analysis pipeline
#  By Daphne Garcia
#  last modified: 7/20/23
#
#  Purpose:
#    This takes in all of the extracted .txt files from the extracted folder and
#    runs bartender_single for each. Using its clustering algorithm, groups all
#    the reads into the number of barcodes present, and outputs into file
#
#  Input:
#    The script will ask you what input folder has the extracted .txt files,
#    and what output folder names it will output.
#    
#  Output:
#    This outputs one folder with inside many folders with 6 files each if 
#    umi was used, (3) if umi wasn't used. 
#




#read in the input file and output files (assuming it's in same file as this script)
echo "Name of extraction input folder: "
read infile
echo "Name of clusters output folder (must already exist): "
read outfile

#walk thru all extracted input files, run bartender_single on all
FILES="/home/daphne13/bartender11/${infile}/*"
for f in $FILES
do

  # get the name of each sample extraction, and create the folder for each sample's output
  name="${f##*/}"
  name="${name%_extracted*}"
  folder="/home/daphne13/bartender11/${outfile}/${name}_clustered"
  mkdir $folder
  cd $folder
  bartender_single_com -f $f -o $name  -d 5 -z -1 -l 3 >> "${folder}/SUMMARY.txt"
  cd "/home/daphne13/bartender11/${outfile}"
done
echo Done! 