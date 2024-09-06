set -e #exit script if there is an error

echo Provide full path for raw fastq files
read directory
cd $directory  #change to correct directory


echo "Running FastQC..."
fastqc *.fastq*   #run fastqc on all samples

echo "Saving FastQC results to reports folder..."
mkdir fastqc_reports
mv *.zip fastqc_reports   #move to a new folder containing all qc'ed files
mv *.html fastqc_reports
cd fastqc_reports  #cd into folder containing qc'ed files

echo "Unzipping FastQC archives..."
unzip \*.zip

echo "Concatenating summary files..."
cat *_fastqc/summary.txt > fastqc_summaries.txt #obtain fastqc summary

echo "Identifying problem samples..."
grep FAIL fastqc_summaries.txt > fastqc_FAIL.txt #identify problem samples

echo "Deleting .zip files..."
rm *.zip

echo "I am done!"
