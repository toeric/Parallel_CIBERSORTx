suppressWarnings(suppressMessages(library(e1071)))
suppressWarnings(suppressMessages(library(parallel)))
suppressWarnings(suppressMessages(library(preprocessCore)))
suppressWarnings(suppressMessages(library(colorRamps)))
suppressWarnings(suppressMessages(library(bapred)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(gplots)))
suppressWarnings(suppressMessages(library(nnls)))

args <- commandArgs(trailingOnly = TRUE)
b_list_name <- args[1]
G.min <- as.numeric(args[2])
G.max <- as.numeric(args[3])
median_comb_name <- args[4]
verbose <- args[5]
result_name <- args[6]

B.list <- list()
B_list_file <- file(b_list_name, "r") 
while(TRUE) {
    line <- readLines(B_list_file, n = 1)
    if(length(line) == 0) break

    B.list = c(B.list, strsplit(line, '\t'))
}
median.comb <- read.table(median_comb_name, header=T, row.names=1, sep="\t")


# Extract top genes from list
topGenes <- function(x, top){
    if (length(x) <= top) {
        x.extracted <- x
    } else {x.extracted <- subset(x, c(rep(T, top), rep(F, length(x) - top)))
    }
    return(x.extracted)
}


# Calculate condition number
performOptimization <- function(B.list, G.min, G.max, median.comb, verbose=T) {
    k.array <- rep(NA, G.max - G.min + 1)
    for (G in G.min:G.max){
        
        # Take the G top significant genes
        BG.comb  <- unique(unlist(lapply(B.list, topGenes, top = G)))
        BG.comb.xpr <- subset(median.comb, rownames(median.comb) %in% BG.comb)
        
        # Calculate condition number using R kappa function
        k <- kappa(BG.comb.xpr, exact <- T)
        k.array[G - (G.min - 1)] <- k
    }
    G.opt <- which.min(k.array) + G.min - 1
    if (verbose) cat(paste(">Group size: ", G.opt, ", Kappa: ", min(k.array), "\n", sep = ""))
    if (verbose) cat(paste(">Best kappa:", min(k.array), "\n"))
    return(G.opt)
}


G.opt <- performOptimization(B.list, G.min, G.max, median.comb, verbose)
cat(G.opt, '\n', file=result_name)