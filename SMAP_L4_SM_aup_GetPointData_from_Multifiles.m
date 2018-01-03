function [time, data] = SMAP_L4_SM_aup_GetPointData_from_Multifiles(inFileNameArray, dataFieldName, row, column)
%SMAP_L4_SM_AUP_GETPOINTDATA_FROM_MULTIFILES 此处显示有关此函数的摘要
%   此处显示详细说明

for ii = 1 : length(inFileNameArray)
    [time(ii), data(ii)] = SMAP_L4_SM_aup_GetPointData(char(inFileNameArray(ii)), dataFieldName, row, column);
end

time = time';
data = data';

% End of this function
end
