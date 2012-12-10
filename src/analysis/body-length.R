## Report some statistics about the body length
##
## Usage: Rscript body_length.R

D <- read.csv('../data/results/body-length.csv', header=TRUE)

spam <- D[D$kind == "spam",]
ham <- D[D$kind == "ham",]

pluck <- function(tbl, value) {
  return(tbl[tbl$kind == value,]);
}

report <- function(rows ) {
  m <- mean(rows$words)
  print(summary(rows))
  print(paste("mean", m))
  print(paste("stddev", sd(rows$words)))
  return(m)
}

countBy <- function(rows, minv) {
  return(table(rows$words >= mall)[2])
}

print("spam")
spam <- pluck(D, "spam")
print("ham")
ham <- pluck(D, "ham")

m1 <- report(spam)
m2 <- report(ham)
mall <- round(min(m1, m2))

print(paste("Min length =", mall, "words"))
spamc <- countBy(spam, "spam")
hamc <- countBy(ham, "ham")
tot <- spamc + hamc
print(paste("spam entries of that size =", spamc, ";", round(spamc/tot*100, 2), "%"))
print(paste(" ham entries of that size =", hamc, ";", round(hamc/tot*100, 2), "%"))
print(paste("total =", tot))
