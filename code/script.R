#### objective: visualize motor vehicle theft in Chicago

#### set working directory
rm(list = ls())
getwd()
setwd('/Users/hawooksong/Desktop/r_visualization/chicago_motor_vehicle_theft')
dir()



#### load and view our data:
mvt <- read.csv("./data/mvt.csv", stringsAsFactors=FALSE)
head(mvt)
str(mvt)



#### data type transform for 'Date' variable
mvt$Date <- strptime(mvt$Date, format="%m/%d/%y %H:%M")
range(mvt$Date)



#### extract the hour and the day of the week:
mvt$Year <- format(mvt$Date, '%Y')
mvt$Month <- months(mvt$Date)
mvt$Day <- weekdays(mvt$Date)
mvt$Hour <- mvt$Date$hour
head(mvt)
str(mvt)



#### data frame of motor vehicle theft counts by months of the year, days of the week, and year
mvtByYear <- as.data.frame(table(mvt$Year)) 
head(mvtByYear)
colnames(mvtByYear) <- c('Year', 'Count')
mvtByYear$Year <- as.numeric(as.character(mvtByYear$Year))

mvtByMonth <- as.data.frame(table(mvt$Month))
head(mvtByMonth)
colnames(mvtByMonth) <- c('Month', 'Count')
mvtByMonth$Month <- factor(mvtByMonth$Month, 
                           levels = c('January', 'February', 'March', 'April',
                                      'May', 'June', 'July', 'August', 'September',
                                      'October', 'November', 'December'))

mvtByDay <- as.data.frame(table(mvt$Day))
mvtByDay
colnames(mvtByDay) <- c('Day', 'Count')
mvtByDay$Day <- factor(mvtByDay$Day,
                           levels = c('Monday', 'Tuesday', 'Wednesday', 'Thursday',
                                      'Friday', 'Saturday', 'Sunday'))


#### plot motor vehicle thefts by year
library(ggplot2)
ggplot(mvtByYear, aes(x = Year, y = Count)) + 
  geom_line(aes(group = 1), size = 2, alpha = 0.5, color = 'blue') + 
  scale_x_continuous(breaks = 2001:2012) + 
  theme(axis.title.x = element_blank()) + 
  ggtitle('Motor Vehicle Thefts by Year (2001 - 2012)')
dev.copy(png, './figures/line_graph_motor_vehicle_thefts_by_year_2001-2012.png')
dev.off()



