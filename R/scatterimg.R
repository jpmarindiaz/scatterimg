#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
scatterimg <- function(d, noOverlap = FALSE, theme = "basic", customCSS = NULL, noOverlapSpread = NULL,
                     width = NULL, height = NULL) {

  style <- getStyle(theme = theme, customCSS = customCSS)


  data <- prepareData(d, noOverlap = noOverlap, noOverlapSpread = noOverlapSpread)

  # forward options using x
  x = list(
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
