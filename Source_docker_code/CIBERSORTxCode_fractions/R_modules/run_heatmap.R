suppressWarnings(suppressMessages(library(e1071)))
suppressWarnings(suppressMessages(library(parallel)))
suppressWarnings(suppressMessages(library(preprocessCore)))
suppressWarnings(suppressMessages(library(colorRamps)))
suppressWarnings(suppressMessages(library(bapred)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(gplots)))
suppressWarnings(suppressMessages(library(nnls)))

args <- commandArgs(trailingOnly = TRUE)
sign.matrix.file <- args[1]

sign.matrix <- read.table(sign.matrix.file, header=T, sep="\t")

pdf(file = paste(strsplit(sign.matrix.file, ".txt")[[1]][1], '.pdf', sep=""), width = 10, height = 10)
heatmap(data.matrix(sign.matrix[,2:ncol(sign.matrix)]), col = blue2red(50), margins=c(15,5),labRow=NA ,ylab=)
capture.output(dev.off(), file='/dev/null')