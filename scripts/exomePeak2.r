##Take tae as a example;
library("exomePeak2")
sample_list <- read.csv("id.txt",header = TRUE,sep = "\t")
sample_list <- split(sample_list,sample_list[,1])
        for (id in names(sample_list)){
                exp_name <- paste0("IP",sample_list[[id]]$IP,"-input",sample_list[[id]]$Input)
                ip_sample <- paste0(sample_list[[id]]$IP,".bam")
                input_sample <- paste0(sample_list[[id]]$Input,".bam")
                exomePeak2(bam_ip =ip_sample, bam_input =input_sample, gff ="tae.gtf", save_dir = getwd(),experiment_name = paste0("exomePeak2_output",exp_name))
        }