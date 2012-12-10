## Analyze the various classifier models based on cross-validation results
##
## Assumes the ratio CSV is located at ../data/results/all-models.csv
##
## Usage: Rscript best-model.R
##

CV <- read.csv('../data/results/models-cv.csv', header=TRUE)
T <- read.csv('../data/results/models-test.csv', header=TRUE)

wordGrams <- function(df) {
  return(subset(df, (tokenizer %in% c("unigram", "bigram", "trigram"))))
}

charGrams <- function(df) {
  return(subset(df, (tokenizer %in% seq(1, 6))))
}

phonoGrams <- function(df) {
  return(subset(df, (tokenizer %in% c("metaphone", "bimetaphone"))))
}

## kind == cv or test
writeGrams <- function(kind, name, grams) {
  write.table(grams, file=paste("../data/results/model.", kind, ".", name, ".csv", sep=""), sep=",", row.names=FALSE)
}

writeOut <- function(df, kind) {
  writeGrams(kind, "word", wordGrams(df))
  writeGrams(kind, "char", charGrams(df))
  writeGrams(kind, "phono", phonoGrams(df))
}

writeOut(CV, "cv")
writeOut(T, "test")
