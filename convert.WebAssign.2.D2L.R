#########################################################
#
# Author: Thomas Gredig
#
# converts WebAssign scores in
# uploadable scores for BeachBoard
#
# see README file for instructions on how to use
#
#########################################################



# Configuration
###############
source('config.R')

# find the most recent WebAssign file
file.list = file.path(source.path, dir(source.path, '\\d{6+}\\.csv$'))
fname = file.list[which.max(file.info(file.list)$mtime)]
print(paste("Scores from: ",file.info(fname)$mtime))

# Read Data
###########
library(stringr)

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

d = read.csv(fname, skip=4, header=TRUE, stringsAsFactors = FALSE)
my.headers = names(d)
points.max = as.numeric(d[2,])
my.headers 

d = read.csv(fname, skip=9, header=FALSE, stringsAsFactors = FALSE)
names(d) = my.headers
head(d)

# only get chapters with homework
##################################
chapters = which(substr(names(d),1,3)==HOMEWORK.NAME)
q = d[,chapters]
points.max = points.max[chapters]
q = as.data.frame(lapply(q, as.numeric))

# add first and last names and student ID
#########################################
unlist(lapply(strsplit(d$Assignment.Name, ","),'[[',1)) -> LastNames
unlist(lapply(strsplit(d$Assignment.Name, ","),'[[',2)) -> FirstNames
q$FirstNames = trim(FirstNames)
q$LastNames = trim(LastNames)
q$OrgDefinedId = paste("#",str_sub(paste("0000",d$X.1,sep=''), start= -9),sep='')
head(q)


# select homework columns and scale results
###########################################
d3 = as.data.frame(lapply(d[,which(substr(names(d),1,3)==HOMEWORK.NAME)], as.numeric))
head(d3)
d3[is.na(d3)] <- 0

for(i in 1:ncol(d3)) {
  d3[,i] = signif(d3[,i]/points.max[i]*MAX.BB.VALUE,3)
}
d3
q1 = data.frame(
  OrgDefinedId = q$OrgDefinedId,
  FirstNames = q$FirstNames,
  LastNames = q$LastNames,
  d3,
  EndLine = rep("#",nrow(q))
)


# load the D2L template
###############################
if(!file.exists(source.template.file)) {
    print(paste("ERROR: Template File not found:", source.template.file))
}
d1 = read.csv(source.template.file, check.names=FALSE)
names(d1)
first.col = which(grepl('.*Points Grade.*',names(d1))==TRUE)[1]
head(q1)
Points.Grade = names(d1)[first.col:(ncol(q1))]
gsub('\\s*<.*>','',Points.Grade) -> Points.Grade
names(q1)[4:(ncol(q1)-1)] <- Points.Grade
names(q1)[ncol(q1)] = " End-of-Line Indicator"    # add the sapce there

# remove instructors
####################
q1 = q1[-which(q1$OrgDefinedId=='#0000NA'),] 


# write data to file
####################
str(q1)
head(q1)
q1$FirstNames <- NULL
q1$LastNames <- NULL
tail(q1)
write.csv(q1, file = file.D2L.IMPORT, row.names = FALSE)

