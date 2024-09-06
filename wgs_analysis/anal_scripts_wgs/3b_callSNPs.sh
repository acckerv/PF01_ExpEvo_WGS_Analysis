set -e #exit script if there is an error

export PATH="$PATH:/home/runcklesslab/software/bcftools-1.9"

echo Provide full file path to the sorted, deduplicated, tagged bam files.
read directory  #save path to variable
cd $directory  #cd into correct directory
ls .  #doublecheck correct files are given

ls *.bam > bamList #create list of bam files to be analyzed

echo Provide full file the path to the indexed ".fna" file
read genome
head $genome -n 5 #test to make sure the correct reference genome is provided

mkdir -p ../joint_vcf  #make the directory to save the final vcf file

variants=../joint_vcf/jointSNPs.vcf #vcf file name and location
stats=../joint_vcf/jointSNPs.txt #final variants filename and location

freebayes -f $genome --ploidy 100 --use-best-n-alleles 4 --pooled-discrete -L bamList | vcffilter -f "QUAL > 20 & DP > 20"  > $variants
echo variants identified and filtered

#bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t[\,%SAMPLE=%GT]\t%DP\t%AC\t%AN\t%AF\t%RO\t%MQMR\t%AO\t%MQM\t%TYPE\n' > $stats  #extract variant inf0

echo variant info extracted

mv bamList ../joint_vcf

echo "All Done"
