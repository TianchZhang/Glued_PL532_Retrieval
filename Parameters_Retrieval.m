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
    
end