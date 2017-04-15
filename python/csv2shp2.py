# Name: csv2shp.py
# Description: Use csv files to create shps
# Developed by "Yibo Li"<gansuliyibo@126.com>

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
		z_coords = "l4_sm"
		temp_Layer = "smap_layer"
		out_Location = "D:/BaiduNetdiskDownload/matlab/arcgis/smap3.gdb"
		out_Layer = os.path.splitext(file)[0].replace(".", "_")
		
		# Open a file
		fo = open("smap.csv", "a")
		fo.write(out_Layer)

		# Set the spatial reference
		spRef = r"Coordinate Systems/Geographic Coordinate Systems/World/WGS 1984.prj"

		######################################################
		# 1.Make the XY event layer
		######################################################
		try:
			arcpy.MakeXYEventLayer_management(in_Table, x_coords, y_coords, temp_Layer, spRef, z_coords)
		except:
			print "NaN Point: " + out_Layer
			fo.write("\n")
			continue

		######################################################
		# 2.Execute FeatureClassToFeatureClass
		######################################################
		arcpy.FeatureClassToFeatureClass_conversion(temp_Layer, out_Location, out_Layer)

		# delete temp_Layer
		arcpy.Delete_management(temp_Layer)

		# Set local variables
		inFeatures = out_Location+"/"+out_Layer
		field = z_coords
		outVarRaster = out_Location+"/Kriging_"+out_Layer

		# Set complex variables
		kModelOrdinary = KrigingModelOrdinary("Spherical")

		# Check out the ArcGIS Spatial Analyst extension license
		arcpy.CheckOutExtension("Spatial")

		######################################################
		# 3.Execute Kriging
		######################################################
		try:
			outKriging = Kriging(inFeatures, field, kModelOrdinary)
		except:
			print "NaN Kriging: " + out_Layer			
			continue

		# Save the output
		outKriging.save(outVarRaster)

	    ######################################################
		# 4.Get the Band cell value of certain point
		######################################################
		# result = arcpy.GetCellValue_management(outVarRaster, "9007330.550  4531449.805", "1")
		result = arcpy.GetCellValue_management(outVarRaster, "106.940164  40.751444", "1")
		g4 = result.getOutput(0)
		
		# result = arcpy.GetCellValue_management(outVarRaster, "9038336.089  4520644.845", "1")
		result = arcpy.GetCellValue_management(outVarRaster, "107.139023  40.651224", "1")
		g5 = result.getOutput(0)
		
		# result = arcpy.GetCellValue_management(outVarRaster, "8997308.557  4556661.380", "1")
		# result = arcpy.GetCellValue_management(outVarRaster, "8997308.557  4556661.380", "1")
		# g7 = result.getOutput(0)
		
		# result = arcpy.GetCellValue_management(outVarRaster, "9007330.550  4547892.136", "1")
		result = arcpy.GetCellValue_management(outVarRaster, "107.163040  40.903576", "1")
		g8 = result.getOutput(0)

		# Open a file
		fo.write(','+g4+','+g5+','+g8+"\n")

		# Close opend file
		fo.close()

		print out_Layer
