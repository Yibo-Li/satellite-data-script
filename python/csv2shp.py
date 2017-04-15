# Name: TableToTable_Example2.py
# Description: Use TableToTable with an expression to create a subset
#  of the original table.
# Author: ESRI

# Import system modules
import os
import arcpy
from arcpy import env
from arcpy.sa import *
 
# Set environment settings
env.workspace = "D:/BaiduNetdiskDownload/matlab/python/out"

for file in os.listdir("out"):
	if file.endswith(".csv"):
		# Set the local variables
		in_Table = file
		x_coords = "lon"
		y_coords = "lat"
		temp_Layer = "smap_layer"
		out_Location = "D:/BaiduNetdiskDownload/matlab/arcgis/smap2.gdb"    
		out_Layer = os.path.splitext(file)[0]
	 
		# Set the spatial reference
		spRef = r"Coordinate Systems/Geographic Coordinate Systems/World/WGS 1984.prj"
	 
		######################################################
		# 1.Make the XY event layer
		######################################################
		arcpy.MakeXYEventLayer_management(in_Table, x_coords, y_coords, temp_Layer, spRef)

		######################################################
		# 2.Execute FeatureClassToFeatureClass
		######################################################
		arcpy.FeatureClassToFeatureClass_conversion(temp_Layer, out_Location, out_Layer)
		
		# delete temp_Layer
		arcpy.Delete_management(temp_Layer)
				
		# Set local variables
		inFeatures = out_Location+"/"+out_Layer
		field = "l4_sm"
		outVarRaster = out_Location+"/Kriging_"+out_Layer

		# Set complex variables
		kModelOrdinary = KrigingModelOrdinary("Spherical")

		# Check out the ArcGIS Spatial Analyst extension license
		arcpy.CheckOutExtension("Spatial")

		######################################################
		# 3.Execute Kriging
		######################################################
		outKriging = Kriging(inFeatures, field, kModelOrdinary)

		# Save the output 
		outKriging.save(outVarRaster)
		
	    ######################################################
		# 4.Get the Band_1 cell value of certain point
		###################################################### 
		result = arcpy.GetCellValue_management(outVarRaster, "106.9344444 40.75144444", "1")
		g4 = result.getOutput(0)
		result = arcpy.GetCellValue_management(outVarRaster, "107.1401667 40.65580556", "1")
		g5 = result.getOutput(0)
		result = arcpy.GetCellValue_management(outVarRaster, "107.17375 40.97697222", "1")
		g7 = result.getOutput(0)
		result = arcpy.GetCellValue_management(outVarRaster, "107.1664722 40.89986111", "1")
		g8 = result.getOutput(0)

		# Open a file
		fo = open("smap_l4_bt.csv", "a")
		fo.write(out_Layer+','+g4+','+g5+','+g7+','+g8+"\n");

		# Close opend file
		fo.close()
		
		print out_Layer
