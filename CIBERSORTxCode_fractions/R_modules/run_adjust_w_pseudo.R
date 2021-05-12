suppressWarnings(suppressMessages(library(e1071)))
suppressWarnings(suppressMessages(library(parallel)))
suppressWarnings(suppressMessages(library(preprocessCore)))
suppressWarnings(suppressMessages(library(colorRamps)))
suppressWarnings(suppressMessages(library(bapred)))
suppressWarnings(suppressMessages(library(data.table)))
suppressWarnings(suppressMessages(library(gplots)))
suppressWarnings(suppressMessages(library(nnls)))


args <- commandArgs(trailingOnly = TRUE)

filenum <- type.convert(args[1])
fracs_null <- type.convert(args[2])
fractions_file <- args[3]
xl_file <- args[4]
x_file <- args[5]
rnames_file <- args[6]
non_adj_file <- args[7]
statefile <- args[8]
seed <- type.convert(args[9])
RNGtype <- type.convert(args[10])

out_mixtures_adjusted <- args[11]
out_simfracs <- args[12]
out_adj_save <- args[13]

# load existing RNG state or create new one
if(RNGtype == "0") {
    set.seed(seed)
} else {
    set.seed(seed, "L'Ecuyer-CMRG")
}
if(file.exists(statefile))
    .Random.seed <- scan(statefile, what=integer(), quiet=TRUE)

fractions <- read.table(fractions_file,sep="\t",header=T,check.names=F) 
xl <- scan(xl_file, character(), quote = "", sep="\t", quiet=T)
x <- data.table(read.table(x_file,sep="\t",header=T, check.names=F))
rnames <- scan(rnames_file, character(), quote = "", sep="\t", quiet=T)
non.adj <- read.table(non_adj_file,sep="\t",header=T, row.names=1, check.names=F)

st.dev = function(x){x*2}

# Create same number of pseudomixtures as number of mixtures
for(i in 1:filenum){
    if (fracs_null){
        simfrac <- fractions
        # Create pseudomixtures by sampling each cell type from a distribution with the cell type fractions as mean and standard deviation set to 2*fractions
        simfrac <- pmax(0,sapply(1:length(unique(xl)), function(i) rnorm(mean=as.numeric(fractions[i]),sd=st.dev(as.numeric(fractions[i])),1)))
        while (identical(simfrac, rep(0, length(simfrac)))) {
            simfrac <- pmax(0,sapply(1:length(unique(xl)), function(i) rnorm(mean=as.numeric(fractions[i]),sd=st.dev(as.numeric(fractions[i])),1)))
        }
    } else {
        simfrac <- fractions[i,]
    }
    simfrac <- pmax(2,round(length(xl)*simfrac/sum(simfrac)))
    if(i==1) simfracs <- simfrac
    else{simfracs <- rbind(simfracs,simfrac)}
    
    samples <- sort(as.numeric(unlist(sapply(1:length(unique(xl)), function(i) sample(which(xl==names(table(xl))[i]),simfrac[i],replace=T)))))
    xsum <- x[,Reduce('+',.SD),.SDcols=samples]
    names(xsum) <- rnames
    
    inter <- intersect(rnames,rownames(non.adj))
    xsum <- xsum[inter]
    if(i==1) {
        m <- xsum
        names(m) <- inter
    }
    else{
        if(i==2) {
            inter2 <- intersect(names(m), inter)
            m <- cbind(m[inter2],xsum[inter2])
        }
        if(i>2) {
            inter2 <- intersect(rownames(m), inter)
            m <- cbind(m[inter2,],xsum[inter2])
        }
    }
}
colnames(simfracs) = names(table(xl))
m[is.na(m)] <- 1

inter <- intersect(rownames(m),rownames(non.adj))
m <- cbind(m[inter,], non.adj[inter,])

tmpcol <- colnames(m)
rs<-colSums(m)
rs_med<-median(rs)

tmp <- rownames(m)
m <- sapply(1:ncol(m), function(i) m[,i]*(1e6/rs[i]))
rownames(m) <- tmp
colnames(m) <- tmpcol

vars <- apply(m,1,var)
m<- m[which(vars>0),]

#learn parameters
dd<-log(m[,c(1:c(filenum+filenum))]+1,2)
dd[is.na(dd)] = 0
cbat=combatba(x=t(dd),batch=as.factor(c(rep(1,filenum),rep(2,filenum))))

#apply parameters to rest of mixture
dd<-log(m[,c(1:c(filenum+filenum))]+1,2)
dd[is.na(dd)] = 0
sm_adjust <- t(combatbaaddon(params=cbat,x=t(dd),batch=as.factor(c(rep(1,filenum),rep(2,filenum)))))

#write to disk
adjusted <- adj.save <- (2^sm_adjust)-1
adjusted <- cbind(rownames(adjusted),adjusted)
colnames(adjusted) = c("GeneSymbol", c(1:filenum), colnames(non.adj))

write.table(adjusted[,c(1, (filenum+2):ncol(adjusted))], out_mixtures_adjusted, sep="\t", quote=F, row.names=F,col.names=T)
write.table(simfracs, out_simfracs, sep="\t", quote=F, row.names=T,col.names=T)
write.table(adj.save, out_adj_save, sep="\t", quote=F, row.names=T,col.names=T)

# preserve RNG state for the next script call
cat(paste(.Random.seed, collapse='\t'), file=statefile) 
