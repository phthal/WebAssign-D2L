## create STUDENT LIST file
###########################
source('config.R')


# import students names and IDs from Grades Book
q = read.csv(file.path(source.path,file.D2L.GRADEBOOK))

d = data.frame(
    OrgDefinedId = q$OrgDefinedId,
    Last.Name = q$Last.Name,
    First.Name = q$First.Name,
    UniqName = toupper(paste(substr(q$Last.Name,1,3),substr(q$First.Name,1,1)))
)
if (length(unique(d$UniqName))<nrow(d)) print ("ERROR: unique name is not unique, change the length.")

write.csv(d, file=file.path(source.path,file.STUDENT.LIST), row.names = FALSE)

# quick check
head(d)
