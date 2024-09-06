set -e #exit script if there is an error

export PATH="$PATH:/home/runcklesslab/software/bcftools-1.9"

echo Provide full file path to the sorted, deduplicated bam files.
read directory  #save path to variable
cd $directory  #cd into correct directory
ls .  #doublecheck correct files are given

echo Provide full file the path to the indexed ".fna" file
read genome
head $genome -n 5 #test to make sure the correct reference genome is provided

mkdir -p vcf  #make the directory to save the final vcf file


for sample in *.bam
do
        base=$(basename $sample _R.final.bam)
        echo "base name is $base" #print basename to terminal

        variants=vcf/${base}_variants.vcf #vcf file name and location
        stats=vcf/${base}_vcf_.txt #final variants filename and location

	freebayes -f $genome -F 0.01 -C 1 --pooled-continuous $sample | vcffilter -f "QUAL > 20 & DP > 20"  > $variants
	echo variants identified and filtered

	bcftools query -f '%CHROM %POS %REF %ALT %DP %AC %AN %AF %RO %MQMR %AO %MQM %TYPE\n' $variants > $stats  #extract variant information for later analysis
	echo variant info extracted
done

echo "All Done"
