function [time, data] = SMAP_L4_SM_aup_GetPointData_from_Multifiles(inFileNameArray, dataFieldName, row, column)
%SMAP_L4_SM_AUP_GETPOINTDATA_FROM_MULTIFILES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

for ii = 1 : length(inFileNameArray)
    [time(ii), data(ii)] = SMAP_L4_SM_aup_GetPointData(char(inFileNameArray(ii)), dataFieldName, row, column);
end

time = time';
data = data';

% End of this function
end
