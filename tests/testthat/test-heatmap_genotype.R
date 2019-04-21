context("test-heatmap_genotype")

test_that("heatmap of genotype returns a ggplot object", {
    library(dplyr)
    library(ggplot2)
    library(KrasAlleleCna)

    cn_tib <- allele_data_filt %>%
        filter(project_id %in% c("TCGA-COAD", "TCGA-READ")) %>%
        group_by(aa_mod) %>%
        mutate(allele_count = n_distinct(common_id)) %>%
        ungroup() %>%
        mutate(cn_mut = ifelse(cn_mut < 0, 0, cn_mut),
               cn_wt = ifelse(cn_wt < 0, 0, cn_wt),
               codon = as.numeric(stringr::str_extract(aa_mod, "[:digit:]+")))

    a146t_plot <- plot_genotype_heatmap(cn_tib, "A146T")
    g12d_plot <- plot_genotype_heatmap(cn_tib, "G12D")

    expect_true(all(class(a146t_plot) == c("gg", "ggplot")))
    expect_true(all(class(g12d_plot) == c("gg", "ggplot")))

    expect_true(all(a146t_plot$data$aa_mod == "A146T"))
    expect_true(all(g12d_plot$data$aa_mod == "G12D"))

    expect_equal(length(a146t_plot$layers), 2)
    expect_equal(length(g12d_plot$layers), 2)
})
