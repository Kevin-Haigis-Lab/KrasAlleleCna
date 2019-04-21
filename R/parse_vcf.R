#' Parse a VCF file
#'
#' @description Parse the read-depth information of a VCF file.
#'
#' @param fname path to the file
#'
#' @return a tibble
#'
#' @examples
#' # TODO
#'
#' @importFrom stringr str_split_fixed str_remove_all
#' @export parse_vcf
parse_vcf <- function(fname) {
    # find the start of the data in the VCF file and read
    header_line <- grep("#CHROM", readLines(fname)) - 1
    v <- readr::read_tsv(fname,
                         col_type = "cdcccdcccc",
                         skip = header_line)
    colnames(v) <- c("chr", "start", "id", "ref", "alt", "qual", "filter",
                     "info", "format", "read_info")
    # breakout the information held in FORMAT
    # FORMAT = PL:DP:AD
        #  x PL = "List of Phred-scaled genotype likelihoods"
        #  * DP = "Number of high-quality bases"
        #  * AD = "Allelic depths"
    v %<>%
        dplyr::select(start, ref, alt, qual, read_info) %>%
        dplyr::mutate(num_high_qual_bases = str_split_fixed(read_info, ":", 3)[, 2],
                      allelic_depths = str_split_fixed(read_info, ":", 3)[, 3],
                      allelic_depths = str_remove_all(allelic_depths, ",0$"))
    return(v)
}



utils::globalVariables(
    c("start",
      "ref",
      "alt",
      "qual",
      "read_info",
      "allelic_depths"),
    add = TRUE
)
