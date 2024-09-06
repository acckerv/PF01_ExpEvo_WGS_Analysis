set -e #exit script if there is an error

echo Provide path to vcf file
read directory  #save path to variable
cd $directory  #cd into correct directory


for VCF in *.vcf  #record variant statistic, depth and quality
do
	vcftools --vcf $VCF --site-quality --out stats  #Calculate site quality
	vcftools --vcf $VCF --get-INFO DP --out stats  #Extract raw read depth
	paste --delimiters='\t' stats.INFO stats.lqual > $(basename ${VCF} .vcf)_stats.txt
done


rm stats*

mkdir stats
mv *stats.txt stats

echo All done!!!
