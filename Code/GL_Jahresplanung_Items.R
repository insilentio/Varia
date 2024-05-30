# read data from clipboard
# remove duplicates
# insert empty row
# reorder rows
# write into clipboard

# there is an unsolved problem with umlaute (of course... it's windows, isn't it, what a crap)

projects <- read.delim("clipboard", header = FALSE) |>
  unique()

projects <- projects |>
  rbind(data.frame(V1 = rep("", times = nrow(projects))))

rownames(projects) <- c(seq(1, nrow(projects), 2),   seq(2, nrow(projects), 2))

projects[order(as.numeric(row.names(projects))),] |> writeClipboard()
