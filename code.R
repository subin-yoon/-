install.packages('rvest')
install.packages('ggplot2')
install.packages('ggmap')

library('rvest')
library('ggplot2')
library('ggmap')

install.packages('devtools')
library('devtools')
install_github('dkahle/ggmap')
library('ggmap')  #ggplot2를 활용해 지도를 편하게 그릴수있도록 도움


#구글 지도 API 키 발급
register_google(key='AlzaSyA0VDS3mzu-0RVwYVsl_Q2RZVHpgiBpxjw')  

#위키피디아에 있는 테이블 데이터 가져오기
html.airports <- read_html('https://en.wikipedia.org/wiki/List_of_busiest_airports_by_passenger_traffic')
df <- html_table(html_nodes(html.airports, 'table')[[1]], fill = TRUE)

colnames(df)[6] <- 'total'
df$total <- gsub('\\[[0-9]+\\]', '', df$total) #데이터 값 뒤에 붙어있는 [n] 제거
df$total <- gsub(',', '', df$total)
df$total <- as.numeric(df$total)
summary(df$total)
boxplot(df$total) #상자그림그리기

gc <- geocode(df$Airport) #특정 위치가 어느 위도,경도에 위치해있는지 알려준다.
df <- cbind(df, gc)

world <- map_data('world')
ggplot(df, aes(x=lon, y=lat)) +
  geom_polygon(data=world, aes(x=long, y=lat, group=group), fill='grey75', color='grey70') + 
  geom_point(color='dark red', alpha=.25, aes(size=total)) +
  geom_point(color='dark red', alpha=.75, shape=1, aes(size=total)) +
  theme(legend.position='none')
