#' Plot genotype heatmaps
#'
#' @description Plot the genotypes of mutant samples by allele as a heatmap.
#'     See vignette "D.01 - Plot Allele-specific Copy Number Results" for how
#'     to use this function. It was made into a function primarily so it could
#'     also be used in the README.
#'
#' @param tib copy number information
#' @param allele allele to plot for
#'
#' @import dplyr
#' @import ggplot2
#' @importFrom rlang !!
#' @export plot_genotype_heatmap


plot_genotype_heatmap <- function(tib, allele) {
    hm <- tib %>%
        filter(aa_mod == !!allele) %>%
        mutate(cn_mut_round = round(cn_mut),
               cn_wt_round = round(cn_wt)) %>%
        group_by(aa_mod, cn_mut_round, cn_wt_round) %>%
        summarise(num = n_distinct(common_id)) %>%
        ungroup() %>%
        group_by(aa_mod) %>%
        mutate(freq = num / n()) %>%
        ungroup() %>%
        stats::na.omit() %>%
        ggplot(aes(x = cn_wt_round, y = cn_mut_round)) +
        geom_tile(aes(fill = freq)) +
        geom_label(aes(label = num),
                   fill = "grey35", color = "white",
                   fontface = "bold", size = 5) +
        scale_fill_gradient(low = "blue", high = "red") +
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_line(color = "black",
                                              size = 0.5),
              legend.position = "none",
              panel.background = element_rect(fill = "white"),
              panel.border = element_rect(color = "black",
                                          fill = NA,
                                          size = 0.5),
              axis.ticks = element_blank()) +
        labs(title = paste("Genotype heatmap for", allele, "mutants"),
             x = "WT allele copy number",
             y = "mutant allele copy number") +
        scale_y_continuous(expand = c(0, 0),
                           breaks = c(0, 1, 2, 3),
                           minor_breaks = seq(0.5, 3.5, 0.5)) +
        scale_x_continuous(expand = c(0, 0),
                           breaks = c(0, 1, 2, 3),
                           minor_breaks = seq(0.5, 3.5, 0.5))
    return(hm)
}

utils::globalVariables(
    c("cn_mut",
      "cn_mut_round",
      "cn_wt",
      "cn_wt_round",
      "common_id",
      "freq",
      "num"),
    add = TRUE)
