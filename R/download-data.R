#' Select the best filename to keep
#'
#' @description Some cases in the sample sheet have multiple files.
#'     `choose_one_filename()`uses a set of (fairly arbitrary) checks to select
#'     one filename. `two_filename_handler()` and `three_filename_handler()`
#'     parse two or three file names based on my heuristics for which is most
#'     likely to be more useful.
#'
#' @param fn vector of filenames
#'
#' @return a single filename from the input vector that should be retained
#'
#' @examples
#' test_fns <- c("TCGA-A6-2672-01B-03D-2301-10_Illumina_gdc_realn.bam",
#'               "C982.TCGA-A6-2672-01B-03D-2298-08.2_gdc_realn.bam")
#' choose_one_filename(test_fns)
#'
#' @importFrom stringr str_detect str_subset
#' @importFrom magrittr %>%
#' @export choose_one_filename
choose_one_filename <- function(fn) {
    # return singles
    if (length(fn) == 1) {
        return(fn)
    }

    if (length(fn) == 2) {
        keep_fn <- two_filename_handler(fn)
    } else if (length(fn) == 3) {
        keep_fn <- three_filename_handler(fn)
    } else {
        keep_fn <- fn
    }

    if (length(keep_fn) == 1) {
        return(keep_fn)
    } else {
        cat_multiple_file_msg(keep_fn)
        return(keep_fn[[1]])
    }

}

#' @rdname choose_one_filename
#' @importFrom stringr str_detect str_subset
#' @export three_filename_handler
two_filename_handler <- function(fn) {
    if (sum(str_detect(fn, "^TCGA")) == 1) {
        keep_fn <- str_subset(fn, "^TCGA")
    } else if (sum(str_detect(fn, "-[:digit:]{2}D-")) == 1 &
               sum(str_detect(fn, "-[:digit:]{2}W-")) == 1) {
        keep_fn <- str_subset(fn, "-[:digit:]{2}D-")
    } else if (sum(str_detect(fn, "hg19_Illumina_gdc_realn.bam$")) == 1) {
        keep_fn <- fn[!str_detect(fn, "hg19_Illumina_gdc_realn.bam$")]
    } else if (any(str_detect(fn, "-01A-"))) {
        keep_fn <- str_subset(fn, "-01A-")
    } else {
        keep_fn <- fn
    }
    return(keep_fn)
}

#' @rdname choose_one_filename
#' @importFrom stringr str_detect str_subset
#' @export three_filename_handler
three_filename_handler <- function(fn) {
    if (sum(str_detect(fn, "hg19_Illumina_gdc_realn.bam$")) == 1) {
        keep_fn <- fn[!str_detect(fn, "hg19_Illumina_gdc_realn.bam$")]
    } else {
        keep_fn <- fn
    }

    if (length(keep_fn) == 2) {
        keep_fn <- two_filename_handler(keep_fn)
    }
    return(keep_fn)
}

# print a message that there is more than one file and list file names
cat_multiple_file_msg <- function(fn) {
    cat("multiple files:\n\t", paste(fn, collapse = "\n\t"), "\n", sep = "")
}
