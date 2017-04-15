# Name: Kriging_Ex_02.py
# Description: Interpolates a surface from points using kriging.
# Requirements: Spatial Analyst Extension
# Import system modules

import arcpy
from arcpy import env
from arcpy.sa import *

# Set environment settings
env.workspace = "D:/BaiduNetdiskDownload/matlab/python/out"

# Set local variables
# inFeatures = out_Layer
inFeatures = "D:/script/arcgis/smap.gdb/"+"SMAP_L4_SM_aup_20150501T030000_Vb1010_001"
field = "l4_sm"
outVarRaster = "D:/script/arcgis/smap.gdb/"+"Kriging_"+"SMAP_L4_SM_aup_20150501T030000_Vb1010_001"

# Set complex variables
kModelOrdinary = KrigingModelOrdinary("Spherical")

# Check out the ArcGIS Spatial Analyst extension license
arcpy.CheckOutExtension("Spatial")

# Execute Kriging
outKriging = Kriging(inFeatures, field, kModelOrdinary)

# Save the output 
outKriging.save(outVarRaster)
