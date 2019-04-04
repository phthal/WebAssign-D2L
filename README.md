# WebAssign-D2L

Converts the scores from WebAssign into the format for Desire2Learn (including BeachBoard) to import quickly.

## Configuration

Run `RStudio` and open the project. 

1) configure paths in `config.R` and 
1) personalized configuration in `myConfig.R` (overwrites `config.R`)
1) enter columns in D2L gradebook
1) export gradebook from D2L and save in file `D2L-Course-Gradebook.csv`
1) run `make.Student.List.R` to create file `Student-List.csv`


## Transfer Grades

1) In WebAssign, go to `ScoreView`
2) Select `Past Assignments`
3) Download CSV file and move to folder from configuration `config.R`
4) Run `convert.WebAssign.2.D2L.R`
5) Import grades in D2L 

