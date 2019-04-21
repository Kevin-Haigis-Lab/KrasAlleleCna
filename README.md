
<!-- README.md is generated from README.Rmd. Please edit that file -->

# KrasAlleleCna

[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Travis build
status](https://travis-ci.org/jhrcook/KrasAlleleCna.svg?branch=master)](https://travis-ci.org/jhrcook/KrasAlleleCna)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/jhrcook/KrasAlleleCna?branch=master&svg=true)](https://ci.appveyor.com/project/jhrcook/KrasAlleleCna)
[![Coverage
status](https://codecov.io/gh/jhrcook/KrasAlleleCna/branch/master/graph/badge.svg)](https://codecov.io/github/jhrcook/KrasAlleleCna?branch=master)

## Purpose

In [Poulin *et al.*
(2019)](http://cancerdiscovery.aacrjournals.org/content/early/2019/04/05/2159-8290.CD-18-1220),
the authors studied the specific oncogenic properties of *KRAS* A146T
mutations, a hotspot-mutation only found in colorectal adenocarcinma
(CRC). For this paper, I was asked to find out whether there was a
difference in the copy number of the mutant allele between human CRC
patients with G12D (the most common *KRAS* oncogenic mutation) and A146T
mutations. Not only would a difference suggest that dosage is an
important factor, but could also point to differences in interactions
with the wild-type (WT) allele \[[Zhou *et al.*,
2016](https://www.ncbi.nlm.nih.gov/pubmed/27422332), [Lin and
Haigis, 2018](https://www.ncbi.nlm.nih.gov/pubmed/29425486)\].

This analysis was divided into 4 parts: A) downloading the data, B)
processing the data, C) calculating the allele copy number, and D)
analyzing the results.

## Conclusions

There was no detectable difference between the copy number of the G12D
or A146T *KRAS* alleles.

The below plot showed the copy number of the mutant and WT allele in
G12D and A146T samples.

``` r
cn_tib <- allele_data_filt %>%
    filter(project_id %in% c("TCGA-COAD", "TCGA-READ")) %>%
    group_by(aa_mod) %>%
    mutate(allele_count = n_distinct(common_id)) %>%
    ungroup() %>%
    mutate(cn_mut = ifelse(cn_mut < 0, 0, cn_mut),
           cn_wt = ifelse(cn_wt < 0, 0, cn_wt),
           codon = as.numeric(str_extract(aa_mod, "[:digit:]+")))
cn_tib %>%
    mutate(aa_mod = forcats::fct_reorder(aa_mod, codon)) %>%
    filter(aa_mod %in% c("A146T", "G12D")) %>%
    mutate(diff = cn_mut - cn_wt) %>%
    ggplot() +
    facet_grid(. ~ aa_mod) +
    geom_segment(aes(x = "mutant", xend = "wild type",
                     y = cn_mut, yend = cn_wt,
                     color = diff)) +
    geom_point(aes(x = "mutant", y = cn_mut, color = diff), size = 1) +
    geom_point(aes(x = "wild type", y = cn_wt, color = diff), size = 1) +
    scale_color_gradient(low = "blue", high = "red") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.major = element_line(color = "grey85"),
          legend.key.height = unit(0.2, "in"),
          legend.key.width = unit(0.1, "in"),
          axis.ticks = element_line("grey85"),
          strip.background = element_blank()) +
    labs(x = "allele", y = "copy number",
         title = "Copy number of both alleles in KRAS mutants",
         color = "CN difference")
#> Warning: Removed 10 rows containing missing values (geom_segment).
#> Warning: Removed 10 rows containing missing values (geom_point).

#> Warning: Removed 10 rows containing missing values (geom_point).
```

<img src="man/figures/README-lateralplot-1.png" width="100%" />

Though there seems to be increased amplification in human tumor samples,
the number of available samples limited the power of the study.

Heatmaps of the genotypes of the samples highlighted that the most
common genotype was 1 mutant : 1 WT allele.

``` r
plot_genotype_heatmap(cn_tib, "A146T")
```

<img src="man/figures/README-genotypeheatmap-1.png" width="100%" />

``` r
plot_genotype_heatmap(cn_tib, "G12D")
```

<img src="man/figures/README-genotypeheatmap-2.png" width="100%" />
