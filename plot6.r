library(dplyr)
library(ggplot2)

###Reading the data (rds files must be in working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#in SCC we keep only the sources regarding mobile vehicles
simpleSCC <- SCC %>% select(SCC, EI.Sector)
simpleSCC <- subset(simpleSCC, simpleSCC$EI.Sector %in% grep("mobile.*vehicle", simpleSCC$EI.Sector, ignore.case = TRUE, value = TRUE))


#now we keep only sources from baltimore and LA, and we merge everything
baltimoreLA <- subset(NEI, fips %in% c("24510","06037"))
vehicles <- merge(baltimoreLA, simpleSCC, by = "SCC")

#now we group and we plot
vehicles2 <- vehicles %>% select(Emissions, year, fips) %>% group_by(year, fips) %>% summarise_each(funs(sum))
vehicles2$fips[vehicles2$fips=="06037"] = "LA County"
vehicles2$fips[vehicles2$fips=="24510"] = "Baltimore"

qplot(year, Emissions, data = vehicles2, facets = .~fips, main = "PM2.5 Emissions from Mobile Vehicles in Baltimore and LA County")
ggsave("plot6.png")
dev.off()