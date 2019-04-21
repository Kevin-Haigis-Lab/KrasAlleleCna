context("test-tidy-annovar")

library(purrr)
library(tibble)
library(readr)
library(dplyr)
library(magrittr)


test_that("ANNOVAR file is properly parsed", {
    annovar_example <- tibble::tribble(
           ~Chr,   ~Start,     ~End,   ~Ref,   ~Alt,   ~Func.refGene,   ~Gene.refGene,                                         ~GeneDetail.refGene, ~ExonicFunc.refGene, ~AAChange.refGene,
        "chr12", 25205466, 25205466,    "C",    "A",          "UTR3",          "KRAS",                 "NM_004985:c.*4329G>T;NM_033360:c.*4450G>T",                  NA,         "p.A146T",
        "chr12", 25205716, 25205716,    "A",    "T",          "UTR3",          "KRAS",                 "NM_004985:c.*4079T>A;NM_033360:c.*4200T>A",                  NA,          "p.G12D",
        "chr12", 25205735, 25205736,   "TT",    "-",          "UTR3",          "KRAS", "NM_004985:c.*4060_*4059delAA;NM_033360:c.*4181_*4180delAA",                  NA,       "other_mut",
        "chr12", 25205894, 25205894,    "T",    "G",          "UTR3",          "KRAS",                 "NM_004985:c.*3901A>C;NM_033360:c.*4022A>C",                  NA,                NA,
        "chr12", 25206394, 25206394,    "A",    "T",          "UTR3",          "KRAS",                 "NM_004985:c.*3401T>A;NM_033360:c.*3522T>A",                  NA,                NA,
        "chr12", 25208318, 25208318,    "C",    "A",          "UTR3",          "KRAS",                 "NM_004985:c.*1477G>T;NM_033360:c.*1598G>T",                  NA,                NA,
        "chr12", 25209618, 25209618,    "A",    "C",          "UTR3",          "KRAS",                   "NM_004985:c.*177T>G;NM_033360:c.*298T>G",                  NA,                NA,
        "chr12", 25210151, 25210151,    "C",    "T",      "intronic",          "KRAS",                                                          NA,                  NA,                NA,
        "chr12", 25215083, 25215083,    "C",    "T",      "intronic",          "KRAS",                                                          NA,                  NA,                NA,
        "chr12", 25215150, 25215150,    "T",    "C",      "intronic",          "KRAS",                                                          NA,                  NA,                NA,
        "chr12", 25218970, 25218970,    "C",    "T",      "intronic",          "KRAS",                                                          NA,                  NA,                NA
    )


    tt <- parse_annovar_mutation(annovar_example)

    expect_true(tibble::is_tibble(tt))
    expect_equal(unique(tt$Chr), "chr12")
    expect_equal(unique(tt$Gene.refGene), "KRAS")
    expect_equal(unique(tt$Func.refGene), c("UTR3", "intronic"))
    expect_equal(unique(tt$AAChange.refGene), c("p.A146T", "p.G12D", "other_mut", NA))
    expect_equal(unique(tt$aa_mod), c("A146T", "G12D", NA))
})


test_that("ANNOVAR files are properly tidied up", {
    test_tibbles <- readRDS("test_annovar_tibbles.rds")
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
