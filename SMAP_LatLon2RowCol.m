function [ row, col ] = SMAP_LatLon2RowCol( filename, latitude, longtitude )
% Translate latitude and longtitude to row and column in SMAP file, respectively.
% Parameters:
%   filename - SMAP file name
%   latitude, longtitude - float point format, unit is degree
% Return:
%   rom, col - int, start 1

% Developed by 'Yibo Li' <gansuliyibo@126.com>
% Tested under: MATLAB R2015b
% Last updated: 2018-1-4

% Open the HDF5 File.
file_id = H5F.open (filename, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

Lat_NAME='cell_lat';
lat_id=H5D.open(file_id, Lat_NAME);
Lon_NAME='cell_lon';
lon_id=H5D.open(file_id, Lon_NAME);

% Read the dataset.
lat_array=H5D.read(lat_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT')';
lon_array=H5D.read(lon_id,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT')';

% Calculate the nearest point location
distance = sqrt((lat_array - latitude).^2 + (lon_array - longtitude).^2);
[ row, col ] = find(distance == min(min(distance)));

% Close and release resources.
H5F.close (file_id);

end
