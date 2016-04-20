# The objective of this script is to create a "circle plot": circular arrangement of barplots
# (on multiple layers) with individual hight and color using ggplo
library(ggplot2)


# create some data
x     <- 0:100
y1    <- rep(0, lenght.out=length(x))
y2    <- rpois(n=length(x), lambda = 5)
y3    <-  rpois(n=length(x), lambda = 5)
col   <- ifelse(runif(length(x), 0, 1) < 0.5, "A", "B")  # some individual coloring
df <- data.frame(x, y1, y2, y3, col)  # combine to dataframe
rm(x, y1, y2, y3, col)


# simple plot
# bars get wider at the top when using geom_rect and polar coordinates
ggplot(df) +
  geom_rect(aes(xmin=x, xmax=x+1,ymin=y1, ymax=y2, fill=col)) +
  coord_polar() + ylim(c(-10,10))

# when using geom_segment bars keep their width over the full length
ggplot(df, aes(x=x, xend=x, y=y1, yend=y2, col=col)) +
  geom_segment(lwd=4) +
  coord_polar() + ylim(c(-10,10))

# multiple circles can be constructed 
# use xmin=x+0.05, xmax=x+0.95 instead of xmin=x, xmax=x+1 to create a small gap between the bars
ggplot(df) +
  geom_rect(aes(xmin=x+0.05, xmax=x+0.95,ymin=y1, ymax=y2, fill=col)) +
  geom_rect(aes(xmin=x+0.05, xmax=x+0.95,ymin=max(df$y2) + 1, ymax=max(df$y2) + y3)) +
  geom_rect(aes(xmin=x+0.05, xmax=x+0.95,ymin=max(df$y2) + max(df$y3) + 1, ymax=max(df$y2) + max(df$y3) + 5, fill=col)) +
  coord_polar() +
  ylim(c(-10,NA)) +  # (0, NA) notation fixes lower limit of axis 
  xlim(0,NA) +       # to 0 and leaves upper limit open
  geom_segment(x=0, xend=0, y=0, yend=10, col="red", lwd=2) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.text = element_blank(), axis.ticks = element_blank()) + 
  ggtitle("Circle Plot")

# comment as example