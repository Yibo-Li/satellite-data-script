function SMAP_L4_SM_aup_to_csv(inFileName, outFileName)
% SMAP_L4_SM_aup_to_csv(inFileName, outFileName)  To access and visualize SMAP_L4 in MATLAB
%
% Developed by "Yibo Li"<gansuliyibo@126.com>
% Based on HDF-EOS Tools and Information Center(http://hdfeos.org/zoo/index_openNSIDC_Examples.php#SMAP)
%
% Tested under: MATLAB R2015b
% Last updated: 2016-4-30

% Open the HDF5 File.
FILE_NAME = inFileName;
file_id = H5F.open (FILE_NAME, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

% Open the group/dataset.
% DATAFIELD_NAME = 'Observations_Data/tb_h_obs';
% DATAFIELD_NAME = 'Observations_Data/tb_v_obs';
% DATAFIELD_NAME = 'Forecast_Data/sm_rootzone_forecast';
% DATAFIELD_NAME = 'Analysis_Data/sm_surface_analysis';
% DATAFIELD_NAME = 'Analysis_Data/surface_temp_analysis';
DATAFIELD_NAME = 'Analysis_Data/sm_rootzone_analysis';

data_id = H5D.open (file_id, DATAFIELD_NAME);

Lat_NAME='cell_lat';
lat_id=H5D.open(file_id, Lat_NAME);

Lon_NAME='cell_lon';
lon_id=H5D.open(file_id, Lon_NAME);

% Read the dataset.
data=H5D.read (data_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

lat=H5D.read(lat_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

lon=H5D.read(lon_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

% Read the fill value.
ATTRIBUTE = '_FillValue';
attr_id = H5A.open_name (data_id, ATTRIBUTE);
fillvalue=H5A.read (attr_id, 'H5T_NATIVE_DOUBLE');

% Read the units.
ATTRIBUTE = 'units';
attr_id = H5A.open_name (data_id, ATTRIBUTE);
units = H5A.read(attr_id, 'H5ML_DEFAULT');

% Read the valid_max.
ATTRIBUTE = 'valid_max';
attr_id = H5A.open_name (data_id, ATTRIBUTE);
valid_max = H5A.read(attr_id, 'H5ML_DEFAULT');

% Read the valid_min.
ATTRIBUTE = 'valid_min';
attr_id = H5A.open_name (data_id, ATTRIBUTE);
valid_min = H5A.read(attr_id, 'H5ML_DEFAULT');

% Read title attribute.
ATTRIBUTE = 'long_name';
attr_id = H5A.open_name (data_id, ATTRIBUTE);
long_name=H5A.read (attr_id, 'H5ML_DEFAULT');

% Close and release resources.
H5A.close (attr_id);
H5D.close (data_id);
H5F.close (file_id);

% Replace the fill value with NaN.
data(data==fillvalue) = NaN;

% get soil moisture 3-D array
sm = [lon(:) lat(:) data(:)];

% select data which lon is between 106.50 and 107.65
%               and lat is between 40.40 and 41.35
% hetao_sm = sm(sm(:,1)>106.5 & sm(:,1)<107.65 & sm(:,2)>40.40 & sm(:,2)<41.35, :);
hetao_sm = sm(sm(:,1)>106.15 & sm(:,1)<109.15 & sm(:,2)>40.05 & sm(:,2)<41.45, :);

% write cvs file
csvwrite_with_headers(outFileName, hetao_sm, {'lon' 'lat' 'l4_sm'});
