function [time, data] = SMAP_L4_SM_aup_GetPointData_from_Multifiles(inFileNameArray, dataFieldName, latitude, longtitude)
% Get point data from multi-files invoking SMAP_L4_SM_aup_GetPointData function

% Developed by 'Yibo Li' <gansuliyibo@126.com>
% Tested under: MATLAB R2015b
% Last updated: 2018-1-4

data = zeros(length(inFileNameArray), length(dataFieldName));
for ii = 1 : length(inFileNameArray)
    [time(ii), data(ii, :)] = SMAP_L4_SM_aup_GetPointData(char(inFileNameArray(ii)), dataFieldName, latitude, longtitude);
end

time = time';

% End of this function
end
