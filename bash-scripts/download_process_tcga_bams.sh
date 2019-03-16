#!/bin/bash
#!/bin/bash
#SBATCH -p short
#SBATCH -t 0-0:03
#SBATCH --mem 1G
#SBATCH -c 1
#SBATCH --mail-type ALL
#SBATCH -e array_job_logs/slurm-%A_%a.log
#SBATCH -o array_job_logs/slurm-%A_%a.log

module load gcc samtools/1.9 bcftools/1.9 annovar/20170601

# constants
# reference genome from TCGA
TCGA_REF_38=/n/no_backup2/dbmi/park/jc604/databases/reference_genomes/GRCh38.d1.vd1.fa
# read in the GDC token to access the data
GDC_TOKEN=$(<~/gdc_tokens/gdc-user-token.2019-03-04.txt)
# location of ANNOVAR databases
ANNOVAR_DB=/n/no_backup2/dbmi/park/jc604/databases/annovar_db

# get file name to download from GDC
	# $SLURM_ARRAY_TASK_ID --> array number, used as line number here
	# $1 --> file to get GDC file name from
GDC_FILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $1)

# other file names
BAM=tmp-files/${GDC_FILE}.bam
CALL_VCF=tmp-files/${GDC_FILE}_call.vcf
MPILEUP_VCF=data-raw/gdc/mpileup_output/${GDC_FILE}_mpileup.vcf
AVINPUT=tmp-files/${GDC_FILE}.avi
AVOUTPUT=data-raw/gdc/annovar_output/${GDC_FILE}

# get BAM slice of KRAS from GDC
curl \
    --header "X-Auth-Token: $GDC_TOKEN" "https://api.gdc.cancer.gov/slicing/view/${GDC_FILE}?region=chr12:25200000-25250000" \
    --output $BAM

# check if BAM is the correct format
# else print GDC_FILE to std err
if [[ "$(file $BAM)" != "${BAM}: gzip compressed data, extra field" ]]; then
	echo "${GDC_FILE}: downloaded file not a BAM" >> tmp-files/failed_downloads.txt
	exit
fi

# make BAM index file
samtools index $BAM

# call mutations
bcftools mpileup \
	-Ou \
	--fasta-ref $TCGA_REF_38 \
	$BAM | \
bcftools call \
	-m \
	-Ov \
	--output $CALL_VCF

# make annotated mpileup VCF file
bcftools mpileup \
	-Ov \
	--annotate 'INFO/AD,FORMAT/AD,FORMAT/DP' \
	--fasta-ref $TCGA_REF_38 \
	--output $MPILEUP_VCF \
	$BAM

# annotate mutations
convert2annovar.pl \
    --format vcf4 \
    --outfile $AVINPUT \
    $CALL_VCF
table_annovar.pl \
    -buildver hg38 \
    --outfile $AVOUTPUT \
    -remove \
    -protocol refGene \
    -operation g \
    -nastring NA \
    $AVINPUT \
    $ANNOVAR_DB

# remove intermediate files
rm $BAM $CALL_VCF $AVINPUT ${BAM}.bai


# Run this script as a batch array with the following command:
# sbatch --array=1-$(wc -l < input/tcga_filename_list.txt)%50 download_process_tcga_bams.sh input/tcga_filename_list.txt
