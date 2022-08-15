####-------------------------------####
source('../fun_0_loadLibrary.R')
####-------------------------------####
source('fun_2_2_trainRF.R')

outputDir <- '../../../RF/train/'
dir.create(outputDir, showWarnings = F, recursive = T)

#-------train RF with tuned parameters on all available observations----------
#### all predictors ####
print('training: all predictors...')
train_data <- vroom(paste0('../../../RF/rf_input/train_table.csv'),
                     show_col_types = F)
rf_input <- train_data %>% select(., -datetime)
optimal_ranger <- trainRF(rf_input, num.trees=500, mtry=26, num.threads=48)

print('saving...')
saveRDS(optimal_ranger, paste0(outputDir,'trainedRF.rds'))                    
vi_df <- data.frame(names=names(optimal_ranger$variable.importance)) %>%
  mutate(importance=optimal_ranger$variable.importance)                     
write.csv(vi_df, paste0(outputDir,'varImportance.csv'), row.names=F)
