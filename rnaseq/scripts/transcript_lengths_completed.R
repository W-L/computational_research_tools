# Load necessary libraries
library(ggplot2)
library(dplyr)
library(argparse)
library(viridis)


get_arguments <- function() {
  parser <- argparse::ArgumentParser()
  parser$add_argument('--input', required = TRUE, help = 'Path to the input annotations')
  parser$add_argument('--output', required = TRUE, help = 'Path for the output density plot')
  parser$add_argument('--bwadjust', required = FALSE, default = 1, type = 'numeric', help = 'Bandwidth adjustment for density plot')
  args<- parser$parse_args()
  return(args)
}



process_transcripts <- function(file_path) {
  # Read the annotation file
  data <- read.table(file_path, header = FALSE, sep = "\t")
  # Keep only transcripts (column 3)
  transcripts <- data %>% filter(V3 == "transcript")
  # Calculate lengths from columns 4 and 5
  transcripts <- transcripts %>% mutate(Length = V5 - V4 + 1)
  return(transcripts)
}


plot_density <- function(transcripts, bandwidth_adjust) {
  # plot the density of transcript lengths faceted by chromosome
  dens <- ggplot(transcripts, aes(x = Length, group=V1, fill=V1)) +
    geom_density(alpha = 0.5, color='black', adjust=bandwidth_adjust) +
    scale_fill_viridis(discrete = TRUE) +
    theme_minimal() +
    facet_wrap(~ V1)  # facet by chromosome
  return(dens)
}


# Main script
args <- get_arguments()
file_path <- args$input
transcripts <- process_transcripts(file_path=file_path)
density_plot <- plot_density(transcripts=transcripts, bandwidth_adjust=args$bwadjust)
ggsave(filename = args$output, plot = density_plot, width = 10, height = 6)


