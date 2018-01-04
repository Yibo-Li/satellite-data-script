clc
clear
close all
format long g

% Start stopwatch timer
tic;

% Get files path
pathname = getAllFiles('D:\soilmositure\smap-scripts\data');

% Filter files which extend is h5
pathname_filter = zeros(length(pathname), 1);
for ii = 1:length(pathname)
    [pathstr, name, ext] = fileparts(cell2mat(pathname(ii)));
    if strcmp(ext, '.h5')
        pathname_filter(ii) = 1;
    end
end
pathname = pathname(pathname_filter == 1);

% Get Data from SMAP and write to csv file
dataFieldName = {'Observations_Data/tb_h_obs' ...
    'Observations_Data/tb_v_obs' ...
    'Analysis_Data/sm_profile_analysis' ...
    'Analysis_Data/sm_rootzone_analysis' ...
    'Analysis_Data/sm_surface_analysis' ...
    'Analysis_Data/soil_temp_layer1_analysis' ...
    'Analysis_Data/surface_temp_analysis'};

data = zeros(length(pathname), length(dataFieldName));
time = NaT(length(pathname), 1);
for ii = 1 : length(pathname)
    [time(ii, 1), data(ii, :)] = SMAP_L4_SM_aup_GetPointData(char(pathname(ii)), ...
        dataFieldName, 40.33333, 97.016667, 286, 2968);
end

% Write data to csv file with UTC+8 time
csvwrite_with_headers('./result/shulehe.csv', [exceltime(time) + 8 / 24, data], ...
    ['time' dataFieldName]);

% Print elapsed time
toc;
