context("test-parse_vcf")

test_that("VCF files are properly parsed", {
    vcf_example <- "005ea64b-18e7-4f50-b940-38322a96e034_mpileup.vcf"
    vcf <- parse_vcf(vcf_example)
    expect_true(all(c("start", "ref", "alt", "num_high_qual_bases", "allelic_depths") %in% colnames(vcf)))
})
