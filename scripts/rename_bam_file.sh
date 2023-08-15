##Convert srrid_name bam file to srxid_name bam file, the file sra2srx_id is needed
awk '{print "mv""\t"$1"Aligned.sortedByCoord.out.bam""\t"$2".bam"}' sra2srx_id >>rename_bam_file.sh
sh rename_bam_file.sh