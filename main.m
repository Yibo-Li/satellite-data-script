clc
clear
close all
format long e

% 输入文件路径
pathname = getAllFiles('../inputData/zhongqiInput');

for ii = 1:length(pathname)
    [PATHSTR,NAME,EXT] = fileparts(cell2mat(pathname(ii)));
	% 输入文件后缀名
    if strcmp(EXT, '.h5')
		% 文件操作函数 && 输出文件路径 && 输出文件后缀名
        SMAP_L4_SM_aup_to_csv([PATHSTR, '\', NAME,EXT], ['../outputData/zhongqiOutput/', NAME, '.csv'])
    end
end
