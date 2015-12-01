############################################################
# MHH & Twincore R Club                                    #
# 2015-11-25                                               #
# Problem presented by Haroon                              #
############################################################

#### Question ####
# How can you split a column with "Ct1" (condition + replicate number) into two
# columns, for condition and replicate, respectively?


#### import data ####
# import data and convert it in long format
# for converting it into long format you need "reshape2" package
library(reshape2)
data <- read.csv("test.csv", header = T)
data.long <- melt(data, c("timepoint"))
colnames(data.long)[2:3]=c("treatment", "Conc")


#### things Haroon tried ####
# lets try to split treatment column 
do.call(rbind,strsplit(data.long$treatment,""))
# error massage because the "treatment" column contains factors, not strings

#lets try string split
strsplit(data.long, "")
# error message because this needs a vector as input, not a whole data.frame

# check the structure of the data
str(data.long)
head(data.long)


#### working solution ####

# to solve this problem first convert treatment into a character vector
data.long$treatment <- as.character(data.long$treatment)
str(data.long)

# 1st step we need to remove numbers from letters in treatment column to 
# get a new column named condition using gsub function
data.long$condition <- gsub(pattern = "[0-9]", "", x = data.long$treatment)

# 2nd step to get rid of letters from treatment column to get new column, replicate
data.long$replicate <- gsub(pattern = "[A-Za-z]", "",x = data.long$treatment)

# now we have two new columns with desired info and now we can remove the 
# original treatment column
data.long$treatment <- NULL