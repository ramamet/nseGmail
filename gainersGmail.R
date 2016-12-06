# supporting libraries
library(rvest)
library(reshape2)
library(XML)
library(ggplot2)
library(dplyr)
library(htmlTable)
library(lubridate)

# Select NSE200 stocks gainers data

url= paste("http://profit.ndtv.com/market/stocks-gainers/nifty200_daily")               

mypage <- read_html(url)
tbls <- html_nodes(mypage, "table")

mytbl <- tbls[[1]]
df0 <- html_table(mytbl,fill=TRUE)

colnames(df0)[1]="company"
colnames(df0)[2]="price"
colnames(df0)[4]="change"
colnames(df0)[5]="change.perc"

df1=select(df0,company,price,change,change.perc)

df1$change.perc= gsub("%","",df1$change.perc)

df1$change.perc= as.numeric(as.character(df1$change.perc))

df=df1

# Track your portfolio stocks

adani="Adani Enterprises"
cairn="Cairn India"
suntv="Sun TV Network"
lupin="Lupin"
yes="Yes Bank"
vedanta="Vedanta"
tatasteel="Tata Steel"
ongc="ONGC"
cipla="Cipla"
tatamotors="Tata Motors"
sbi="SBI"

df.sub=subset(df,
               df[,1]==adani |
               df[,1]==cairn |
               df[,1]==suntv |
               df[,1]==lupin |
               df[,1]==yes |
               df[,1]==vedanta |  
               df[,1]==tatasteel |
               df[,1]==ongc |
               df[,1]==cipla |
               df[,1]==tatamotors |
               df[,1]==sbi )

rownames(df.sub) <- NULL    

colnames(df.sub)[4]="%change"
               
            
 PNOW <- Sys.time()   
 print(htmlTable(df.sub, col.columns = c("none", "#F7F7F7"),caption=PNOW), 
       type="html", file="HTML/news_mail.html")           
 
 
 
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#************** Sending email results at particular time intervals
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
testit <- function(x)
{
    p1 <- proc.time()
    Sys.sleep(x)
    proc.time() - p1 # The cpu usage should be negligible
}

NNOW <- Sys.time()                                        # the current time

ddt= as.Date(NNOW)
start1=hms("04:00:20")
stop1=hms("10:30:20")

NOW=ddt+start1
stop.date.time.1=ddt+stop1

#lapse.time <- 24 * 60 * 60   # A day's worth of time in Seconds
lapse.time <- 3000   
all.exec.times.1 <- seq(stop.date.time.1, NOW, -lapse.time)

all.exec.times=sort(c(all.exec.times.1))
cat("To execute your code at the following times:\n"); print(all.exec.times)

for (i in seq(length(all.exec.times))) {   # for each target time in the sequence
  # How long do I have to wait for the next execution from Now.
 # wait.time <- difftime(Sys.time(), all.exec.times[i], units="secs") # calc difference in seconds.
 # cat("Waiting for", wait.time, "seconds before next execution\n")
 
  print(paste0("I'm still waiting...",lapse.time,"(secs)",sep=""))   
 
  testit(lapse.time)
  print("****************")
  
    {
    pc.time=Sys.time()
    print(paste0("sys.time=",pc.time,sep=""))
    Test=paste0("testing_",pc.time,sep="")
    
      # Put your execution code or function call here
      
          send.mail(from = "nsegainersindia@gmail.com",
          to = c("ramamet2@gmail.com"),
          subject= Test,
          body="HTML/news_mail.html",
          html = TRUE,
          inline = TRUE,
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "nsegainersindia", passwd = "indianse", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)
        
    }
}
               
          
               


 

