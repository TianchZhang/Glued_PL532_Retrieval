% Description:
% Rain case found in PL532 and Parsivel Data
% History:
%   2021.07.26 First Edition by  tc.zhang

PL_Stra_day_30 = {};
PL_Stra_detal_30 = {};
rain_flag = zeros(1,1440);
load('D:\DATA\Parsivel_temporary\Rainevents.mat','Stra_day_30','Stra_detal_30');
for num = 1:length(Stra_day_30)
    plname = strcat('D:\DATA\PLidar532\Parameter\',char(Stra_day_30(num)),'.h5');
    pvname = strcat('D:\DATA\OTTParsivel\nonQC2019-\',char(Stra_day_30(num)),'.h5');
    typeflag = h5read(pvname, 'typeflag');
    if isfile(plname)
        PL_Stra_day_30 = [PL_Stra_day_30;char(Stra_day_30(num))];
        detal = cell2mat(Rainev_detal(num));
        for rnum = 1:size(detal,1)
            Rainev_detal(detal(rnum,1):detal(rnum,2))
        end

    end
end
