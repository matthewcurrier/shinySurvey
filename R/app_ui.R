#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    page_navbar(
      title = "Shiny Survey",
      nav_panel(title = "One", p("First page content.")),
      nav_panel(
        title = "two",
        shinyjs::useShinyjs(),
        # Use the data loader UI
        upload_ui("test_loader")$data_loader
      ),
      nav_panel(
        title = "Status",
        # Elements moved into their own nav_panel
        h4("Data Status:"),
        # verbatimTextOutput("dataStatus"),
        upload_ui("test_loader")$feedback
      ),
      # External resources should be in header
      header = golem_add_external_resources()
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "shinySurvey"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
