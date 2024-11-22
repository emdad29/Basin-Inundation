#install.packages("rgdal")
#install.packages("ggplot2")
#install.packages("colorspace")
#install.packages("raster")
#install.packages("magrittr")
#install.packages("maptools")
#install.packages("prettymapr")
#install.packages("rasterVis")
#install.packages("ggspatial")

library(raster)
library(sp)
library(rgdal)
library(ggplot2)
library(colorspace)
library(magrittr)
library(maptools)
library(prettymapr)
library(rasterVis)
library(ggspatial)

# set the directory
setwd("D:/Education/Fiverr/Work 01/Findhorne Bay 5DTM 1km/")
f <-list.files(pattern = ".asc")  
r <- lapply(f, raster) 
x <- do.call("merge",r) 
#combine raster
writeRaster(x,"DTM_combine.asc", overwrite=TRUE)

# Specify the correct UTM zone number for your raster data
# Here your UTM zone is 30
utm_zone <- 30

# Define the CRS string with the correct UTM zone number
crs <- paste0("+proj=utm +zone=", utm_zone, " +datum=WGS84 +no_defs")

# Read your raster DTM_combine.asc
r <- raster::raster("DTM_combine.asc")

# Assign the projection to the raster object
raster::projection(r) <- crs

niveaux <- (raster::extract(r, raster::extent(r)) %>% 
              range(finite = TRUE))[2] %>% 
  seq(0,.,by=5)

#png("Dem Plot.png", res=600)
raster_old<- r
plot(raster_old, main="Findhorne Bay")
addnortharrow(pos="topright", padin=c(.3,.2), scale=.5, lwd=1, border="black")
box(lwd=1)
# Add a scale bar
x1 <- 300000  # starting x-coordinate of the scale bar
x2 <- 310000 # ending x-coordinate of the scale bar
y1 <- 860000  # y-coordinate of the scale bar
y2 <- 860000  # y-coordinate of the scale bar
length <- x2 - x1 # length of the scale bar in the x-axis

segments(x1, y1, x2, y2, col = "black", lwd = 2) # add the scale bar segment
text(x1 + length/2, y1, paste(length, "units"), pos = 3, 
     offset = 0.5, col = "black") 
# add the length label
#dev.off()

#jpeg("Reclassify Dem plot.png", res=600)
raster::plot(r, main="Findhorne Bay")

raster::contour(r, add=TRUE, col="blue", lwd=0.2, levels=niveaux[1], drawlabels=TRUE)
raster::contour(r, add=TRUE, col="red", lwd=0.2, levels=niveaux[2], drawlabels=TRUE)

#add north arrow and box
addnortharrow(pos="topright", padin=c(.3,.2), scale=.5, lwd=1, border="black")
box(lwd=1)
# Set legend
legend("bottom", inset=c(0, -0.3), legend = c("Original", "Reclassify"), 
       col = c("blue", "red"),lwd = 1, lty = 1, bty = "0",border="black",
       cex = 0.8, pch = 1, xpd = TRUE, horiz = TRUE,
       bg = rgb(1, 0, 0, alpha = 0.15), box.lty = 1, box.lwd = 0.1, box.col = "black")


# Add a scale bar
x1 <- 300000  # starting x-coordinate of the scale bar
x2 <- 310000 # ending x-coordinate of the scale bar
y1 <- 860000  # y-coordinate of the scale bar
y2 <- 860000  # y-coordinate of the scale bar
length <- x2 - x1 # length of the scale bar in the x-axis

segments(x1, y1, x2, y2, col = "black", lwd = 3) # add the scale bar segment
text(x1 + length/2, y1, paste(length, "units"), pos = 3, 
     offset = 0.5, col = "black") 
# add the length label

#dev.off()

