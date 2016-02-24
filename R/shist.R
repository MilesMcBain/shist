#' shist
#'
#' @description shist takes a vector of values and plots a ggvis histogram with a slider to select the bin width.
#' This saves you having to re-plot over and over trying to find the bin width that best suits the inference you want to make.
#' Once the slider has been clicked on you can use the left and right arrow keys to nudge the slider and ggvis handles updating the histogram
#' in real time.
#'
#' @param x a vector of values to plot in a histogram.
#'
#' @param bin_step an optional number that defines the size of the increments on the bin width slider.
#' If left unspecified a whole number step size is derived from the data using an unspecified algorithm.
#'
#' @import dplyr
#' @import ggvis
#'
#' @export

shist <- function(x,
                  bin_step=NA) {
  #Check format
  if(!is.vector(x)){
    stop("data must be a vector")
  }
  #handle NA's. ggvis doesn't currently handle them, so I'll just filter out for you.
  NAs = is.na(x)
  if( length(NAs) > 0){
  x <- x[!NAs]
  warning(paste0("shist ignored ", sum(NAs), " NAs for you. Please come again."))
  }


  #Choose bin increments
  s_max <- max(x, na.rm = T)
  if(is.na(bin_step)){
    s_delta <- choose_bin_width(x)
  }
  else
  {
    s_delta <- bin_step
  }
  s_min <- s_delta

  #Plot
  data_frame(var = x) %>%
      ggvis::ggvis(~var) %>%
      ggvis::layer_histograms(width = ggvis::input_slider(min = s_min,
                                                          max = s_max,
                                                          step = s_delta,
                                                          label = "Bin Width"))
}

#' choose_bin_width
#'
#' @description A helper funciton for shist() that chooses the slider step when none is provided.
#' The idea is to choose a whole number that represents a represents a change in 5 percetiles around the median of the distribution.
#' The distribution is hopefully changing slowly around the median and thus the interval will be the an estimate of the smallest useful delta in bin size.
#'
#' @param x a vector of values to derived a step size from.


choose_bin_width <- function(x){
  med <- 0.5
  delta <- 0.05
  repeat{
    width <- diff(quantile(x, c(med,med+delta)))
    if(width == 0) delta <- delta + 0.01
    else break
  }
  if( round(width[[1]]) > 0 ){
    return (round(width[[1]]))
  } else {
    return (1)
  }
}



