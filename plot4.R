library(dplyr)
library(ggplot2)

###Reading the data (rds files must be in working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#in SCC we keep only the sources regaring coal combustion
simpleSCC <- SCC %>% select(SCC, Short.Name)
simpleSCC <- subset(simpleSCC, simpleSCC$Short.Name %in% grep("comb.*coal", simpleSCC$Short.Name, ignore.case = TRUE, value = TRUE))

#now we merge and thus keep only coal combustion related sources in NEI2
NEI2 <- merge(NEI, simpleSCC, by = "SCC")


NEI3 <- NEI2 %>% select(Emissions, year) %>% group_by(year) %>% summarise_each(funs(sum))


qplot(year, Emissions, data = NEI3, main = "PM2.5 Emissions from coal combustion related sources in the US")
ggsave("plot4.png")
dev.off()
