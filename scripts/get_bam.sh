#!/usr/bin/bash
species=$1
dir_path=$2
softpath=$3
FASTA=$dir_path/${species}.fa
GTF=$dir_path/${species}.gtf
$softpath/STAR --runThreadN 16 --runMode genomeGenerate --genomeSAindexNbases 12 --genomeDir ${species}_STAR --genomeFastaFiles $FASTA --sjdbGTFfile $GTF
wait
cat srrid|while read sraID
do
$softpath/fasterq-dump --split-files ${sraID}.sra
wait
        if [ -f "${sraID}.fastq" ];then
                $softpath/fastp -i ${sraID}.fastq -o  ${sraID}.clean.fq.gz -j ${sraID}.json -h ${sraID}.html
        else
                $softpath/fastp --detect_adapter_for_pe -i ${sraID}_1.fastq -o ${sraID}_1.clean.fq.gz -I ${sraID}_2.fastq -O ${sraID}_2.clean.fq.gz -j ${sraID}.json -h ${sraID}.html
        fi
wait
        if [ -f "${sraID}.clean.fq.gz" ];then
                $softpath/STAR --genomeDir ${species}_STAR  --sjdbGTFfile $GTF --outSAMtype BAM SortedByCoordinate --outFilterMultimapNmax 1 --outFilterMismatchNmax 2 --runThreadN 16 --readFilesCommand zcat --readFilesIn ${sraID}.clean.fq.gz --outFileNamePrefix $sraID
        else
                $softpath/STAR --genomeDir ${species}_STAR --sjdbGTFfile $GTF --outSAMtype BAM SortedByCoordinate --outFilterMultimapNmax 1 --outFilterMismatchNmax 2 --runThreadN 16 --readFilesCommand zcat --readFilesIn ${sraID}_1.clean.fq.gz ${sraID}_2.clean.fq.gz --outFileNamePrefix $sraID
        fi
done