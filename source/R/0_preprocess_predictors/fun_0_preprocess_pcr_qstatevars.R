create_predictor_table <- function(i){
  
  station_no <- stationInfo$grdc_no[i]
  upstreamArea_point <- upstreamArea$area_pcr[i]
  print(station_no)
  ####-------discharge-------####
  # if(upstreamArea < 10000){
  #   
  #   pcr <- read.csv(paste0(filePathDischarge, 'pcr_discharge_', station_no, '.csv')) %>%
  #     mutate(datetime=as.Date(datetime)) %>% mutate(pcr=numeric(492))
  #   
  # }
  # else{
    
    pcr <- read.csv(paste0(filePathDischarge, 'pcr_discharge_', station_no, '.csv')) %>%
      mutate(datetime=as.Date(datetime)) %>% mutate(pcr=pcr/upstreamArea_point*0.0864)
    
  # }

  pred <- read.csv(paste0(filePathStatevars, 'pcr_statevars_',station_no,'.csv')) %>%
    mutate(datetime=as.Date(datetime)) %>% 
    select(-c('channelStorage', 'totLandSurfaceActuaET')) 
  
  ####-------normalize statevars [-1 1] and join to q-------####
  
  pred_norm <- pred %>% select(-datetime)
  pred_norm <- scale(pred_norm) %>%
    cbind(pred %>% select(datetime),.) %>%
    mutate(datetime=as.Date(datetime))
  pred_norm[is.na(pred_norm)] <- 0
  
  pred_table <- inner_join(pcr, pred_norm, by='datetime')
  
  write.csv(pred_table, paste0(outputDir, 'pcr_qstatevars_',
                               station_no, '.csv'), row.names = F)
}
