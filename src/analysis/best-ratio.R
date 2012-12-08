## Determine the best ratio of spam to ham
##
## Assumes the ratio CSV is located at ../data/results/ratio.csv
##
## Usage: Rscript best_ratio.R
##

D <- read.csv('../data/results/ratio-3k001-5x.csv', header=TRUE)

## best accuracy
## bestAcc <- which(D == max(D$accuracy), arr.ind=TRUE)
## fullRow <- D[bestAcc[1],]
## thoseSteps <- D[D$step == fullRow$step,]

uniqs <- unique(D$step)
n <- length(uniqs)

cleaned <- data.frame(step=rep(NA,n),
                      meanAcc=rep(NA,n),
                      sdAcc=rep(NA,n),
                      meanPrec=rep(NA,n),
                      sdPrec=rep(NA,n),
                      meanRecall=rep(NA,n),
                      sdRecall=rep(NA,n),
                      meanTp=rep(NA, n),
                      sdTp=rep(NA, n),
                      meanTn=rep(NA, n),
                      sdTn=rep(NA, n),
                      meanFp=rep(NA, n),
                      sdFp=rep(NA, n),
                      meanFn=rep(NA, n),
                      sdFn=rep(NA, n)
                      )

meanAndSd <- function(rows, var) {
  col <- rows[,var]
  return(c(mean(col), sd(col)))
}

attrs <- c("accuracy", "precision", "recall", "tp", "tn", "fp", "fn")
for(i in 1:n) {
  step <- uniqs[i]
  rows <- D[which(D$step == step),]
  tmp <- c(step)
  for(j in 1:length(attrs)) {
    tmp <- c(tmp, meanAndSd(rows, attrs[j]))
  }
  cleaned[i,] <- tmp
}

decent <- cleaned[cleaned$meanTp > 0 & cleaned$meanTn > 0 & cleaned$meanAcc > 0.85 & cleaned$meanRecal > 0.8 & cleaned$meanPrec > 0.89,]
head(decent[order(decent$meanAcc),], 10)

write.table(decent, file="ratio-means.csv", sep=",", row.names=FALSE)
