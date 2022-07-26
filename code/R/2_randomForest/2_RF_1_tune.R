####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####

outputDir <- '../../../RF/tune/'
dir.create(outputDir, showWarnings = F, recursive = T)

train_data <- vroom('../../../RF/rf_input/train_table.csv', show_col_type=F)
rf_input <- train_data %>% select(., -datetime)
#--------------RF---------------
#-----------1. Tune parameter---------------
hyper_grid <- expand.grid(
  ntrees = c(10,100,300,500,900), 
  ntrees = 200, #only use 200 trees for rapid tuning
#~   mtry = c(27)
  mtry = 26
)

source('fun_2_1_hyperTuning.R')
num.threads <- 48
hyper_trains <- lapply(1:nrow(hyper_grid), hyper_tuning)

for(i in 1:nrow(hyper_grid)){
  hyper_grid$ntrees[i]   <- hyper_trains[[i]]$num.trees
  hyper_grid$mtry[i]     <- hyper_trains[[i]]$mtry
  hyper_grid$OOB_RMSE[i] <- sqrt(hyper_trains[[i]]$prediction.error)
}
  
print(paste0('output csv file: ', outputDir, 'hyper_grid_mtry_5-30.csv'))
write.csv(hyper_grid, paste0(outputDir, 'hyper_grid_ntrees_10-900.csv'), row.names = F)
