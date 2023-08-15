#!/usr/bin/bash
inputs=(SRX9933620 SRX9933626 SRX9933629 SRX9933622 SRX9933623 SRX9933624)
ips=(SRX9933630 SRX9933631 SRX9933621 SRX9933625 SRX9933627 SRX9933628)
for(( i=0;i<${#inputs[@]};i++)) do
inputSample=${inputs[$i]}.bam
ipSample=${ips[$i]}.bam
/data2/liuqi/liuqi/miniconda3/envs/macs2/bin/macs2 callpeak -t $ipSample -c $inputSample -f BAM --nomodel  --extsize 150  --outdir macs2_out -B -n ${ips[$i]}_${inputs[$i]} -q 0.05
done