It's the shist
==============

Plot first, tweak parameters later. `shist()` is the simple, quick to type shifting histogram you deserve. This is a simple wrapper for functionality available in Hadley's `ggvis` package.

``` r
library(shist)
data(trees)
shist(trees$Girth)
#Produces a shifting histogram with a slider to select bin width. 
#The bin width increment step is automatically is selected by an algorithm. 
#It can be overidden:
shist(trees$Girth, bin_step = 1)
```
