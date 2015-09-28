

prepareData <- function(d, noOverlap = FALSE, radius = NULL, noOverlapSpread = NULL){

  d <- d[with(d, order(positionY)), ]
  noOverlapSpread <- noOverlapSpread %||% 2
  radius <- radius %||% 20
  data <- d
  data$label <- d$label
  data$cy <- d$positionY
  if(is.null(d$positionX)){
    message("using default position x")
    d$positionX <- 50
  }
  data$cx <- d$positionX
  data$id <- paste0("a",1:nrow(d))
  data$tooltip <- d$tooltip

  if(is.null(d$radius))
    data$radius <- radius
  if(is.null(d$imageUrl))
    data$imageUrl <- "https://res.cloudinary.com/randommonkey/image/upload/c_scale,e_auto_brightness,r_30,w_40/a_0/v1442865905/NO-IMAGE-AVAILABLE2_fk041v.png"
  else
    data$imageUrl <- d$imageUrl
  if(noOverlap){
    window <- 2*max(data$radius)
    range <- c(0,nrow(data)*window*noOverlapSpread)
    v <- data$cy
    y <- scale_linear(v, range =  range)
    t <- nonOverlapSpread(y,window = window)
    t <- scale_linear(domain = t, range =  range)
    data$cy <- round(t)
    # back to original scale after nonOverlapping
    #data$cy <- scale_linear(data$cy, range =  c(min(d$position),max(d$position)))
  }
  data
}


getStyle <- function(theme = NULL, customCSS = ""){
  theme <- theme %||% "basic"
  if(theme == "blank")
    theme <- ""
  else{
    theme <- paste0(theme,".css")
    filePath <- file.path(system.file("styles",package="scatterimg"),theme)
    theme <- paste0(readLines(filePath),collapse="")
  }
  style <- paste(theme,customCSS,"\n")
  #message(style)
  style
}



### Scales
scale_linear <- function(domain,range){
  f <- function(x){
    m <- (range[2] - range[1])/(max(domain) - min(domain))
    b <- range[2] - m*max(domain)
    x*m + b
  }
  f(domain)
}


#
nonOverlapSpread <- function(y, window, maxIte = 100){
  x <- y
  for(i in 1:maxIte){
    #x <- f(v)
    x <- sort(x)
    di <- diff(x)
    overlapping <- which(diff(x) < window)
    x2 <- x
    l <- lapply(overlapping,function(o){
      ep <- window/100
      if(o != overlapping[1]){
        stepLeft <- (window - min(di[o-1:o]) + ep)/2
      }else{
        stepLeft <- (window - di[o] + ep)/2
      }
      x2[o] <<- x[o] - stepLeft
      if(o != overlapping[length(overlapping)]){
        stepRight <- (window -  min(di[o:(o+1)])+ ep)/2
      }else{
        stepRight <- (window -  di[o] + ep)/2
      }
      x2[o+1] <<- x[o+1] + stepRight
      x2
    })
    #str(l)
    length(overlapping)
    if(length(overlapping) == 0) return(x)
    x <- l[[length(l)]]
#     overlapping <- which(diff(x) < window)
#     diff(x)
#     overlapping
  }
  x
}



