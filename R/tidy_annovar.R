#' Parse ANNOVAR mutation
#'
#' Reads and parses an ANNOVAR file to return the amino acid change in a more
#'     understandable way in the column named \code{aa_mod}.
#'
#' @param anno_tib tibble of the ANNOVAR file
#'
#' @return Returns the tibble, checking if it is empty.
#'     If the file was empty, an empty tibble is returned. A column is added
#'     that has a simple version of the amino acid change \code{aa_mod}.
#'
#' @examples
#' extdata_dir <- system.file("extdata", package = "KrasAlleleCna")
#' annovar_file <- readRDS(file.path(extdata_dir, "annovar_output_list.rds"))[[3]]
#' annovar_file
#'
#' parsed_annovar <- parse_annovar_mutation(annovar_file)
#' parsed_annovar
#'
#' # the new column has easy to use amino acid mutations
#' parsed_annovar$aa_mod
#'
#' 
#' @importFrom magrittr %>% %<>%
#' @export parse_annovar_mutation
parse_annovar_mutation <- function(anno_tib) {
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

# for "parse_annovar_mutation"
utils::globalVariables(c("AAChange.refGene", "Chr", "aa_mod"), add = TRUE)
