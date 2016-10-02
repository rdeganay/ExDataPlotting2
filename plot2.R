library(dplyr)

###Reading the data (rds files must be in working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimore <- subset(NEI, fips == "24510")
byyear <- split(baltimore, baltimore$year)

#we only keep the sources that are present in all 4 years of measurements,
#otherwise comparison between the years does not make much sense
#we store this in baltimore2
commonSCC <- byyear[[1]]$SCC
for(i in 2:4) {
  commonSCC <- intersect(commonSCC, byyear[[i]]$SCC)
}

baltimore2 <- subset(baltimore, SCC %in% commonSCC)



#and now we plot
byyear2 <- baltimore2 %>% select(Emissions, year) %>% group_by(year) %>% summarise_each(funs(sum))

png(filename = "plot2.png")
plot(byyear2$year, byyear2$Emissions, xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", main = "Total PM2.5 Emissions in Baltimore")
dev.off()
