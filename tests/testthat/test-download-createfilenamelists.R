context("test-download-data")

test_that("a filename is chosen", {
    correct_filename <- "TCGA_othertext.txt"
    other_filename <- "other_filename.txt"
    third_filename <- "sometest_hg19_Illumina_gdc_realn.bam"
    expect_equal(two_filename_handler(c(correct_filename, other_filename)),
                 correct_filename)
    expect_equal(three_filename_handler(c(correct_filename, other_filename, third_filename)),
                 correct_filename)
    expect_equal(choose_one_filename(c(correct_filename, other_filename, third_filename)),
                 correct_filename)
})
