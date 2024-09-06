
echo Provide full path for files you want analyzed.
read directory  #save path to variable
cd $directory  #cd into correct directory
ls ./*.bam  #test to make sure the correct files are given


for sample in *.bam
do
        echo "working with sample $sample" #print which file you are working with

	echo $sample > filename.txt

        id=$(awk -F '_' '{print $3}' filename.txt)
	echo "Read group id is $id" #print basename to terminal

	newfilename=$(awk -F '_' '{print $1 "_" $3 "_" $5}' filename.txt)
	echo "New filename is $newfilename"

	samtools addreplacerg -r "ID:$id" -r "LB:NA" -r "SM:$id" -o $newfilename.rg.bam $sample

	rm filename.txt
done

mkdir ../tagged_bam
mv *.rg.* ../tagged_bam
