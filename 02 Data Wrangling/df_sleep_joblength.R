library(RCurl)
library(dplyr)
library(tidyr)
library(jsonlite)
library(scales)

dfa <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tsleepalert"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

dfb <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tbackground"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

dfc <- right_join(dfa, dfb, by="ID_NUMBER")

dfc %>% select(YEARS_IN_PRESENT_JOB, SLEEP_LENGTH, SLEEP_QUALITY) %>% group_by(SLEEP_QUALITY, SLEEP_LENGTH)%>% summarise(avg_years=mean(YEARS_IN_PRESENT_JOB)) %>% ggplot(aes(x=SLEEP_LENGTH, y=avg_years, color=SLEEP_QUALITY)) + geom_point() + ggtitle('Years Worked in Comparison to Sleep Length and Quality') +theme(plot.title=element_text(size=20,face="bold",vjust=1,lineheight=0.6)) + labs(x = 'Sleep Length (Years)', y = 'Average Years Worked') + scale_color_discrete(name="Sleep Quality")

dfc %>% select(YEARS_IN_PRESENT_JOB, SLEEP_LENGTH, SLEEP_QUALITY) %>% group_by(SLEEP_QUALITY) %>% ggplot(aes(x=SLEEP_LENGTH, y=YEARS_IN_PRESENT_JOB, color=SLEEP_QUALITY)) + geom_point() + ggtitle('Years Worked in Comparison to Sleep Length and Quality') +theme(plot.title=element_text(size=20,face="bold",vjust=1,lineheight=0.6)) + labs(x = 'Sleep Length (Years)', y = 'Years Worked') + scale_color_discrete(name="Sleep Quality") + scale_y_continuous("YEARS_IN_PRESENT_JOB", c("10","20","30","40")) 

ggplot(dfc,aes(YEARS_IN_PRESENT_JOB, SLEEP_LENGTH))+geom_point(color="firebrick") + coord_cartesian(xlim=c(0,10))
