library(shiny)
library(sbgnvizShiny)
library(htmlwidgets)
library(xml2)

# UI ----
ui = shinyUI(fluidPage(
  tags$head(
    tags$style("#sbgnvizShiny{height:95vh !important;}")
    ),
  titlePanel("sbgnviz Shiny"),

  sidebarLayout(
     sidebarPanel(
       fileInput("sbgnml", "Choose SBGNML File",
                 multiple = FALSE,
                 accept = c("text/xml",
                            "text/plain",
                            ".sbgn",
                            ".sbgnml",
                            ".txt",
                            ".xml")),
        helpText("Example 1: ", a(href="atm_mediated_phosphorylation_of_repair_proteins.xml", 
                                target="_blank", download="atm_mediated_phosphorylation_of_repair_proteins.xml", "DNA Repair")),
        helpText("Example 2: ", a(href="neuronal_muscle_signaling_color.xml", 
                                target="_blank", download="neuronal_muscle_signaling_color.xml", "Muscle")),
        width=3
        ),
      mainPanel(
        withTags({
          div(span("Save: "),
              a(id="save-as-svg", href="#", "SVG"),
              a(id="save-as-png", href="#", "PNG")
          )
        }),
        sbgnvizShinyOutput('sbgnvizShiny'),
        width=9
        )
     ) # sidebarLayout
))

# Server ----
server = function(input, output, session) {
  output$sbgnvizShiny <- renderSbgnvizShiny({
    inFile <- input$sbgnml
    
    #cat("DEBUG: ", as.character(str(inFile)))

    if (!is.null(inFile)) {
      sbgn_xml <- read_xml(inFile$datapath)
    } else {
      sbgn_xml <- read_xml(system.file("extdata/neuronal_muscle_signaling_color.xml", package="sbgnvizShiny"))
    }
    
    sbgnvizShiny(sbgnml=as.character(sbgn_xml))
  })
} # server

shinyApp(ui = ui, server = server)
