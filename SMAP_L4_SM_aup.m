function SMAP_L4_SM_aup(fileName)
% SMAP_L4_SM_aup(fileName)  To access and visualize SMAP_L4_SM_aup file in MATLAB
%
% Development by "Yibo Li"<gansuliyibo@126.com>
% Based on HDF-EOS Tools and Information Center(http://hdfeos.org/zoo/index_openNSIDC_Examples.php#SMAP)
%
% Tested under: MATLAB R2010b
% Last updated: 2016-3-6

% Open the HDF5 File.
FILE_NAME = fileName;
file_id = H5F.open (FILE_NAME, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

% Open the group/dataset.
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

% Create a set of level ranges to be used in converting the data to a
% geolocated image that has a color assigned to each range.
levels = linspace(valid_min, valid_max, 10);

% Create a color map.
cmap = jet(length(levels) + 1);

% Set the first entry of colormap as white, which will be used for
% fill value.
cmap(1, :,:) = [1 1 1];

% Convert the data to an geolcated image by setting a color for each level
% range.
Z = data;

% Clamp the min and max values to the level index.
Z(Z < levels(1)) = 1;
Z(Z > levels(end)) = length(levels);

% Assign Z as an indexed image with the index value corresponding to the
% level range.
for k = 1:length(levels) - 1
    Z(data >= levels(k) & data < levels(k+1)) = double(k) ;
end


% Plot the data.
min_data=min(min(data));
max_data=max(max(data));

f = figure('Name', FILE_NAME, ...
    'Renderer', 'zbuffer', ...
    'Position', [0,0,800,600], ...
    'Visible', 'off', ...
    'PaperPositionMode', 'auto', ...
    'Colormap', jet(2048));


latlim=[floor(min(min(lat))),ceil(max(max(lat)))];
lonlim=[floor(min(min(lon))),ceil(max(max(lon)))];

axesm('MapProjection','eqdcylin','Frame','on','Grid','on', ...
      'MeridianLabel','on','ParallelLabel','on','MLabelParallel','south')
tightmap
colormap(cmap)
% Note: surfm won't work for SMAP grid.
% surfm(lat, lon, data)
geoshow(lat,lon, uint8(Z), cmap, 'd', 'image');

landareas = shaperead('landareas.shp', 'UseGeo', true);
coast.lat = [landareas.Lat];
coast.long = [landareas.Lon];
geoshow(coast.lat, coast.long, 'Color', 'k')

caxis auto
clevels =  cellstr(num2str(levels'));
clevels = ['missing'; clevels]';

h = lcolorbar(clevels, 'Location', 'horizontal');
unit = sprintf('%s', units);
set(get(h, 'title'), 'string', unit, ...
    'Interpreter', 'none', ...
    'FontSize', 16, 'FontWeight','bold');


% An HDF5 string attribute is an array of characters.
% Without the following conversion, the characters in unit will appear 
% in a veritcal direction.
name = sprintf('%s', long_name);
plotm(coast.lat,coast.long,'k');

title({FILE_NAME; name}, ... 
      'Interpreter', 'None', 'FontSize', 16,'FontWeight','bold');
saveas(f, [FILE_NAME '.m.png']);
