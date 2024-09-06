set -e #exit script if there is an error

echo Provide full path for raw fastq files
read directory
cd $directory  #change to correct directory
mkdir -p ../trimmed_reads/fastp_reports #make directory for storing trimmed reads and  qc files


for infile in *1_001.fastq.gz # Run fastp
do
	base=$(basename ${infile} 1_001.fastq.gz)
	echo Starting file $base
	fastp -i ${base}1_001.fastq.gz -I ${base}2_001.fastq.gz -o ${base}1.trim.fastq.gz -O ${base}2.trim.fastq.gz --trim_front1 10 --trim_front2 10 --correction --detect_adapter_for_pe
	mv fastp.html ../trimmed_reads/fastp_reports/${base}.html
        mv fastp.json ../trimmed_reads/fastp_reports/${base}.json
        mv *trim.fastq.gz ../trimmed_reads
done
