set -e #exit script if there is an error

export PATH="$PATH:/home/runcklesslab/software/bcftools-1.9"

echo Provide full path for files you want analyzed. This should be the path to the directory containing the trimmed fastq files
read directory  #save path to variable
cd $directory  #cd into correct directory
ls .  #test to make sure the correct files are given

echo Provide full path of reference genome. This should be the path to the indexed ".fa" file generated by indexing the wgs of your organism
read genome
head $genome -n 5 #test to make sure the correct reference genome is provided

mkdir -p ../bam  #make the required directories to keep file organized


for sample in *1.trim.fastq.gz
do
        echo "working with sample $sample" #print which file you are working with

        base=$(basename $sample 1.trim.fastq.gz)
        echo "base name is $base" #print basename to terminal

        fq1=${base}1.trim.fastq.gz #full path for file1
        fq2=${base}2.trim.fastq.gz #full path for file2

	final_bam=../bam/${base}.final.bam #sorted bam file name and location

	#align reads to genome, redirect to sam file; -t 4 used to speed up alignment by utilizing 4 thread, compress tobam file, sort
        bwa  mem -t 4 $genome $fq1 $fq2 | samtools view -bh - | samtools sort - > sorted.bam
        echo Reads aligned to genome

	samtools collate sorted.bam -o collate.bam
        samtools fixmate -m collate.bam fixmate.bam
        samtools sort fixmate.bam -o positionsort.bam

	# -r remove duplicates; -S Mark supplementary reads of duplicates as duplicates, sort deduplicated files, index deduplicated files
	samtools markdup -rS positionsort.bam -| samtools sort - > $final_bam
	echo deduplication complete

	samtools index $final_bam
	echo indexed final bam file

	rm sorted.bam collate.bam  fixmate.bam  positionsort.bam
	echo removed unnecessary intermediate files
done

echo "All Done"
