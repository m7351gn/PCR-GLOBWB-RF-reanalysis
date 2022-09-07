####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####

stationInfo <- read.csv('../../../data/stationLatLon.csv')

#pcr-globwb time series 1979-2019
filePathDischarge <- '../../../../preprocess/pcr_discharge/'
filePathStatevars <- '../../../../preprocess/pcr_statevars/'

upstreamArea <- read.csv('../../../data/upstream_area.txt', sep = "" , header = F)
colnames(upstreamArea) <- c('lon','lat','area_pcr')
upstreamArea$area_pcr <- upstreamArea$area_pcr/1000000 #m2 to km2

outputDir <- '../../../data/predictors/pcr_qstatevars/'
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)

# datetime as pcr-globwb run
startDate <- '1979-01-01'
endDate <- '2019-12-31'
dates <- seq(as.Date("1979-01-01"), as.Date("2019-12-31"), by="month")

source('fun_0_preprocess_pcr_qstatevars.R')
mclapply(1:nrow(stationInfo), create_predictor_table, mc.cores=48)
