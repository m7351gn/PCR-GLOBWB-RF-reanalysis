####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####

# convert flow depth reanalysis to discharge 
# m/d -> m3/s 

stationInfo <- read.csv('stationLatLon.csv')
upstreamArea <-  read.csv('upstream_area.txt', sep = "" , header = F)

flowDepthPath <- 'reanalysis_flowdepth/'

outputDir <- 'reanalysis_discharge/'
dir.create(outputDir, showWarnings = FALSE, recursive = TRUE)

depth_to_volume <- function(i){
	
	station_no <- stationInfo$grdc_no[i]
	ups_area <- upstreamArea[i,3]
	print(station_no)
	
	flowdepth <- read.csv(paste0(flowDepthPath, 'pcr_rf_reanalysis_monthly_30arcmin_',
					station_no, '.csv'))
					
	discharge <- flowdepth %>% mutate(pcr_corrected=round(pcr_corrected*ups_area/86400),3) %>%
					mutate(datetime=as.Date(datetime))
	
	write.csv(discharge, paste0(outputDir, 'pcr_rf_reanalysis_monthly_30arcmin_',
					station_no, '.csv'), row.names = F)
					
}

mclapply(1:nrow(stationInfo), depth_to_volume, mc.cores=48)
