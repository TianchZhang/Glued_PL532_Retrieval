%MUA_PLidar532 Parameters calculating  from licel-glued PLidar Data
% Functionality:
%   -  batch processing
%   -  calculating of parameters
%       Range corrected signal
%       Volume depolarization ratio
%
% History:
%   2021.07.22 First Edition by  tc.zhang


year_file = ["2019","2020"];
gainratio = 0.0829;
for yf = 1:2
    root_file = ['D:\DATA\PLidar532\',year_file(yf)];
    mon_list = dir(root_file);
    for df = 3:length(mon_list)
        day_list = dir([mon_list(df).folder,'\',mon_list(df).name,'\*.h5']);
        for datanum = 1:length(day_list)
            fname = [day_list(datanum).folder,day_list(datanum).name];
            start = [1 1];
            count = [5333 1440];
            CH1PC_Data = h5read(fname,'/CH1/gluedPC_Data', start, count)...
                - repmat(h5read(fname,'/CH1/background').', 5333, 1);
            CH2PC_Data = h5read(fname,'/CH2/gluedPC_Data', start, count)...
                - repmat(h5read(fname,'/CH1/background').', 5333, 1);
            h = repmat(h5read(fname,'/range', [1 1], [5333 1]), 1440,1);
            Mie = CH1PC_Data + CH2PC_Data .* gainratio;
            RCS = Mie .* h .^ 2;
            VDR = (CH2PC_Data .* gainratio) ./ CH1PC_Data;
            data_flag = ones(1,1440);
            data_flag(isnan(h5read(fname,'/CH1/background').'))=0;
            
        end
        
    end
end