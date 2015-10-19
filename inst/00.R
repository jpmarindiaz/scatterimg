library(devtools)
load_all()
document()
devtools::install()

library(scatterimg)

d <- read.csv(system.file("data/tctl.csv",package="scatterimg"))
d$tooltip <- d$label

tooltipOpts <- list(direction = 'fixed',
                    offset = c(0,0),
                    element = 'circleLabel')

d$radius <- 20


scatterimg(d, tooltipOpts = tooltipOpts, noOverlap = TRUE, noOverlapSpread = 1.5)

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
      d$tooltip <- d$label
      scatterimg(d)
    })
  }
)
runApp(app)

