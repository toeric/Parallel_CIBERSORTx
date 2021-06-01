suppressWarnings(suppressMessages(library(e1071)))
suppressWarnings(suppressMessages(library(parallel)))
suppressWarnings(suppressMessages(library(preprocessCore)))
suppressWarnings(suppressMessages(library(colorRamps)))
suppressWarnings(suppressMessages(library(bapred)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(gplots)))
suppressWarnings(suppressMessages(library(nnls)))

args <- commandArgs(trailingOnly = TRUE)
in_file <- args[1]
out_file <- args[2]

Z <- fread(in_file, header=F, sep="\t")
Z <- data.matrix(Z)
Z <- normalize.quantiles(Z)
write.table(Z, out_file, row.names=F, col.names=F, sep='\t')