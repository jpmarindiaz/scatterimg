library(devtools)
load_all()
document()
devtools::install()

library(dplyr)
library(scatterimg)

d <- read.csv(system.file("data/tctl.csv",package="scatterimg"))
d <- arrange(d,position)
v <- d$position
names(v) <- d$name


d$radius <- 20
scatterimg(d, noOverlap = TRUE, noOverlapSpread = 1)
scatterimg(d, noOverlap = TRUE, noOverlapSpread = 1)

scatterimg(d)





