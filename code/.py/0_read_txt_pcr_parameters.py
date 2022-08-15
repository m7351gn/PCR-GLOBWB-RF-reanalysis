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


import pandas as pd
import os 
import numpy as np
import re
from sklearn.preprocessing import scale
from alive_progress import alive_bar

loc = pd.read_csv('../../data/stationLatLon.csv')
filePath = '../../data/preprocess/pcr_parameters_txt/'
parameterList = os.listdir(filePath)
outputFile = '../../data/stationLatLon_catchAttr.csv'

def get_names(): 
	
	get_names.varNames = [None] * len(parameterList)
	for i in range(len(parameterList)):
		get_names.varNames[i] = re.search('upstream_norm_(.*).txt', parameterList[i])
		get_names.varNames[i] = get_names.varNames[i].group(1)
				   
# parameter extraction, scaling and attach to stationLatLon.csv
get_names()

with alive_bar(len(parameterList), force_tty=True) as bar:

	for i in range(len(parameterList)):

		df = pd.read_csv((filePath + parameterList[i]))
		df.columns = ['lon','lat', get_names.varNames[i]]
		# append to stationLatLon
		loc = pd.merge(loc, df, on=['lon','lat'], how='left').fillna(method='ffill')
		loc_normalized = pd.Dataframe(scale(loc), index=loc.index, columns=
	
	bar()

loc.rename(columns={'area' : 'area_pcr'}, inplace=True) 
print(loc)
loc.to_csv(outputFile, index=False)
