clc
clear
close all
format long g

% Start stopwatch timer
tic;

% Get files path
pathname = getAllFiles('D:\soilmositure\matlab\data');

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
[time, data] = SMAP_L4_SM_aup_GetPointData_from_Multifiles(pathname, 'Analysis_Data/sm_surface_analysis', 2966, 285);
csvwrite_with_headers('./test.csv', [exceltime(time), data], {'time' 'sm_surface_analysis'});

% Print elapsed time
toc;
