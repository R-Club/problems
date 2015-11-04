

x <- 1:100
y1 <- rep(0, lenght.out=length(x))
y2 <- rpois(n=length(x), lambda = 5)
y3 <-  rpois(n=length(x), lambda = 5)
col <- ifelse(runif(length(x), 0, 1) < 0.5, "red", "blue")
level <- rep(c(1,40), each=50)

df <- data.frame(x, y1, y2, y3, col, level)

library(ggplot2)
library(reshape)
8i
dfm <- melt(df, id.vars = 1)

head(df)

ggplot(df, aes(x=x, xend=x, y=y1, yend=y2, col=col)) +
  geom_segment(lwd=4) +
  coord_polar() + ylim(c(-10,10))

ggplot(df, aes()) +
  geom_rect(aes(xmin=x+0.05, xmax=x+0.95,ymin=y1, ymax=y2, fill=col)) +
  geom_rect(aes(xmin=x+0.05, xmax=x+0.95,ymin=y1+10, ymax=y3+10)) +
  coord_polar() + ylim(c(-10,40) )+ 
  geom_segment(x=0, xend=0, y=0, yend=10, col="red", lwd=2) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
