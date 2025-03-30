#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  loaded_data <- upload_server("test_loader")

  # Create a simple plot using the loaded data
  output$agePlot <- renderPlot({
    req(loaded_data())
    hist(loaded_data()$AGE,
         main = "Age Distribution",
         xlab = "Age",
         col = "lightblue",
         border = "white")
  })
}
