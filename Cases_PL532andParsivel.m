% Description:
% Rain case found in PL532 and Parsivel Data
% History:
%   2021.07.26 First Edition by  tc.zhang

load('D:\DATA\Parsivel_temporary\Rainevents_30.mat');
root_file = 'D:\DATA\PLidar532\Parameter\';
Case_day = {};
Case_detal = {};
for num = 1:1%length(Rainev_day)
    filename = strcat(root_file,char(Rainev_day(num)),'.h5');
    if isfile(filename)
        detal = cell2mat(Rainev_detal(num));
        for rnum = 1:size(detal,1)
            
            detal(rnum,1):detal(rnum,2))
        end

    end
end
