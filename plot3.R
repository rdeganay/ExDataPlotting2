library(dplyr)
library(ggplot2)

###Reading the data (rds files must be in working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimore <- subset(NEI, fips == "24510")
baltimore2 <- baltimore %>% select(Emissions, type, year) %>% group_by(type, year) %>% summarise_each(funs(sum))


qplot(year, Emissions, data = baltimore2, facets = .~type)
ggsave("plot3.png")
dev.off()