#### plot motor vehicle thefts by month
ggplot(mvtByMonth, aes(x=Month, y=Count)) + 
  geom_line(aes(group=1), size = 2, alpha = 0.5, color = 'red') + 
  theme(axis.title.x = element_blank(), 
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle('Motor Vehicle Thefts by Month (2001 - 2012)')
dev.copy(png, './figures/line_graph_motor_vehicle_thefts_by_month_2001-2012.png')
dev.off()



#### data frame for motor vehicle thefts by year and month
mvtByMonthYear <- as.data.frame(table(mvt$Month, mvt$Year))
head(mvtByMonthYear)
colnames(mvtByMonthYear) <- c('Month', 'Year', 'Count')
str(mvtByMonthYear)
mvtByMonthYear$Year <- as.numeric(as.character(mvtByMonthYear$Year))
mvtByMonthYear$Month <- factor(mvtByMonthYear$Month, 
                               levels = c('January', 'February', 'March', 'April',
                                          'May', 'June', 'July', 'August', 'September',
                                          'October', 'November', 'December'))



#### plot heatmap of motor vehicle thefts by month and year
ggplot(mvtByMonthYear, aes(x = Month, y = Year)) +
  geom_tile(aes(fill = Count)) + 
  theme(axis.title.x = element_blank(), 
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_gradient(low = 'white', high = 'red') +
  scale_y_continuous(breaks = 2001:2012) + 
  ggtitle('Motor Vehicle Thefts by Month and Year (2001 - 2012)')
dev.copy(png, './figures/heatmap_motor_vehicle_thefts_by_month_and_year_2001-2012.png')  
dev.off()


#### plot motor vehicle thefts by days of the week
ggplot(mvtByDay, aes(x = Day, y = Count)) + 
  geom_bar(aes(fill = Day), stat = 'identity') +
  theme(axis.title.x = element_blank()) + 
  ggtitle('Motor Vehicle Thefts by Days of the Week (2001 - 2012)')
dev.copy(png, './figures/barchart_motor_vehicle_thefts_by_days_of_the_week_2001-2012.png')  
dev.off()



#### data frame for motor vehicle thefts by days of the week and hour
mvtByHourDay <- as.data.frame(table(mvt$Day, mvt$Hour))
head(mvtByHourDay)
colnames(mvtByHourDay) <- c('Day', 'Hour', 'Count')
mvtByHourDay$Day <- factor(mvtByHourDay$Day, 
                               levels = c('Monday', 'Tuesday', 'Wednesday', 'Thursday',
                                          'Friday', 'Saturday', 'Sunday'))
mvtByHourDay$Hour <- as.numeric(as.character(mvtByHourDay$Hour))
mvtByHourDay$DayType <- ifelse((mvtByHourDay$Day == "Saturday") | (mvtByHourDay$Day == "Sunday"), 
                               "Weekend", "Weekday")
head(mvtByHourDay)



#### plot motor vehicle thefts by hour and by weekend vs. weekday
ggplot(mvtByHourDay, aes(x=Hour, y=Count)) + 
  geom_line(aes(group=Day, color=DayType), size=2, alpha=0.5) +
  ggtitle('Motor Vehicle Thefts by Hour (2001 - 2012)') + 
  guides(color = guide_legend(title = 'Day Type'))
dev.copy(png, './figures/line_graph_motor_vehicle_thefts_by_hour_2001-2012.png')
dev.off()



#### heatmap of crimes by hour and day of the week
ggplot(mvtByHourDay, aes(x = Hour, y = Day)) + 
  geom_tile(aes(fill = Count)) + 
  scale_fill_gradient(name = 'Motor Vehicle Thefts',
                      low = 'white', high = 'red') + 
  theme(axis.title.y = element_blank()) + 
  ggtitle('Motor Vehicle Thefts by Hour and Day of the Week (2001 - 2012)') +
  scale_x_continuous(breaks = seq(from=0, to=23, by=2))
dev.copy(png, './figures/heatmap_motor_vehicle_thefts_by_hour_and_day_of_the_week_2001-2012.png')
dev.off()




#### install and load two new packages
# install.packages("maps")
# install.packages("ggmap")
library(maps)  
library(ggmap) 



#### load a map of Chicago into R and view
chicago <- get_map(location = "chicago", zoom = 11)
ggmap(chicago)



#### plot the first 1000 motor vehicle thefts:
ggmap(chicago) + 
  geom_point(data = mvt[1:1000,], 
             aes(x = Longitude, y = Latitude))



#### round the latitude and longitude to 2 digits of accuracy, and create a crime counts data frame for each area
head(mvt)
mvtByLongLat <- as.data.frame(table(round(mvt$Longitude, 2), round(mvt$Latitude, 2)))
head(mvtByLongLat)
colnames(mvtByLongLat) <- c('Longitude', 'Latitude', 'Count')



#### convert the Longitude and Latitude variable to numbers
str(mvtByLongLat)
mvtByLongLat$Longitude <- as.numeric(as.character(mvtByLongLat$Longitude))
mvtByLongLat$Latitude <- as.numeric(as.character(mvtByLongLat$Latitude))
head(mvtByLongLat)


#### plot points on the Chicago map
ggmap(chicago) + 
  geom_point(data = mvtByLongLat,
             aes(x = Longitude, y = Latitude, color = Count, size = Count))



#### remove 0-count points and re-plot with better color scheme
head(mvtByLongLat)
mvtByLongLat <- subset(mvtByLongLat, Count != 0)

ggmap(chicago) + 
  geom_point(data = mvtByLongLat,
             aes(x = Longitude, y = Latitude, color = Count, size = Count)) + 
  scale_color_gradient(low = 'white', high = 'red') +
  xlab('Longitude') + 
  ylab('Latitude') + 
  ggtitle('Map of Motor Vehicle Thefts (2001 - 2012)')
dev.copy(png, './figures/map1_motor_vehicle_thefts_2001-2012.png')
dev.off()



#### re-plot to render a heatmap-like map with geom_tile
ggmap(chicago) + 
  geom_tile(data = mvtByLongLat,
            aes(x = Longitude, y = Latitude))

ggmap(chicago) + 
  geom_tile(data = mvtByLongLat,
            aes(x = Longitude, y = Latitude, alpha = Count))

ggmap(chicago) + 
  geom_tile(data = mvtByLongLat,
            aes(x = Longitude, y = Latitude, alpha = Count),
            fill = 'red')

ggmap(chicago) + 
  geom_tile(data = mvtByLongLat,
            aes(x = Longitude, y = Latitude, alpha = Count),
            fill = 'red') + 
  xlab('Longitude') + 
  ylab('Latitude') +
  ggtitle('Map of Motor Vehicle Thefts (2001 - 2012)')
dev.copy(png, './figures/map2_motor_vehicle_thefts_2001-2012.png')
dev.off()