library(devtools)
load_all()
document()
devtools::install()

library(scatterimg)

d <- read.csv(system.file("data/tctl.csv",package="scatterimg"))



d$radius <- 10
scatterimg(d, noOverlap = TRUE, noOverlapSpread = 2)
scatterimg(d, noOverlap = TRUE)
scatterimg(d, noOverlap = TRUE, noOverlapSpread = 1)

e <- scatterimg(d)
saveWidget(e,"tmp.html")


# A nice shiny app
library(scatterimg)
library(shiny)
app <- shinyApp(
  ui = bootstrapPage(
    numericInput("radius","Radius",value=10),
    scatterimgOutput("viz")
  ),
  server = function(input, output) {
    default <- read.csv(system.file("data/tctl.csv", package = "scatterimg"))
    output$viz <- renderScatterimg({
      d <- default
      d$radius <- input$radius
      scatterimg(d)
    })
  }
)
runApp(app)

