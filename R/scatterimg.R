#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
scatterimg <- function(d, opts = NULL, tooltipOpts = NULL,
                       theme = "basic", customCSS = NULL,
                       noOverlap = FALSE, noOverlapSpread = NULL,
                     width = NULL, height = NULL) {

  style <- getStyle(theme = theme, customCSS = customCSS)

  opts <- opts %||% NULL
  opts$padding <- opts$padding %||% 20

  tooltipOpts <- tooltipOpts %||% list()
  tooltipOpts$trigger <- tooltipOpts$trigger %||% "hover" # hover or click
  #one of 'circle', 'label', 'circleLabel'
  tooltipOpts$element <- tooltipOpts$element %||% "circleLabel" # 'circle', 'label', 'circleLabel'
  tooltipOpts$direction <- tooltipOpts$direction %||% "ne" # s,w,e,n,se,sw,ne,nw,fixed
  tooltipOpts$offset <- tooltipOpts$offset %||% c(10,10)
  str(tooltipOpts)
  data <- prepareData(d, noOverlap = noOverlap, noOverlapSpread = noOverlapSpread)

  # forward options using x
  x = list(
    tooltipOpts = tooltipOpts,
    opts = opts,
    data = data,
    style = style
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'scatterimg',
    x,
    width = width,
    height = height,
    sizingPolicy = htmlwidgets::sizingPolicy(
      browser.fill = TRUE
    ),
    package = 'scatterimg'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
scatterimgOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'scatterimg', width, height, package = 'scatterimg')
}

#' Widget render function for use in Shiny
#'
#' @export
renderScatterimg <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, scatterimgOutput, env, quoted = TRUE)
}
