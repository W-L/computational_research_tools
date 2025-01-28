suppressWarnings(suppressMessages(library(ggplot2)))
suppressWarnings(suppressMessages(library(reshape2)))
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(argparse)))


get_arguments <- function() {
  # define the most basic argument parser
  parser <- argparse::ArgumentParser()
  parser$add_argument('--input', nargs = '*', required = TRUE)
  parser$add_argument('--output', required = TRUE)
  args<- parser$parse_args()
  return(args)
}

read_transcript_file <- function(file_path) {
  # read and process a single file
  data <- read.table(file_path, header = TRUE, sep = "\t")
  colnames(data) <- c("Gene", "Chromosome", "Start", "End", "Strand", "Length", "Count")
  basename_with_ext <- basename(file_path)
  # rm file extension
  filename_without_ext <- tools::file_path_sans_ext(basename_with_ext)
  data$file <- filename_without_ext
  return(data)
}

read_multiple_files <- function(file_paths) {
  # read all files and combine them into single data frame
  all_data <- lapply(file_paths, read_transcript_file)
  combined_data <- do.call(rbind, all_data)
  return(combined_data)
}


create_visualization <- function(data, output) {
  # Bar plot of top 10 genes with highest counts
  colors <- c("#CC6677","#332288","#DDCC77","#117733","#88CCEE","#882255","#44AA99","#999933","#AA4499")
  data$Count <- as.numeric(data$Count)
  top_genes <- data %>%
    group_by(file) %>%
    top_n(10, Count) %>%
    ungroup()
  top_plot <- ggplot(top_genes, aes(x = reorder(Gene, -Count), y = Count, fill = file)) +
    geom_bar(stat = "identity", position = position_dodge2(width = 0.9, preserve = "single")) +
    theme_minimal() +
    xlab("Gene") +
    scale_fill_manual(values = colors) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          legend.title = element_blank(),
          legend.position = 'bottom')
  ggsave(filename = output, plot = top_plot, width = 14, height = 6)
}


# Main script
args <- get_arguments()
transcript_data <- read_multiple_files(file_paths=args$input)
create_visualization(data=transcript_data, output=args$output)





