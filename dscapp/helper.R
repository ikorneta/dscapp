#tokenise
itoken <- function(x)
{
  x <- tolower(x)
  x <- removeNumbers(x)
  x <- removePunctuation(x)
  x <- gsub("[^[:print:]]","", x)
  #x <- stemDocument(x)
  x <- stripWhitespace(x)

  a <- matrix(unlist(strsplit(x, " ")))

return(a)
}

#find the last howmany words of a given phrase
lastwords <- function(x, howmany)
{
  a <- matrix(x[(length(x)-howmany+1):length(x)]) 
  a <- apply(a, MARGIN = 2, FUN = function(x){ paste(x, collapse=" ")})

return(a)
}


#search
findpartial <- function(x, dt, weight)
{
  dttemp <- dt[x] 
  dttemp <- dttemp[order(dttemp$freq, decreasing=TRUE),][1:4]
  dttemp$weighted <- dttemp$freq*weight
  setkey(dttemp, prefix)
  dttemp <- dttemp[x]
  dttemp
}


#main function
findanswer <- function(x, dt1, dt2, dt3)
{
  tokens <- itoken(x)
  weights <- c(0.47, 0.31, 0.21, 0.01)
  needs <- 4
  answertable <- data.table(prefix=NA, answer=NA, freq=NA, weighted=NA)

#examining the 4-gram table
  if (length(tokens) > 2)
  {token <- lastwords(tokens, 3)
  answertable <- findpartial(token, dt1, weights[1])
  if (!is.na(answertable[1,1, with=FALSE])){needs <- 4-nrow(answertable)}
  }

#examining the 3-gram table
  if ((needs > 0) & (length(tokens) > 1))
  {token <- lastwords(tokens, 2)
  partial <- findpartial(token, dt2, weights[2])
  if (!is.na(answertable[1,1, with=FALSE])){answertable <- rbind(answertable, partial)}
  else {answertable <- partial}
  if (!is.na(answertable[1,1, with=FALSE])){needs <- 4-nrow(answertable)}
  }

#examining the 2-gram table
  if (needs > 0 & (length(tokens) > 0))
  {token <- tokens[length(tokens)]
  partial <- findpartial(token, dt3, weights[3])
  if (!is.na(answertable[1,1, with=FALSE])){answertable <- rbind(answertable, partial)}
  else {answertable <- partial}
  if (!is.na(answertable[1,1, with=FALSE])){needs <- 4-nrow(answertable)}
  }

#adding a pro-forma answer
  if ((needs > 0) & (length(tokens) > 0))
  {
  token <- tokens[length(tokens)]
  if (!is.na(answertable[1,1, with=FALSE])){answertable <- rbind(answertable, data.frame(prefix=token, answer="that", freq=1, weighted=weights[4]))}     
  else  
  {answertable <- data.table(prefix=token, answer="that", freq=1, weighted=weights[4])
  }
  }

#aggregating the results
answertable2 <- answertable[, sum(weighted), by=answer]
setnames(answertable2, c("answer", "confidence (%)"))
answertable2[,2] <- 100* answertable2$confidence/sum(answertable2$confidence)

return(answertable2)
}
