#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  observeEvent(input$uploadBtn, {
    # Create and show a modal when the upload button is clicked
    showModal(modalDialog(
      upload_ui("test_loader"),
      title = "Upload File",

    ))
  })

  loaded_data <- upload_server("test_loader")
}
