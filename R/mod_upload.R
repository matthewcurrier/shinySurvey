#' upload UI Function
#'
#' @description A shiny Module.
#'
#' @param id Internal parameters for {shiny}.
#' @export
upload_ui <- function(id) {
  ns <- NS(id)

  list(
    data_loader = tagList(
      uiOutput(ns("file_upload")),
      actionButton(ns("clear"), "Clear Data")
    ),
    feedback = tagList(
      verbatimTextOutput(ns("dataInfo")),
      tableOutput(ns("dataPreview"))
    )
  )
}

#' @export
upload_server <- function(id){
  moduleServer(id, function(input, output, session) {
    # Initialize reactive values
    data <- reactiveVal(NULL)
    fileReset <- reactiveVal(0)

    # Render file input
    output$file_upload <- renderUI({
      fileReset()  # Dependency for re-render
      fileInput(session$ns("file"), "Upload SAV file", accept = ".sav")
    })

    # Handle file uploads
    observeEvent(input$file, {
      req(input$file)

      tryCatch({
        new_data <- haven::read_sav(input$file$datapath)
        required_cols <- c("AGE", "AGECAT", "PARTYLN")

        if (!all(required_cols %in% names(new_data))) {
          missing_cols <- setdiff(required_cols, names(new_data))
          showNotification(
            sprintf("Dataset not loaded. Missing required columns: %s", paste(missing_cols, collapse = ", ")),
            type = "error",
            duration = 7
          )
          return()
        }

        data(new_data)
        showNotification("Data loaded successfully", type = "message")
      }, error = function(e) {
        showNotification(
          sprintf("Error reading file: %s", e$message),
          type = "error",
          duration = 7
        )
      })
    })

    # Handle clear button
    observeEvent(input$clear, {
      data(NULL)
      fileReset(fileReset() + 1)
      showNotification("Data has been cleared", type = "message")
    })

    # Update data preview and info
    observe({
      current_data <- data()

      output$dataInfo <- renderPrint({
        req(current_data)
        cat(sprintf(
          "Dataset Information:\nRows: %d\nColumns: %d\n\nColumn names:\n%s",
          nrow(current_data),
          ncol(current_data),
          paste(names(current_data), collapse = ", ")
        ))
      })

      output$dataPreview <- renderTable({
        req(current_data)
        head(current_data, 5)
      })
    })

    # Return validated data
    return(reactive({
      current_data <- data()
      validate(
        need(current_data, "Please upload a data file."),
        need(all(c("AGE", "AGECAT", "PARTYLN") %in% names(current_data)),
             "Missing required columns")
      )
      current_data
    }))
  })
}
