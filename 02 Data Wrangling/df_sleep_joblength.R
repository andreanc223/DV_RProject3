library(RCurl)
library(dplyr)
library(tidyr)
library(jsonlite)

dfa <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tsleepalert"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

dfb <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tbackground"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

dfc <- right_join(dfa, dfb, by="ID_NUMBER")

dfc %>% select(YEARS_IN_PRESENT_JOB, SLEEP_LENGTH, SLEEP_QUALITY) %>% group_by(SLEEP_QUALITY, SLEEP_LENGTH)%>% summarise(avg_years=mean(YEARS_IN_PRESENT_JOB)) %>% ggplot(aes(x=avg_years, y=SLEEP_LENGTH, color=SLEEP_QUALITY)) + geom_point() + ggtitle('Years Worked in Comparison to Sleep Length and Quality') +theme(plot.title=element_text(size=20,face="bold",vjust=1,lineheight=0.6)) + labs(x = 'Average Years Worked', y = 'Sleep Length (Years)') + scale_color_discrete(name="Sleep Quality")

