# Configuration
###############

# configure the course path
source.path = '2019 Spring/WebAssign'

# source file with gradebook for course
file.D2L.GRADEBOOK = 'D2L-Course-Gradebook.csv'
file.STUDENT.LIST = 'Student-List.csv'

# has ot appear in each of the assignments, select these columns, first THREE chars
HOMEWORK.NAME ="Hwk"   

# max value on BeachBoard, scores are scaled to this value
MAX.BB.VALUE = 10    


################# Other definitions
if (file.exists('myConfig.R')) {
    source('myConfig.R')
}

# go to D2L and save WebAssign grades into this file
source.template.file = file.path(source.path, file.D2L.GRADEBOOK)
file.D2L.IMPORT = file.path(source.path, 'WebAssign-IMPORT.csv')