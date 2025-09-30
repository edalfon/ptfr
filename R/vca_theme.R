#| eval: false

# TODO:
# https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2
# https://rpubs.com/mclaire19/ggplot2-custom-themes

# add_logos <- function() {
#   vca_logo <- magick::image_read("slides/vca_logo.png")
#   ptf_logo <- magick::image_read("slides/ptf_logo.png")
#   grid::grid.raster(vca_logo, x = 0.001, y = 0, just = c("left", "bottom"), width = unit(2, "inches"))
#   grid::grid.raster(ptf_logo, x = 0.999, y = 0, just = c("right", "bottom"), width = unit(1.1, "inches"), height = unit(0.6, "inches"))
# }
# #| eval: false
# add_logos()

#corporate_colors <- c("#39916C", "#3B6788", "#D49D54", "#c45a31", "#9f9f9f")

# Add a logo
# https://rpubs.com/mclaire19/ggplot2-custom-themes
vca_theme <- function(
  base_family = "sans",
  base_size = 9,
  plot_title_family = "serif",
  plot_title_size = 20,
  plot_title_color = "#39916C",
  grid_col = "#dadada"
) {
  ggplot2::theme_minimal(base_family = base_family, base_size = base_size) +
    theme(
      panel.grid = element_line(color = grid_col),
      plot.title = element_text(
        size = plot_title_size,
        family = plot_title_family,
        color = plot_title_color,
        face = 'bold', #bold typeface
        hjust = 0, #left align
        vjust = 2
      ),
      legend.position = "top", #legend on top
      #grid elements
      panel.grid.major = ggplot2::element_blank(), #strip major gridlines
      panel.grid.minor = ggplot2::element_blank(), #strip minor gridlines
      axis.ticks = ggplot2::element_blank(), #strip axis ticks

      #since theme_minimal() already strips axis lines,
      #we don't need to do that again

      plot.subtitle = ggplot2::element_text(
        #subtitle
        family = base_family, #font family
        size = 14
      ), #font size

      plot.caption = ggplot2::element_text(
        #caption
        family = base_family, #font family
        size = 9, #font size
        hjust = 1
      ), #right align

      axis.title = ggplot2::element_text(
        #axis titles
        family = base_family, #font family
        size = 10
      ), #font size

      axis.text = ggplot2::element_text(
        #axis text
        family = base_family, #axis famuly
        size = 9
      ), #font size

      axis.text.x = ggplot2::element_text(
        #margin for axis text
        margin = margin(5, b = 10)
      )
    )
}

# some color ideas
# https://www.datanovia.com/en/blog/ggplot-colors-best-tricks-you-will-love/
# change default palette
# https://stackoverflow.com/questions/10504724/change-the-default-colour-palette-in-ggplot
discrete_palette <- function(name = "default") {
  if (name == "sino") {
    return(c(`Sí` = "#00AFBB", No = "#FC4E07"))
  }
  if (name == "corporate") {
    return(c("#39916C", "#3B6788", "#D49D54", "#c45a31", "#9f9f9f"))
  }
  if (name == "ok") {
    return(c(
      "#00AFBB", # blue
      "#E7B800", # yellow
      "#FC4E07", # red
      "#C3D7A4", # light green
      "#52854C", # green
      "#4E84C4", # light blue
      "#293352", # dark blue
      "#FFDB6D", # light yellow
      "#C4961A", # dark yellow
      "#F4EDCA", # very light yellow
      "#D16103" # dark orange
    ))
  }
  if (name == "ok2") {
    return(c(
      "dodgerblue1",
      "skyblue4",
      "chocolate1",
      "seagreen4",
      "bisque3",
      "red4",
      "purple4",
      "mediumpurple3",
      "maroon",
      "dodgerblue4",
      "skyblue2",
      "darkcyan",
      "darkslategray3",
      "lightgreen",
      "bisque",
      "palevioletred1",
      "black",
      "gray79",
      "lightsalmon4",
      "darkgoldenrod1"
    ))
  }
  # default palette
  c(
    "#00AFBB",
    "#E7B800",
    "#FC4E07",
    "#C3D7A4",
    "#52854C",
    "#4E84C4",
    "#293352",
    "#FFDB6D",
    "#C4961A",
    "#F4EDCA",
    "#D16103"
  )
}
