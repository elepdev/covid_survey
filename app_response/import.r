# This script reads a CSV file in GNU R.
# While reading this file, comments will be created for all variables.
# The comments for values will be stored as attributes (attr) as well.
# This script has been generated by SocSci and modified by Eurofound. 

# API link of the SocSci database of the Eurofound survey. API token is confidential and stored in secrets file.
source("secrets.R")

vars <- c("STARTED","B003_01","TIME_SUM","B001","FINISHED","F021","D001","B002","F004")

varlist <- vars[1]
for (var in vars[2:length(vars)]) {
  
  varlist <- paste0(varlist,",",var)
  
}

ds_file = paste0("https://s2survey.net/eurofound/?act=", token,"&vList=",varlist)

updateProgressBar(
  session = session,
  id = "load_data",
  value = 25
)

# Reading in the data. 
ds = read.table(
  file=ds_file, encoding="UTF-8",
  header = FALSE, sep = "\t", quote = "\"",
  dec = ".",
  col.names = vars,
  as.is = TRUE,
  colClasses = c(
    STARTED="POSIXct", B001="numeric",B002="numeric", B003_01="numeric",D001="numeric",
    F004="numeric", F021="character",TIME_SUM="integer",FINISHED="logical"
  ),
  skip = 1,
  check.names = TRUE, fill = TRUE,
  strip.white = FALSE, blank.lines.skip = TRUE,
  comment.char = "",
  na.strings = ""
)

rm(ds_file)

updateProgressBar(
  session = session,
  id = "load_data",
  value = 75
)

attr(ds, "project") = "eurofound"
attr(ds, "description") = "Eurofound e-survey Living, working and COVID-19 "
attr(ds, "date") = Sys.time()
attr(ds, "server") = "https://s2survey.net"

# Variable und Value Labels
ds$B001 = factor(ds$B001, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60"), labels=c("Austria","Belgium","Bulgaria","Croatia","Republic of Cyprus","Czechia","Denmark","Estonia","Finland","France","Germany","Greece","Hungary","Ireland","Italy","Latvia","Lithuania","Luxembourg","Malta","Netherlands","Poland","Portugal","Romania","Slovakia","Slovenia","Spain","Sweden","Albania","Bosnia and Herzegovina","Brazil","Canada","China","Colombia","Ecuador","Egypt","India","Indonesia","Iran","Japan","Mexico","Montenegro","Morocco","Netherlands Antilles","Nigeria","North Macedonia","Pakistan","Philippines","Russia","Republic of Serbia","South Korea","Switzerland","Suriname","Syria","Thailand","Turkey","Ukraine","United Kingdom","United States","Vietnam","Other country"), ordered=FALSE)
ds$B002 = factor(ds$B002, levels=c("1","2","3"), labels=c("Male","Female","In another way"), ordered=FALSE)
ds$D001 = factor(ds$D001, levels=c("1","2","3","4","5","6","7","8"), labels=c("Employee","Self-employed with employees","Self-employed without employees","Unemployed","Unable to work due to long-term illness or disability","Retired","Full-time homemaker/fulfilling domestic tasks","Student"), ordered=FALSE)
ds$F004 = factor(ds$F004, levels=c("1","2","3"), labels=c("Primary education","Secondary education","Tertiary education"), ordered=TRUE)

updateProgressBar(
  session = session,
  id = "load_data",
  value = 80
)


attr(ds$FINISHED,"F") = "Canceled"
attr(ds$FINISHED,"T") = "Finished"

comment(ds$STARTED) = "Time the interview has started (Europe/Berlin)"
comment(ds$B001) = "Country"
comment(ds$B002) = "Gender"
comment(ds$B003_01) = "Age"
comment(ds$D001) = "Employment status"
comment(ds$F004) = "Education"
comment(ds$F021) = "Person ID (SERIAL)"

comment(ds$TIME_SUM) = "Time spent overall (except outliers)"
comment(ds$FINISHED) = "Has the interview been finished (reached last page)?"

updateProgressBar(
  session = session,
  id = "load_data",
  value = 90
)

#Getting list of all numeric variables
nums <- unlist(lapply(ds, is.numeric))  
num_vars <- names(nums[nums==TRUE])

#Replacing all -1 and -9 values of numeric variables with NA
for (var in num_vars) {
  
  ds[var][ds[var]==-1 | ds[var]==-9] <- NA
  
}

updateProgressBar(
  session = session,
  id = "load_data",
  value = 100
)