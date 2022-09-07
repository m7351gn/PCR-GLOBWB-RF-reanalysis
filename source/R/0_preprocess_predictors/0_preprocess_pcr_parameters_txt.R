####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####
library(stringr)
library(DataVisualizations)

#input/output
allPixels_coord <- read.csv('../../../data/stationLatLon.csv')
outputFile <- '../../../data/allpoints_catchAttr.csv'

#extract parameter names 
filePath <- '../../../data/preprocess/pcr_parameter_maps_upstream_txt/'
parameterList <- list.files(filePath)
pattern <- "upstream_\\s*(.*?)\\s*.txt"
parameterStrings <- str_match(parameterList, pattern)
parameterNames <- parameterStrings[,2]

# concatenate all parameters and join to stationLatLon
for(i in 1:length(parameterNames)){
  
  parameterX <- parameterNames[i]
  
  parameter <- read.csv(paste0(filePath, parameterList[i]), sep = "" , header = F) %>% 
    select(.,V3) %>% rename_with(~parameterX, V3)
  
  if(i==1){
    merged_parameters <- cbind(allPixels_coord,parameter)
  }
  else{
    merged_parameters <- CombineCols(merged_parameters,parameter)
  }
}

#fill missing values from top and from bottom
merged_parameters <- merged_parameters %>% rename(area_pcr=area) %>% 
  fill(groundwaterDepth, .direction='downup') %>% 
  fill(aqThick, .direction='downup')

#scale (mean=0, sd=1)
merged_parameters_normalized <- as.data.frame(scale(merged_parameters)) 
merged_parameters_normalized[['grdc_no']] <- merged_parameters$grdc_no
merged_parameters_normalized[['lon']] <- merged_parameters$lon
merged_parameters_normalized[['lat']] <- merged_parameters$lat

#save to disk
write.csv(merged_parameters_normalized, outputFile, row.names=F)
