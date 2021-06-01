suppressWarnings(suppressMessages(library(e1071)))
suppressWarnings(suppressMessages(library(parallel)))
suppressWarnings(suppressMessages(library(preprocessCore)))
suppressWarnings(suppressMessages(library(colorRamps)))
suppressWarnings(suppressMessages(library(bapred)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(gplots)))
suppressWarnings(suppressMessages(library(nnls)))

args <- commandArgs(trailingOnly = TRUE)
dd_file <- args[1]
i_file <- args[2]
mixture_cols_file <- args[3]
n_GEPs <- type.convert(args[4])     # dim(x)[2]
n_mixtures <- type.convert(args[5]) # dim(y)[2]
adjusted_file <- args[6] # paste(outdir, "/CIBERSORTx_",label,'Mixtures_Adjusted.txt', sep="")

dd <- data.matrix(fread(dd_file, header=F, sep="\t"))
i <- scan(i_file, character(), quote = "", sep="\t")
mixture_col_names <- scan(mixture_cols_file, character(), quote = "", sep="\t", quiet=T)

cbat <- combatba(x=t(log(dd+1,2)),batch=as.factor(c(rep(1, n_GEPs), rep(2, n_mixtures))))
cbat=2^t(combatbaaddon(params=cbat,x=t(log(dd+1,2)),batch=as.factor(c(rep(1, n_GEPs),rep(2, n_mixtures)))))

p <- n_GEPs+1
mixturec <- cbat[,p:dim(dd)[2]]
mixturec <- cbind(i, mixturec)
mixturec <- rbind(c("GeneSymbol", mixture_col_names), mixturec)
write.table(mixturec, file=adjusted_file, sep="\t", quote=FALSE, col.names = F, row.names = F)