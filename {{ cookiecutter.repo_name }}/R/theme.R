## Theme for ggplot2

#' Blue and gray scale categorical color palettes
#'
#' @export
#' @examples
#' show_col(pal_azure)
pal_azure <- c("#00188F", "#173BD0", "#0078D7", "#5C5C5C", "#9D9D9D", "#D2D2D2")


#' Blue and gray scale gradient
#'
#' @export
pal_azure_gradient <- c("#00188F", "#00bcf2")

#' Blue and gray scale gradient for dark themes
#'
#' @export
pal_azure_gradient_dark <- c("#173BD0", "#00bcf2")

#' Categorical colors for use in conjunction with the default palette
#'
#' @export
pal_categorical <- c("#173BD0", "#00AD7F", "#FFAA00", "#DA3900", "#661A1A")


#' Blue and gray scale gradient for dark themes
#'
#' @export
pal_binary <- c("#DA3900", "#00AD7F", "#D2D2D2")


#' Blue and gray scale gradient for dark themes
#'
#' @export
pal_binary_background <- c("#FFADAD", "#DBFFEF", "#EAEAEA")

#' Discrete fill with Azure palette
#'
#' @export
#' @examples
#' ggplot(iris[sample(nrow(iris), 30), ], aes(x = Species)) +
#'   geom_bar(aes(fill = Species)) +
#'   ggtitle("Number per Species") +
#'   scale_fill_azure() +
#'   theme_azure()
scale_fill_azure <- function() {
  structure(list(
    scale_fill_manual(values = pal_azure)
  ))
}


#' Discrete coloring with Azure palette
#'
#' @export
scale_color_azure <- function() {
  structure(list(
    scale_color_manual(values = pal_azure)
  ))
}

#' Continuous color with Azure palette
#'
#' @export
#'
#' @examples
#' ggplot(diamonds, aes(x = carat, y = price)) +
#'   geom_point(aes(color = price)) +
#'   ggtitle("Diamond Price by Carat") +
#'   azure_color_continuous() +
#'   theme_azure()
azure_color_continuous <- function() {
  structure(list(
    scale_color_gradientn(colours = pal_azure_gradient)
  ))
}

#' Continuous fill with Azure palette
#'
#' @export
#'
#' @examples
#' ggplot(diamonds, aes(x = carat, y = price)) +
#'   geom_point(aes(fill = price)) +
#'   ggtitle("Diamond Price by Carat") +
#'   azure_fill_continuouss() +
#'   theme_azure()
azure_fill_continuous <- function() {
  structure(list(
    scale_fill_gradientn(colours = pal_azure_gradient)
  ))
}


#' Continuous fill with Azure Dark palette
#'
#' @export
#'
#' @examples
#' ggplot(diamonds, aes(x = carat, y = price)) +
#'   geom_point(aes(color = price)) +
#'   ggtitle("Diamond Price by Carat") +
#'   azure_color_continuous_dark() +
#'   theme_azure()
azure_color_continuous_dark <- function() {
  structure(list(
    scale_color_gradientn(colours = pal_azure_gradient_dark)
  ))
}

#' Continuous fill with Azure Dark palette
#'
#' @export
#'
#' @examples
#' ggplot(diamonds, aes(x = carat, y = price)) +
#'   geom_point(aes(fill = price)) +
#'   ggtitle("Diamond Price by Carat") +
#'   azure_fill_continuous_dark() +
#'   theme_azure()
azure_fill_continuous_dark <- function() {
  structure(list(
    scale_fill_gradientn(colours = pal_azure_gradient_dark)
  ))
}


#' Discrete fill with Azure categorical palette
#'
#' @export
#'

scale_fill_categorical <- function() {
  structure(list(
    scale_fill_manual(values = pal_categorical)
  ))
}

#' Discrete color with Azure categorical palette
#'
#' @export
#'
scale_color_categorical <- function() {
  structure(list(
    scale_color_manual(values = pal_categorical)
  ))
}

#' Discrete binary fill with Azure binary palette
#'
#' @export
#'

scale_fill_binary <- function() {
  structure(list(
    scale_fill_manual(values = pal_binary)
  ))
}

#' Discrete binary color with Azure binary palette
#'
#' @export
#'

scale_color_binary <- function() {
  structure(list(
    scale_color_manual(values = pal_binary)
  ))
}

#' Discrete binary fill for table fills with Azure binary palette
#'
#' @export
#'
scale_fill_binary_background <- function() {
  structure(list(
    scale_fill_manual(values = pal_binary_background)
  ))
}

#' Discrete binary color for table fills with Azure binary palette
#'
#' @export
#'

scale_color_binary_background <- function() {
  structure(list(
    scale_color_manual(values = pal_binary_background)
  ))
}

#' The Azure ggplot2 theme
#'
#' @export
#' @examples
#' ggplot(diamonds, aes(x = carat, y = price)) +
#'   geom_point(aes(color = price)) +
#'   ggtitle("Diamond Price by Carat") +
#'   scale_azure_continuous() +
#'   theme_azure()
theme_azure <- function(base_size = 12) {
  theme_classic() +
    theme(
      panel.background = element_blank(),
      strip.background = element_blank(),
      panel.grid = element_blank(),
      axis.line.x = element_line(color = "gray95"),
      axis.line.y = element_blank(),
      axis.ticks = element_blank(),
      text = element_text(family = "Segoe UI"),
      axis.title = element_text(color = "gray30", size = 12),
      axis.text = element_text(size = 10, color = "gray30"),
      axis.text.x = element_text(hjust = 1, vjust = 1.2),
      plot.title = element_text(size = 14, hjust = 0, color = "gray30"),
      legend.position = "none",
      legend.text = element_text(color = "gray30"),
      legend.title = element_text(color = "gray30"),
      strip.text = element_text(color = "gray30", size = 12)
    )
}



#' The Azure ggplot2 dark theme
#'
#' @export
#' @examples
#' ggplot(diamonds, aes(x = carat, y = price)) +
#'   geom_point(aes(color = price)) +
#'   scale_y_continuous(labels = comma, breaks = pretty_breaks(n = 10)) +
#'   scale_x_continuous(breaks = pretty_breaks(n = 10)) +
#'   ggtitle("Diamond Price by Carat") +
#'   scale_azure_continuous_dark() +
#'   theme_azure_dark()
theme_azure_dark <- function(base_size = 12) {
  theme_classic() +
    theme(
      plot.background = element_rect(fill = "black"),
      panel.background = element_rect(fill = "black"),
      strip.background = element_blank(),
      panel.grid = element_line(color = "white"),
      axis.line.x = element_line(color = "white"),
      axis.line.y = element_blank(),
      axis.ticks = element_blank(),
      text = element_text(family = "Segoe UI"),
      axis.title = element_text(color = "white", size = 12),
      axis.text = element_text(size = 10, color = "white"),
      axis.text.x = element_text(hjust = 1, vjust = 1.2),
      plot.title = element_text(size = 14, hjust = 0, color = "white"),
      legend.position = "none",
      strip.text = element_text(color = "white", size = 12)
    )
}
