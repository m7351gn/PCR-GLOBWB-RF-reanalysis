####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####
source('fun_2_3_apply_optimalRF.R')

stationInfo <- read.csv('../../../data/stationLatLon.csv')

outputDirReanalysis <- '../../../../reanalysis/reanalysis_flowdepth/'
dir.create(outputDirReanalysis, showWarnings = F, recursive = T)

#### reanalysis - predict residuals for test stations ####
#### all predictors
print('allpredictors: reading trained RF...')
optimal_ranger <- readRDS('../../../RF/train/trainedRF.rds')
print('calculation: initiated')
mclapply(1:nrow(stationInfo), key='allpredictors',apply_optimalRF, mc.cores=24)
