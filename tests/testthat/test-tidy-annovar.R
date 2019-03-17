context("test-tidy-annovar")

library(purrr)
library(tibble)
library(readr)
library(dplyr)
library(magrittr)

test_that("ANNOVAR files are properly tidied up", {
    test_files <- list.files("test_annovar_files", full.name = TRUE)
    test_tibbles <- purrr::map(test_files, read_tsv)
    names(test_tibbles) <- basename(test_files)

    expect_true(all(purrr::map_lgl(test_tibbles, is_tibble)))

    tidy_tibbles <- purrr::map(test_tibbles, parse_annovar_mutation)

    expect_true(all(purrr::map_lgl(tidy_tibbles, is_tibble)))

    anno_tib <- bind_rows(tidy_tibbles, .id = "file_id")

    expect_true(is_tibble(anno_tib))

    correct_column_names <- c(
        "file_id", "Chr", "Start", "End", "Ref", "Alt",
        "Func.refGene", "Gene.refGene", "GeneDetail.refGene",
        "ExonicFunc.refGene", "AAChange.refGene", "aa_mod"
    )

    expect_true(all(colnames(anno_tib) %in% correct_column_names))
})
