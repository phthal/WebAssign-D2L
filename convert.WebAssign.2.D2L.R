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
library(stringr)
# find the most recent WebAssign file
file.list = file.path(source.path, 
                      dir(source.path, pattern = '\\d{6,}\\.csv$'))
fname = file.list[which.max(file.info(file.list)$mtime)]
print(paste("Scores from: ",file.info(fname)$mtime))

# Read Data
###########
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# read headers from WebAssign
d = read.csv(fname, skip=4, header=TRUE, stringsAsFactors = FALSE)
my.headers = names(d)
points.max = as.numeric(d[2,])
my.headers 

# read WebAssign Data
d = read.csv(fname, skip=9, header=FALSE, stringsAsFactors = FALSE)
names(d) = my.headers
head(d)

# only get chapters with homework and scale
###########################################
chapters = which(substr(names(d),1,3)==HOMEWORK.NAME)
for(chp in chapters) {
  d[,chp] = as.numeric(d[,chp])
  d[is.na(d[,chp]),chp] <- 0
  d[,chp] = signif(d[,chp]/points.max[chp]*MAX.BB.VALUE,3)
}

# kepp only relevant columns
d1 = d[,c(1,3,chapters)]
d1$OrgDefinedId = paste("#",str_sub(paste("0000",d1$X.1,sep=''), start= -9),sep='')
d1


# load the D2L template
###############################
if(!file.exists(source.template.file)) {
    print(paste("ERROR: Template File not found:", source.template.file))
}
d.template = read.csv(source.template.file, check.names=FALSE)
first.col = which(grepl('.*Points Grade.*',names(d.template))==TRUE)[1]
Points.Grade = names(d.template)[first.col:(ncol(d.template))]
gsub('\\s*<.*>','',Points.Grade) -> Points.Grade

d1$X.1 = d1$Assignment.Name
d1$Assignment.Name = d1$OrgDefinedId
head(d1)

l.col = ncol(d1)-1
names(d1)[3:l.col] <- Points.Grade[1:(l.col-2)]
names(d1)[ncol(d1)] = "End-of-Line Indicator"    # add the sapce there
d1[,ncol(d1)] = "#"

# write data to file
####################
write.csv(d1, file = file.D2L.IMPORT, row.names = FALSE)

