#! /usr/bin/bash



while read line
do
    entries+=("$line")
done < ag_amp_abx.txt

for line in "${entries[@]}"
do
	set $line
	chr=$1
	pos=$2

	pat="(^>${chr}.*\n)([ATGC\n]*)"
	string=$(pcregrep -M $pat ass_genome_PP_SN15-2.fa | grep -v '>' | tr -d " \t\n\r")

	start=$(($pos-10))
	end=$(($pos+10))
	length=$(($end-$start))

	seq=${string:$(($start-1)):$(($length+1))}  

	echo -e ">$line \n$seq"
done
