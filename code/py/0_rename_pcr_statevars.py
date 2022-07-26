# !/usr/bin/env python2
# -*- coding: utf-8 -*-
"""

@author: mikmagni

"""
#========================================================================
#
#   This script extracts catchment attributes and updates them to stationLatLon.csv       
# 
#
#======================================================================== 

from multiprocessing import Pool
import xarray as xr
import pandas as pd
import os 
import numpy as np
import tqdm

loc = pd.read_csv('../../data/stationLatLon.csv')
filePath = '/scratch/6574882/pcr_statevars/'
fileList = os.listdir(filePath)
outputPath = '/scratch/6574882/pcr_statevars_renamed/'

if not os.path.exists(outputPath):
    os.makedirs(outputPath)

def rename_statevars_files(station):
	
	df = pd.read_csv(filePath + fileList[station])
	
	df.to_csv(outputPath + 'pcr_statevars_' + str(station+1) + '.csv')
	
	
station_idx = np.array(range(len(loc)-1)) #set vector of indexes
pool = Pool(processes=32) # set number of cores

for _ in tqdm.tqdm(pool.imap_unordered(rename_statevars_files, station_idx), total=len(station_idx)):
	pass
	
