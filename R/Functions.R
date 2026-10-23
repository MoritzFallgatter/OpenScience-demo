# read the data
read <- function(veg_file){
  read.csv(veg_file, na.strings = c("", "NA", "."))
}

# clean the data
clean <- function(df){
    df |>
    select(-Layer) |> # not relevant information
    mutate(
      Species = make_clean_names(Species),
      across(-Species, as.numeric)
  )
}

# calculate the richness
calc_rich <- function(df){
  df |> 
  summarise(across(-Species, ~ sum(.x > 0, na.rm = TRUE))) |> 
  pivot_longer(everything(),
                 names_to = "plot", values_to = "richness")
}

# add the grazing factor
management <- function(df, grazed){
    df |> 
    mutate(group = if_else(substr(plot, 1, 2) %in% grazed, "Grazed", "Not grazed"))
}

# plot the data
plot_rich <- function(rich_df){
    rich_df |> 
    ggplot(aes(x = plot, y = richness, fill = group)) +
    geom_col(colour = "white") +
    scale_fill_manual(values = c("Grazed" = "darkorange", "Not grazed" = "darkgreen")) +
    labs(x = "Plot", y = "Species richness",  fill = "Management") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}