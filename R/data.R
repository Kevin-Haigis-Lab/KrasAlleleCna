#' TCGA Manifest
#'
#' Manifest file downloaded from the GDC Data Portal. It contains all raw
#'     sequencing files available for TCGA-COAD, READ, PAAD, and DLBC, and
#'     TARGET-AML (not all samples were available from TARGET)
#'
#' @format a tibble (1488 x 5)
#' \describe{
#'   \item{id}{file ID}
#'   \item{filename}{filen ame}
#'   \item{md5}{MD5 value for checking download success}
#'   \item{size}{file size (bytes(?))}
#'   \item{state}{internal TCGA information}
#' }
#'
#' @source \url{https://portal.gdc.cancer.gov}
"tcga_manifest"


#' TCGA Sample Sheet
#'
#' Contains the information of the files in the manifest.
#'
#' @format a tibble (1488 x 5)
#' \describe{
#'     \item{File ID}{file ID}
#'     \item{File Name}{file name}
#'     \item{Data Category}{data category (eg. reads, mutations, etc.)}
#'     \item{Data Type}{data type}
#'     \item{Project ID}{ID of the source project (TCGA-COAD or -READ)}
#'     \item{Case ID}{case ID}
#' }
#'
#' @source \url{https://portal.gdc.cancer.gov}
"tcga_sample_sheet"

#' Failed GDC Downloads
#'
#' A list of file names where the download from GDC failed
#'
#' @format a character vector
"failed_downloads"
