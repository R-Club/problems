#how to make ggplot
#import data and convert it in long format & for 
#converting it into long format you need "reshape2" package
install.packages("reshape2")
library(reshape2)
sample.data = read.table("sample.data.csv", header=TRUE, sep=",")
data.long=melt(sample.data, c("response"))
colnames(data.long)[2:3]=c("AA", "Conc")

# for ggplot

install.packages("ggplot2")
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

# to make the graph scale free
ggplot(data.long, aes(x=response, y=Conc, color=AA)) +
  geom_boxplot() + facet_wrap(~AA, scales = "free")
# free only y axis
ggplot(data.long, aes(x=response, y=Conc, color=AA)) +
  geom_boxplot() + facet_wrap(~AA, scales = "free_y")
# for better visualization
ggplot(data.long, aes(x=response, y=Conc, color=AA)) +
  geom_boxplot() + facet_wrap(~AA, scales = "free_y", ncol = 4)


# to apply t.test

t.test(Conc~response, data.long, mu=0, alt = "two.sided", 
       conf=0.95, Var.eq=F, paired=F)
# but we need t.test for individual Amino acids b/t R and N groups

# apply split function to split data for individual AA in both groups

split(data.long, "AA")
split.data=split(data.long,data.long$AA)

#to have a look on first AA
x = split.data[[1]]
# have a look on other AA
split.data[[2]]
split.data[[3]]

# function to do a t test and calculate the group means
ttfunct = function(x){
  # run the t test and return only the p-value
  p=t.test(x$Conc~x$response)$p.value
  # calculate the mean concentration per response
  m=tapply(x$Conc, x$response, mean)
  # return the results
  return(c(m,p))
  }

# run function on data per amino acid
tmp = lapply(split.data, FUN = ttfunct)
# convert the result to data frame
data.result = do.call(rbind,tmp)
colnames(data.result) <- c("N.mean", "R.mean", "p.value")