## try http:// if https:// URLs are not supported
if (!requireNamespace("BiocManager", quietly=TRUE))
  install.packages("BiocManager")
BiocManager::install("dada2")

library(dada2)






filtFastqs <- tempfile(fileext=".fastq.gz")

## R1 (takes around 40 min for a 1.8 GB .gz file)
filterAndTrim("Undetermined_S0_R1_001.fastq.gz", "Und_R1_no_Phix.fastq.gz", rm.phix=TRUE, verbose=TRUE)


## R2 (takes around 40 min for a 1.8 GB .gz file)
filterAndTrim("Undetermined_S0_R2_001.fastq.gz", "Und_R2_no_Phix.fastq.gz", rm.phix=TRUE, verbose=TRUE)
