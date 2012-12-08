## Report some statistics about the body length
##
## Usage: Rscript body_length.R

D <- read.csv('../data/results/body-length.csv', header=TRUE)

spam <- D[D$kind == "spam",]
ham <- D[D$kind == "ham",]

report <- function(tbl, field) {
  rows <- tbl[tbl$kind == field,]
  m <- mean(rows$words)
  print(field)
  print(summary(rows))
  print(paste("mean", m))
  print(paste("stddev", sd(rows$words)))
  return(m)
}

m1 <- report(D, "spam")
m2 <- report(D, "ham")

print(paste("Min length =", floor(min(m1, m2)), "words"))
