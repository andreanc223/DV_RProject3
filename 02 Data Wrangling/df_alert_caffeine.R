library(RCurl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(jsonlite)
require(jsonlite)

dfa <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tsleepalert"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

dfb <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tbackground"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

dfd <- inner_join(dfa, dfb, by="ID_NUMBER")

#Average Caffeine Level vs Alertness
poop <- dfd %>% select(ID_NUMBER, ALERTNESS, CAFFEINE) %>% group_by(ALERTNESS) %>% summarise(avg=mean(CAFFEINE))
g <- ggplot(poop, aes(x=ALERTNESS, y=avg)) + geom_point()
g + theme(legend.position="none") + labs(x="Alertness Level", y="Average Caffeine Level", title="Average Caffeine Level vs Alertness")

