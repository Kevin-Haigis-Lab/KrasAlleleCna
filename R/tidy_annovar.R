#' Parse ANNOVAR files
#'
#' Reads and parses an ANNOVAR file
#'
#' @param fname ANNOVAR file name
#'
#' @return a tibble of the results. IF the file was empty, an empty tibble
#'     was returned
#'
#' @importFrom magrittr %>% %<>%
#' @export parse_annovar
parse_annovar <- function(fname) {
    anno_tib <- readr::read_tsv(fname, col_type = "cddccccccc")
    if (nrow(anno_tib) == 0) {
        # if empty, set to all NAs and continue in pipeline
        anno_tib <- tibble::tibble(Chr = NA,
                                   Start = NA,
                                   End = NA,
                                   Ref = NA,
                                   Alt = NA,
                                   Func.refGene = NA,
                                   Gene.refGene = NA,
                                   GeneDetail.refGene = NA,
                                   ExonicFunc.refGene = NA,
                                   AAChange.refGene = NA) %>%
            dplyr::slice(0)
    }
    # parse amino acid modification (aa_mod)
    anno_tib %<>%
        dplyr::mutate(aa_mod = stringr::str_extract(AAChange.refGene,
                                                    "(?<=p\\.)[:alnum:]+"),
               aa_mod = ifelse(is.na(Chr), "WT", aa_mod))
    return(anno_tib)
}
