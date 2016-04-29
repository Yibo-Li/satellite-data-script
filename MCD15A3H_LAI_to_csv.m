function MCD15A3H_LAI_to_csv(inFileName, outFileName)
% MCD15A3H_LAI_to_csv(inFileName, outFileName) To access and visualize NSIDC MODIS Grid file in MATLAB
%
% Developed by "Yibo Li"<gansuliyibo@126.com>
% Based on the HDF-EOS Forum (http://hdfeos.org/forums)
%
% If you have any questions, suggestions, comments on this example,
% please use the HDF-EOS Forum (http://hdfeos.org/forums). 
%
% If you would like to see an  example of any other NASA
% HDF/HDF-EOS data product that is not listed in the HDF-EOS
% Comprehensive Examples page (http://hdfeos.org/zoo), 
% feel free to contact us at eoshelp@hdfgroup.org or post it at the 
% HDF-EOS Forum (http://hdfeos.org/forums).

% Define file name, grid name, and data field.
FILE_NAME=inFileName;
GRID_NAME='MOD_Grid_MOD15A2H';
DATAFIELD_NAME='Lai_500m';

% Open the HDF-EOS2 Grid file.
file_id = matlab.io.hdfeos.gd.open(FILE_NAME, 'rdonly');

% Read data from a data field.
grid_id = matlab.io.hdfeos.gd.attach(file_id, GRID_NAME);
[data, fail] = matlab.io.hdfeos.gd.readField(grid_id, DATAFIELD_NAME, [], [], []);

% Get information about the spatial extents of the grid.
[xdimsize, ydimsize, upleft, lowright] = matlab.io.hdfeos.gd.gridInfo(grid_id);

% Detach from the Grid object.
matlab.io.hdfeos.gd.detach(grid_id);

% Close the file.
matlab.io.hdfeos.gd.close(file_id);

% Convert the data to double type for plot.
data=double(data);
data(data>100 | data<0) = 0;

% We need to calculate the grid space interval between two adjacent points.
scaleX = (lowright(1)-upleft(1))/xdimsize;
scaleY = (lowright(2)-upleft(2))/ydimsize;

% By default HDFE_CENTER is assumed for the offset value, 
% which assigns 0.5 to both offsetX and offsetY.
offsetX = 0.5;
offsetY = 0.5;

% Since this grid is using geographic projection, 
% the latitude and longitude value will be calculated based on the formula:
% (i+offsetX)*scaleX+leftX  for longitude and 
% (i+offsetY)*scaleY+leftY for latitude.
for i = 0:(xdimsize-1)
    lon(i+1) = (i+offsetX)*(scaleX) + upleft(1);
end

for j = 0:(ydimsize-1)
    lat(j+1) = (j+offsetY)*(scaleY) + upleft(2);
end

[x, y] = meshgrid(lon, lat);
lai=[x(:) y(:) data(:)];
hetao_lai = lai(lai(:,1)>8957367.574 & lai(:,1)<9065543.407 & lai(:,2)>4498434.660 & lai(:,2)<4591309.307, :);

% write cvs file
% csvwrite_with_headers(outFileName, hetao_lai, {'lon' 'lat' 'lai'});
csvwrite_with_headers(outFileName, [data(242, 2220) data(308, 2243) data(220, 2166) data(241, 2185)], {'' '' '' ''});
