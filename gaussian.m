clc
clear

x = [1.1   5.2   1.2   1.5   1.5   0.7   1.0  16.1   2.7   0.3   1.0   2.1   7.6  12.4   4.2   2.5  11.9   4.0]';
y = x;

fid = fopen('e:/smap/outputData/gaussian.txt','wt');
for ii =  1 : 60
	t = awgn(x,10^-5);
	t(find(t < 0)) = 0.001;
	y = [y , t];
    fprintf(fid,'%g\n',t);       % \n »»ÐÐ
end
fclose(fid);
xlswrite('e:/smap/outputData/gaussian.xls',y);
