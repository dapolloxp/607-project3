---
title: "Project3 5:23PM"
author: "David Apolinar, Anthony Muñoz, Christina Valore, Omar Pineda"
date: "3/12/2019"
output: html_document
---

library(tidyr)
library(wordcloud)
library(tm)
library(SnowballC)
library(RColorBrewer)
library(magrittr)
library(DBI)

#  Data Files
ds <- read.csv("https://raw.githubusercontent.com/omarp120/DATA607Week8/master/DataScientists.csv", header=TRUE, stringsAsFactors = FALSE)
tidyDS <- gather(ds, "Number", "Skill", Skill1:Skill50) #makes data tall
finalDS <- tidyDS[tidyDS$Skill != "",] #removes rows with empty skill values
counts <- as.data.frame(table(finalDS$Skill)) #creates a data frame with skill frequencies
colnames(counts) <- c("Skill", "Freq")
wordcloud(counts$Skill, counts$Freq, random.order = FALSE, scale = c(2, 0.01), colors=brewer.pal(8, "Dark2"))

# Create Skill Table
skilltable <- unique(finalDS$Skill)
skilltable <- as.data.frame(skilltable, stringsAsFactors = FALSE)

skillids <- 1:nrow(skilltable)

skilltable <- cbind.data.frame(skilltable,skillids)
names(skilltable) <- c("SkillName", "SkillID")

# Create SQL Connection

con <- dbConnect(RMariaDB::MariaDB(), user='x-admin@cunyspsmysql.mysql.database.azure.com', password="7dWa0XUVHtlCJMS", dbname='datascientists' ,host='cunyspsmysql.mysql.database.azure.com')

#mysql_datascientists <- dbGetQuery(con, 'select * from skills')
for(i in 1:nrow(skilltable))
{
  print(paste0("Inserting Skill: ", skilltable[i,]$SkillName, ", SkillID: ", skilltable[i,]$SkillID) )
  sql <- sprintf("insert into skills
                  (skillname, skillid)
               values ('%s', %d);",
               skilltable[i,]$SkillName, skilltable[i,]$SkillID)
  rs <- dbSendQuery(con, sql)
  dbClearResult(rs)
}

mysql_dataskills <- dbGetQuery(con, 'select * from skills')
mysql_dataskills
dbDisconnect(con)

# Get Unique People to Insert
con <- dbConnect(RMariaDB::MariaDB(), user='x-admin@cunyspsmysql.mysql.database.azure.com', password="7dWa0XUVHtlCJMS", dbname='datascientists' ,host='cunyspsmysql.mysql.database.azure.com')

people_table <- finalDS %>% select(Person, Title, School) %>% unique()

for(i in 1:nrow(people_table))
{
  print(paste0("Inserting Person: ", people_table[i,]$Person, ", Title: ", people_table[i,]$Title, "School: ",people_table[i,]$School) )
  sql <- sprintf("insert into person
                 (name, title, education)
                 values ('%s', '%s', '%s');",
                 people_table[i,]$Person, people_table[i,]$Title, people_table[i,]$School)
  rs <- dbSendQuery(con, sql)
  dbClearResult(rs)
}

mysql_datascientists <- dbGetQuery(con, 'select * from person')
mysql_datascientists
dbDisconnect(con)
#skilltable$SkillID[skilltable$SkillName == "OpenCV"]


# Create Many to Many Relationship
linkdb<- tidyDS %>% select(ID, Skill)
returnIndex <- function(n)
{
  for(i in 1:nrow(n))
  {
    
    return (skilltable$SkillID[skilltable$SkillName == n[i,]$Skill])
  }

}
# Remove duplicate rows
person_skill <- finalDS %>% select(ID, Person, Skill) %>% distinct()

#returnIndex(linkdb[478,])

# Create Link Table
con <- dbConnect(RMariaDB::MariaDB(), user='x-admin@cunyspsmysql.mysql.database.azure.com', password="7dWa0XUVHtlCJMS", dbname='datascientists' ,host='cunyspsmysql.mysql.database.azure.com')


for(i in 1:nrow(person_skill))
{
  if(length(returnIndex(person_skill[i,])) != 0)
  {
    print(paste0("Inserting (PersonID: ", person_skill[i,]$ID, " SkillID: ", returnIndex(person_skill[i,]),")") )
    
    sql <- sprintf("insert into person_skills
                 (personid, skillid)
                   values (%d, %d);",
                   person_skill[i,]$ID, returnIndex(person_skill[i,]))
    rs <- dbSendQuery(con, sql)
    dbClearResult(rs)
  }else
  {
    print("Empty Skill Value, skipping link")
  }
}

dbDisconnect(con)