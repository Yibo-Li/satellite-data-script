function SMAP_L4_SM_aup_GetMultiData(filePathName, dataFieldName, row, column, resultFilePathName)
% Drop data from SMAP L4 AUP files to a csv file
% Parameters:
%   filePathName - string of the path of SMAP files
%   dataFieldName - array of data fields which are accessed
%   row, column - integer of point locations in SMAP grid
%   resultFilePathName - string of the reult file formed in csv
% Return:
%   none

% Developed by 'Yibo Li'<gansuliyibo@126.com>
% Tested on MATLAB 2017b
% Lasted updated on 2018-1-10 

% Parallel Computing Environment
% 设定机器CPU核心数目，参考 https://stackoverflow.com/a/8322342
CoreNum = feature('numcores');

% 判断并行计算环境是否已经启动
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    % 如果尚未启动，则启动并行环境，设置worker数目
    parpool(CoreNum);
else
    disp('Already initialized the parallel environment');
end

format long g

% Start stopwatch timer
tic;

% Get files path
pathname = getAllFiles(filePathName);

% Filter files which extend is h5
pathname_filter = zeros(length(pathname), 1);
parfor ii = 1:length(pathname)
    [pathstr, name, ext] = fileparts(cell2mat(pathname(ii)));
    if strcmp(ext, '.h5')
        pathname_filter(ii) = 1;
    end
end
pathname = pathname(pathname_filter == 1);

data = zeros(length(pathname), length(dataFieldName));
time = NaT(length(pathname), 1);
parfor ii = 1 : length(pathname)
    [time(ii, 1), data(ii, :)] = SMAP_L4_SM_aup_GetPointData(char(pathname(ii)), ...
        dataFieldName, row, column);
end

% Write data to csv file with UTC+8 time
csvwrite_with_headers(resultFilePathName, [exceltime(time) + 8 / 24, data], ...
    ['time' dataFieldName]);

% Print elapsed time
toc;

% End parallel environment
delete(gcp('nocreate'));

end
