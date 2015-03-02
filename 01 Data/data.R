library(RCurl)
library(dplyr)
library(tidyr)
library(ggplot2)

dfa <- data.frame(eval(parse(text=substring(getURL(URLencode('http://129.152.144.84:5001/rest/native/?query="select * from tsleepalert"'), httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnFor = 'R', returnDimensions = 'False'), verbose = TRUE), 1, 2^31-1))))
dfb <- data.frame(eval(parse(text=substring(getURL(URLencode('http://129.152.144.84:5001/rest/native/?query="select * from tbackground"'), httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnFor = 'R', returnDimensions = 'False'), verbose = TRUE), 1, 2^31-1))))
dfc <- data.frame(eval(parse(text=substring(getURL(URLencode('http://129.152.144.84:5001/rest/native/?query="select * from tactivity"'), httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnFor = 'R', returnDimensions = 'False'), verbose = TRUE), 1, 2^31-1))))

dfd <- inner_join(dfa, dfb, by="ID_NUMBER")
dfe <- left_join(dfa, dfc, by="ID_NUMBER")

#different activity types
dfe %>% select(ID_NUMBER, ACTIVITY) %>% group_by(ACTIVITY) %>% count(ACTIVITY)
g <- ggplot(dfe, aes(ACTIVITY)) + geom_bar()
g + geom_bar(width=.7) + theme(legend.position="none") + labs(x="Activity Type", y="Count", title="Count of Different Activity Types")

#sleep quality different activity types
poop <- dfe %>% select(ID_NUMBER, SLEEP_QUALITY, ACTIVITY) %>% group_by(ACTIVITY) %>% summarise(avg=mean(SLEEP_QUALITY))
g <- ggplot(poop, aes(x=ACTIVITY, y=avg)) + geom_point()
g + theme(legend.position="none") + labs(x="Activity Type", y="Avg Quality of Sleep", title="Quality of Sleep with Different Activity Types")

#Average Caffeine Level vs Alertness
poop <- dfd %>% select(ID_NUMBER, ALERTNESS, CAFFEINE) %>% group_by(ALERTNESS) %>% summarise(avg=mean(CAFFEINE))
g <- ggplot(poop, aes(x=ALERTNESS, y=avg)) + geom_point()
g + theme(legend.position="none") + labs(x="Alertness Level", y="Average Caffeine Level", title="Average Caffeine Level vs Alertness")

filter(dfe, ACTIVITY == "P" )
