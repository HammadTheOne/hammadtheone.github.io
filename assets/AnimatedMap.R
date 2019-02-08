# Begin by reading in our total carbon dioxide emissions data into a datatable.

total_smoke <- read.csv("Cleaned_Smoke2.csv", header=TRUE)

class(total_smoke)

colnames(total_smoke)[1] <- "Country"

# Load up some of the necessary packages

install.packages("ggplot2")
library(ggplot2)

install.packages("dplyr")
library(dplyr)

install.packages("tidyr")
library(tidyr)

install.packages("tidyverse")
library(tidyverse)

install.packages("ggmap")
library(ggmap)

install.packages("maps")
library(maps)

install.packages("ggthemes")
library(ggthemes)

install.packages("gganimate")
library(gganimate)

install.packages("viridis")
library(viridis)

install.packages("gifski")
library(gifski)

install.packages('av')
library(av)


# Google now requires you to sign up for an API key to access the Maps API. Terrible.
# It requires you to get the API key, then go to developer settings and enable Geocoding API.
# Luckily it works, based on our test. User ?register_google for more info.

register_google(key = "AIzaSyDApzRT4RvkgBjfMTFyhBSEY5W2bym1CPY", write = TRUE)

location_test <- c("Bermuda", "Canada", "Greenland")
geocode(location_test[1])

# We will now try to geocode the locations of the countries in order to get a lon, lat variable for each.

# Create a new df with only the country column. Convert factors to numeric.


total_smoke$Country <- as.character(total_smoke$Country)

total_smoke$Emissions <- as.numeric(levels(total_smoke$Emissions))

# Careful before running this, only 3500 queries a day, don't want to waste it.

locations_df <- mutate_geocode(total_smoke, Country)

head(locations_df)

locations_df$Emissions <- as.numeric(as.character(locations_df$Emissions))

# Now that we have coordinates for the locations, we can add them back to the original data if we want.

total_smoke$lon <- locations_df$lon 

total_smoke$lat <- locations_df$lat



# Clean up the data, remove NA and blank points.

locations_df <- locations_df[!(is.na(locations_df$lon) | is.na(locations_df$lat)),]

locations_df <- locations_df[!(locations_df$Emissions > 1000),]

locations_df <- locations_df[!(is.na(locations_df$Country)),]

# Here we remove the data for 2007, for some unknown reason it's completely  breaking the animation loop. To fix.

locations_df2 <- locations_df[!(locations_df$Year == 2007),]




# And first step to try and plot using the locations onto a map of the world. We're going to use the appropriate
# scaling and range/breaks to make it look clear:


world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map() 

map <- world +
  geom_point(aes(x = lon, y = lat, size = Emissions),
             data = locations_df, alpha = .2, color = "purple") +
  scale_size_continuous(range = c(1, 10), 
                        breaks = c(250, 500, 750, 1000)) +
  labs(size = 'Emissions') 



# So this works, and we have a static image of emissions from countries for 2007. Now we will try to make it for others.

# Here we run into a problem. ggAnimate only iteratively goes over the rows, not over the columns when looking
# to create "frames" for animation. So we must export our data now, fix it manually in Excel, then import again.

##write.csv(cleaned_smoke, file = "Cleaned_Smoke.csv",row.names=TRUE)

#cleaned_smoke2 <- read.csv("Cleaned_Smoke2.csv", header=TRUE)

# Second try in plotting. Lots of trial and error, almost 4 hours worth. 




map <- ggplot() +
  borders("world", colour = "gray70", fill = "gray80") +
  theme_map()  +
  geom_point(aes(x = lon, y = lat, size = Emissions, color = Year),
             data = locations_df2, alpha = .5) +
  scale_size_continuous(range = c(1, 20), 
                        breaks = c(0.1, 1, 10, 300, 500, 800)) +
  labs(size = 'Emissions')

anim <- map + 
  transition_states(locations_df2$Year,
                    transition_length = 5,
                    state_length = 5) +
  enter_fade() + 
  exit_fade() +
  labs(title = "Year") +
  ggtitle('Now showing Emissions from {closest_state}')


  
anim

animated<- animate(
  anim, nframes = 600, fps = 30,
  renderer = gifski_renderer(),
  width = 1920, height = 1080, res = 200
)

anim_save("Emissions5.gif", animation = anim)

# Rough Work. Creator of ggAnimate completely overhauled the program 2 months ago, API changed, previous code doesn't 
# work. Will have to make do with the Readme and luck.

map <- world +
  geom_point(aes(x = lon, y = lat, size = Emissions, 
                 frame = created_at,
                 cumulative = TRUE),
             data = locations_df, colour = 'purple', alpha = .2) +
  geom_point(aes(x = lon, y = lat, size = Emissions, # this is the init transparent frame
                 frame = created_at,
                 cumulative = TRUE),
             data = ghost_points_ini, alpha = 0) +
  geom_point(aes(x = lon, y = lat, size = Emissions, # this is the final transparent frames
                 frame = created_at,
                 cumulative = TRUE),
             data = ghost_points_fin, alpha = 0) +
  scale_size_continuous(range = c(1, 8), breaks = c(250, 500, 750, 1000)) +
  labs(size = 'Emissions') 

library(gganimate)
ani.options(interval = 0.2)

gganimate(map)


library(tibble)
library(lubridate)

ghost_points_ini <- tibble(
  created_at = as.Date('2007-01-01'),
  Emissions = 0, lon = 0, lat = 0)

ghost_points_fin <- tibble(
  created_at = seq(as.Date('2012-01-01'),
                   as.Date('2017-01-20'),
                   by = 'days'),
  Emissions = 0, lon = 0, lat = 0)




