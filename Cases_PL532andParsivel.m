% Description:
% Rain case found in PL532 and Parsivel Data
% History:
%   2021.07.26 First Edition by  tc.zhang
clear
PL_Stra_day_30 = {};
PL_Stra_detal_30 = {};

load('D:\DATA\Parsivel_temporary\Rainevents.mat','Rainev_day_30');
load('D:\DATA\Parsivel_temporary\Rainevents.mat','Rainev_detal_30');
k =0;
for num = 1:length(Rainev_day_30)
    plname = strcat('D:\DATA\PLidar532\Parameter\',char(Rainev_day_30(num)),'.h5');
    if isfile(plname)
        data_flag = h5read(plname, '/data_flag');
        pvname = strcat('E:\DATA\OTTParsivel\nonQC2019-\',char(Rainev_day_30(num)),'.h5');
        typeflag = h5read(pvname, '/typeflag').';
        PL_Stra_day_30 = [PL_Stra_day_30;char(Rainev_day_30(num))];
        PL_Stra_detal_30 = [PL_Stra_detal_30;data_flag .* typeflag];
    end
end
save('D:\DATA\Parsivel_temporary\PL_Rainevents.mat','PL_Stra_day_30','PL_Stra_detal_30');
