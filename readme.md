# The Analysis Pipeline of Peak Calling in Different Plant Species

> The pipeline is developed by  by Lang Xiaoqiang ([langxiaoqiang@foxmail.com](langxiaoqiang@foxmail.com)). For questions and comments, please contact Lang Xiaoqiang or submit an issue on github.



### 1 Building work environment

#### 1.1 The software need to install

- sratoolkit.2
- STAR
- fastp
- samtools
- MACS2

#### 1.2 R and R package

- R 4.2
- exomePeak2

#### 1.3 Database



```shell
## take Arabidopsis thaliana as an example
## reference sequence download
wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-57/fasta/arabidopsis_thaliana/cds/Arabidopsis_thaliana.TAIR10.cds.all.fa.gz
## or deliver tasks to the background server 
nohup  wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-57/fasta/arabidopsis_thaliana/cds/Arabidopsis_thaliana.TAIR10.cds.all.fa.gz &
## GTF format annotation file download
wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-57/gtf/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.57.gtf.gz 
or
nohup wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-57/gtf/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.57.gtf.gz &
## MeRIP-seq datasets download
#srrid need to be prepared
# cat download.sh
#!/usr/bin/bash
cat srrid|while read id
do
$software_path/sratoolkit.2.11.0-centos_linux64/bin/prefetch $id
Done
# run download.sh
nohup sh download.sh software_path &
```

### 2 Get BAM formatted files

```shell
### run get_bam.sh to get BAM formatted files
sh get_bam.sh species dir_path soft_path

### rename the bam files
##Convert srrid_name bam file to srxid_name bam file, the file sra2srx_id is needed, here take 12 MeRIP-seq samples of Arabidopsis thaliana as an example

## cat sra2srx_id
SRR13522944     SRX9933631
SRR13522945     SRX9933630
SRR13522946     SRX9933629
SRR13522947     SRX9933628
SRR13522948     SRX9933627
SRR13522949     SRX9933626
SRR13522950     SRX9933625
SRR13522951     SRX9933624
SRR13522952     SRX9933623
SRR13522953     SRX9933622
SRR13522954     SRX9933621
SRR13522955     SRX9933620

## get rename_bam_file.sh
awk '{print "mv""\t"$1"Aligned.sortedByCoord.out.bam""\t"$2".bam"}'
sra2srx_id >>rename_bam_file.sh

## run rename_bam_file.sh
sh rename_bam_file.sh
```

### 3 Peak calling use MACS2

```shell
### take 12 MeRIP-seq samples of Arabidopsis thaliana as an example
## cat id.txt
IP      Input
SRX9933630      SRX9933620
SRX9933631      SRX9933626
SRX9933621      SRX9933629
SRX9933625      SRX9933622
SRX9933627      SRX9933623
SRX9933628      SRX9933624

## cat macs2.sh
#!/usr/bin/bash
software_path=$1
inputs=(SRX9933620 SRX9933626 SRX9933629 SRX9933622 SRX9933623 SRX9933624)
ips=(SRX9933630 SRX9933631 SRX9933621 SRX9933625 SRX9933627 SRX9933628)
for(( i=0;i<${#inputs[@]};i++)) do
inputSample=${inputs[$i]}.bam
ipSample=${ips[$i]}.bam
$software_path/macs2 callpeak -t $ipSample -c $inputSample -f BAM --nomodel  --extsize 150  --outdir macs2_out -B -n ${ips[$i]}_${inputs[$i]} -q 0.05
done

## run macs2.sh
nohup sh macs2.sh oftware_path &
```

### 4 Peak calling use exomePeak2

```shell
## take 12 MeRIP-seq samples of Arabidopsis thaliana as an example
## cat id.txt
IP      Input
SRX9933630      SRX9933620
SRX9933631      SRX9933626
SRX9933621      SRX9933629
SRX9933625      SRX9933622
SRX9933627      SRX9933623
SRX9933628      SRX9933624
## cat exomePeak2.r
library("exomePeak2")
sample_list <- read.csv("id.txt",header = TRUE,sep = "\t")
sample_list <- split(sample_list,sample_list[,1])
for (id in names(sample_list)){
exp_name <- paste0("IP",sample_list[[id]]$IP,"-input",sample_list[[id]]$Input)
    ip_sample <- paste0(sample_list[[id]]$IP,".bam")
    input_sample <- paste0(sample_list[[id]]$Input,".bam")
    exomePeak2(bam_ip =ip_sample, bam_input =input_sample, gff ="ath.gtf", save_dir = getwd(),experiment_name = paste0("exomePeak2_output",exp_name))
 }
#notice :ath is the spell in a simplified form of Arabidopsis thaliana

## run exomePeak2.r
nohup Rscript exomePeak2.r &
```

### 5 Annotation Analysis

•	This process was already in the RNAmod database, please refer to RNAmod | [[http://61.147.117.195/PRMD/download.php]    
•	If you use this analysis pipeline, please cite:

> Liu, Q. and R.I. Gregory, RNAmod: an integrated system for the annotation of mRNA modifications. Nucleic Acids Res, 2019. 47(W1): p. W548-W555.

### 6 Citation

If you make use of the data and web-server presented here, please **cite our PRMD paper** [**(2023)**](http://61.147.117.195/PRMD/download.php) in addition to the primary data sources. 

The PRMD data files can be freely downloaded and used in accordance with the GNU Public License and the license of primary data sources.
