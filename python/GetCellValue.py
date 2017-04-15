'''====================================
Get Cell Value
Usage: GetCellValue_management in_raster location_point {ID;ID...}
'''

try:
    import arcpy
    arcpy.env.workspace = "D:/BaiduNetdiskDownload/matlab/python/out"

    # Get the Band_1 cell value of certain point in a RGB image
    result = arcpy.GetCellValue_management(outVarRaster, "106.9344444 40.75144444", "1")
    g4 = int(result.getOutput(0))
    result = arcpy.GetCellValue_management(outVarRaster, "107.1401667 40.65580556", "1")
    g5 = int(result.getOutput(0))
    result = arcpy.GetCellValue_management(outVarRaster, "107.17375 40.97697222", "1")
    g7 = int(result.getOutput(0))
    result = arcpy.GetCellValue_management(outVarRaster, "107.1664722 40.89986111", "1")
    g8 = int(result.getOutput(0))

    # Open a file
	fo = open("foo.txt", "a")
	fo.write(g4,g5,g7,g8);

	# Close opend file
	fo.close()

except:
    print "Get Cell Value exsample failed."
    print arcpy.GetMessages()

