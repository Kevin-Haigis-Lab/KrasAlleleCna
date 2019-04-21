#' TCGA Sample Sheet
#'
#' Contains the information of the files in the manifest. The column names
#'     were changed to a tidy format (lowercase and spaces)
#'
#' @format a tibble (1488 x 5)
#' \describe{
#'     \item{file_id}{file ID}
#'     \item{file_name}{file name}
#'     \item{data_category}{category of data (are all "Sequencing Reads")}
#'     \item{data_type}{type of data (are all "Aligned Reads")}
#'     \item{project_id}{ID of the source project (TCGA-COAD or -READ)}
#'     \item{case_id}{case ID}
#' }
#'
#' @source \url{https://portal.gdc.cancer.gov}
"tidy_tcga_sample_sheet"



#' ANNOVAR results
#'
#' A tibble of the annotation results from ANNOVAR. It was joined with the
#'     sample information. Get more information on the returned values from
#'     the \href{http://annovar.openbioinformatics.org/en/latest/}{ANNOVAR documentation}
#'
#' @format a tibble (411 x 19)
#' \describe{
#'     \item{file_id}{file ID}
#'     \item{Chr}{chromosome}
#'     \item{Start}{start of variant}
#'     \item{End}{end of variant}
#'     \item{Ref}{reference allele}
#'     \item{Alt}{alternate allele}
#'     \item{Func.refGene}{where the alteration is}
#'     \item{Gene.refGene}{gene name}
#'     \item{GeneDetail.refGene}{}
#'     \item{ExonicFunc.refGene}{type of mutation}
#'     \item{AAChange.refGene}{amino acid change}
#'     \item{aa_mod}{more usable amino acid change}
#'     \item{file_name}{name of the file}
#'     \item{data_category}{category of data (are all "Sequencing Reads")}
#'     \item{data_type}{type of data (are all "Aligned Reads")}
#'     \item{project_id}{ID of the source project (TCGA-COAD or -READ)}
#'     \item{case_id}{case ID}
#'     \item{sample_id}{sample ID}
#'     \item{sample_type}{from where the sample was taken}
#' }
#'
"annovar_tib"


#' mpileup and ANNOVAR data merged
#'
#' A tibble of both mpileup and ANNOVAR data - thus it holds the number of
#'     reads at each mutations
#'
#' @format a tibble (190 x 23)
#' \describe{
#'     \item{file_id}{file ID}
#'     \item{Chr}{chromosome}
#'     \item{Start}{start of variant}
#'     \item{End}{end of variant}
#'     \item{Ref}{reference allele}
#'     \item{Alt}{alternate allele}
#'     \item{Func.refGene}{where the alteration is}
#'     \item{Gene.refGene}{gene name}
#'     \item{GeneDetail.refGene}{}
#'     \item{ExonicFunc.refGene}{type of mutation}
#'     \item{AAChange.refGene}{amino acid change}
#'     \item{aa_mod}{more usable amino acid change}
#'     \item{total_num_reads}{total number of reads}
#'     \item{num_mut_reads}{number of mutant allele reads}
#'     \item{file_name}{name of the file}
#'     \item{data_category}{category of data (are all "Sequencing Reads")}
#'     \item{data_type}{type of data (are all "Aligned Reads")}
#'     \item{project_id}{ID of the source project (TCGA-COAD or -READ)}
#'     \item{case_id}{case ID}
#'     \item{sample_id}{sample ID}
#'     \item{sample_type}{from where the sample was taken}
#'     \item{keep}{which bam file to keep}
#'     \item{downloaded}{logical for if the file was downloaded successfully}
#' }
#'
"allele_depth_tib"


#' All data files merged
#'
#' @description Contains ANNOVAR mutation calls with the number of reads from
#'     'mpileup', copy number of the locus, and purity of the tumor sample.
#'     The allele-specific copy number was calculated from those values for
#'     each KRAS allele.
#'
#' @format a tibble (182 x 25)
#' \describe{
#'     \item{common_id}{ID shared by all data tables}
#'     \item{Chr}{chromosome}
#'     \item{Start}{start of variant}
#'     \item{End}{end of variant}
#'     \item{aa_mod}{more usable amino acid change}
#'     \item{total_num_reads}{total number of reads at this site}
#'     \item{num_mut_reads}{number of mutant reads}
#'     \item{Ref}{reference allele}
#'     \item{Alt}{alternate allele}
#'     \item{Func.refGene}{where the alteration is}
#'     \item{Gene.refGene}{gene name}
#'     \item{ExonicFunc.refGene}{type of mutation}
#'     \item{file_name}{name of the file}
#'     \item{file_id}{file ID}
#'     \item{project_id}{ID of the source project (TCGA-COAD or -READ)}
#'     \item{case_id}{case ID}
#'     \item{sample_id}{sample ID}
#'     \item{sample_type}{from where the sample was taken}
#'     \item{CNV_start}{start of the CNV call}
#'     \item{CNV_end}{end of the CNV call}
#'     \item{copy_number}{copy number at the locus}
#'     \item{purity}{purity of the tumor sample}
#'     \item{cn_mut}{copy number of the mutant allele}
#'     \item{copy_number_adj}{copy number of the locus, adjusted for purity}
#'     \item{cn_wt}{copy number of the WT allele}
#' }
"allele_data_filt"


#' CNA information from TCGA
#'
#' @description This tibble contains the CNV information on all samples in
#'     TCGA. It was downloaded from
#'     \url{https://gdc.cancer.gov/about-data/publications/pancanatlas}.
#'
#' @format a tibble (2539963 x 6)
#' \describe{
#'     \item{Sample}{sample ID}
#'     \item{Chromosome}{chromosome of the CNA}
#'     \item{Start}{start of the CNA}
#'     \item{End}{end of the CNA}
#'     \item{Num_Probes}{number of probes over the region}
#'     \item{Segment_Mean}{the CNA value equivalent to log2(copy-number/ 2)}
#' }
"cnv_tib"
