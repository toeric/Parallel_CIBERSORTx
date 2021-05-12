suppressWarnings(suppressMessages(library(e1071)))
suppressWarnings(suppressMessages(library(parallel)))
suppressWarnings(suppressMessages(library(preprocessCore)))
suppressWarnings(suppressMessages(library(colorRamps)))
suppressWarnings(suppressMessages(library(bapred)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(gplots)))
suppressWarnings(suppressMessages(library(nnls)))

# output format: 
#     > each row contains the feature weights of an SVR trained with 
#         X = <X param> and y = corresponding column of <Y param> 
#     > each column in Y will result in length(nus) rows, with order preserved 
#         (since every option for nu tested)

args <- commandArgs(trailingOnly = TRUE)
X_file <- args[1]
Y_file <- args[2]
reg <- type.convert(args[3])
nus_file <- args[4]
outfile <- args[5]


X <- data.matrix(fread(X_file, header=F, sep="\t"))
Y <- data.matrix(fread(Y_file, header=F, sep="\t"))
nus <- data.matrix(fread(nus_file, header=F, sep="\t"))[1,]

writeVec <- function(v, filename) {
    cat(paste(v, collapse="\n"), file=filename)
}

res <- function(i, y){
    nu <- nus[i]

    # === DEBUGGING
    X <- round(X, 10)
    y <- round(y, 10)
    # === DEBUGGING

    model<-svm(X, y,type="nu-regression",kernel="linear",nu=nu,cost=reg,scale=F)
    model
}

results = matrix(, nrow=dim(Y)[2]*length(nus), ncol=dim(X)[2])
for(j in 1:dim(Y)[2]) {
    out <- mclapply(1:length(nus), res, Y[,j], mc.cores=length(nus))
    for(t in 1:length(nus))
        results[(j-1)*length(nus) + t, ] = t(out[[t]]$coefs) %*% out[[t]]$SV  # weights
}

write.table(results, outfile, sep="\t", col.names=F,row.names=F)
