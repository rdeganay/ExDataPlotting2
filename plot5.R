library(dplyr)
library(ggplot2)

###Reading the data (rds files must be in working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#in SCC we keep only the sources regarding mobile vehicles
simpleSCC <- SCC %>% select(SCC, EI.Sector)
simpleSCC <- subset(simpleSCC, simpleSCC$EI.Sector %in% grep("mobile.*vehicle", simpleSCC$EI.Sector, ignore.case = TRUE, value = TRUE))


#now we keep only sources from baltimore, and we merge everything
baltimore <- subset(NEI, fips == "24510")
baltimoreVehicles <- merge(baltimore, simpleSCC, by = "SCC")

#now we group and we plot
baltimoreVehicles2 <- baltimoreVehicles %>% select(Emissions, year) %>% group_by(year) %>% summarise_each(funs(sum))

qplot(year, Emissions, data = baltimoreVehicles2, main = "PM2.5 Emissions from Mobile Vehicles in Baltimore")
ggsave("plot5.png")
dev.off()