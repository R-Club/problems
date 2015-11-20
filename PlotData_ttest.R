############################################################
# MHH & Twincore R Club                                    #
# 2015-11-18                                               #
# Problem presented by Haroon                              #
############################################################

#### import data ####
## import data and convert it in long format & for 
## converting it into long format you need "reshape2" package
# install.packages("reshape2")  # uncomment if you dont have reshape2 installed
library(reshape2)
sample.data <- read.table("sample.data.csv", header=TRUE, sep=",")
data.long   <- melt(sample.data, c("response"))
colnames(data.long)[2:3] <- c("AA", "Conc")

#### Plotting the data ####
# install.packages("ggplot2")  # uncomment if you dont have ggplot2 installed
#require(ggplot2)
## Additional comment from Sarah: You shouldn't actually use require() like this
## and here is why: http://yihui.name/en/2014/07/library-vs-require/
## Basically, require() is (or should be) only used inside functions.

library(ggplot2)
# barplot
ggplot(data.long, aes(x=response, y=Conc, fill=AA)) +
  geom_bar(stat="identity", position = position_dodge())
# scatter plot
ggplot(data.long, aes(x=response, y=Conc, color=AA)) +
  geom_point()
# for plotting individual Amino acids
ggplot(data.long, aes(x=response, y=Conc, color=AA)) +
  geom_point() + facet_wrap(~AA)
# for boxplot
ggplot(data.long, aes(x=response, y=Conc, color=AA)) +
  geom_boxplot() + facet_wrap(~AA)


## optimization of graph:
## graphs use same x/y scales and data is not always in the same range
## for each AA. Free scales ephasize the differences in each AA
ggplot(data.long, aes(x=response, y=Conc, color=AA)) +
  geom_boxplot() + facet_wrap(~AA, scales = "free")
## With scales = "free" each facet gets its own x-axis lables. this is
## unnecessary because x-axis labels/limits are the same accross all plots
## use "free_y" instead.
ggplot(data.long, aes(x=response, y=Conc, color=AA)) +
  geom_boxplot() + facet_wrap(~AA, scales = "free_y")
## facets look crowded, it may be helpful to limit the numer of facet columns
## limit facets to 4 columns for better presentation of the data
ggplot(data.long, aes(x=response, y=Conc, color=AA)) +
  geom_boxplot() + facet_wrap(~AA, scales = "free_y", ncol = 4)


## statistical testing example with t.test
t.test(Conc~response, data.long, mu=0, alt = "two.sided", 
       conf=0.95, Var.eq=F, paired=F)
## this tests for differences in AA Concentration in responder and
## non-responder group but does not differentiate between the AA.
## We need a solution that tests for each AA between R and N groups.

## Use the split function to split data for individual AA
## return data ist a list of data frames, 1 df for each AA.
split.data <- split(data.long,data.long$AA)

## to have a look at the data
## be carefult to use [[ as operator for list indexing 
## as [ would return a list and not the object stored at this list
## position.
str(split.data)
split.data[[1]]
split.data[[2]]
split.data[[3]]

## extract the first df to a new object (aa1) for further development
aa1 <- split.data[[1]]

#### solve the problem in general and apply the solution to all parts
## of the problem
simpleTTfunc <- function(x) {
  t.test(x$Conc ~ x$response)
}
## test the function on the extracted data
simpleTTfunc(aa1)

## use lapply (list-apply) the function to all elements of the split.data list
lapply(list, simpleTTfunc)

## this approach can be elaborated:
otherTTfunc <- function(x){
  p <- t.test(x$Conc~x$response)$p.value  # run the t test and return only the p-value
  m <- tapply(x$Conc, x$response, mean)   # calculate the mean concentration per group
  s <- tapply(x$Conc, x$response, sd)
  # return the results
  c(AA=AA[1], m[1], s[1], m[2], s[2], pval=p)  # you do not need an explicit return() statement in R
  }

## run function on data per amino acid
## lapply returns a list!
tmp <- lapply(split.data, otherTTfunc)

## to convert the list into a useable data frame we use 
## rbind() to bind all elements to da dataframe
data.result <- do.call(rbind,tmp)