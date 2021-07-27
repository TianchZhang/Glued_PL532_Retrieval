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
gainratio = 0.0749;

savefile = 'D:\DATA\PLidar532\Parameter\';
for yf = 1:2
    root_file = ['D:\DATA\PLidar532\',char(year_file(1,yf))];
    mon_list = dir(root_file);
    for df = 3:length(mon_list)
        day_list = dir(strcat(mon_list(df).folder,'\',mon_list(df).name,'\*.h5'));
        for datanum = 1:length(day_list)
            fname = [day_list(datanum).folder,'\',day_list(datanum).name];
            start = [1 1];
            count = [1440 5333];
%             temp = h5read(fname,'/range');
            CH1PC_Data = h5read(fname,'/CH1/gluedPC_Data', start, count).'...
                - repmat(h5read(fname,'/CH1/background'),5333,1);
            CH2PC_Data = h5read(fname,'/CH2/gluedPC_Data', start, count).'...
                - repmat(h5read(fname,'/CH1/background'), 5333, 1);
            h = repmat(h5read(fname,'/range', [1 1], [1 5333]).', 1, 1440);
            Mie = CH1PC_Data + CH2PC_Data .* gainratio;
            RCS = Mie .* h .^ 2;
            VDR = NaN(5333,1440);
            VDR(~isnan(CH2PC_Data) & ~isnan(CH1PC_Data)) = gainratio .* CH2PC_Data(~isnan(CH2PC_Data) & ~isnan(CH1PC_Data)) ./ CH1PC_Data(~isnan(CH2PC_Data) & ~isnan(CH1PC_Data));
            VDR(VDR <0) = 0;
            data_flag = ones(1,1440);
            data_flag(isnan(h5read(fname,'/CH1/background').'))=0;
            
            
            %% global attributes
            globalAttris.instrument = 'Polarization Lidar @532nm';
            globalAttris.location = 'Wuhan';
            globalAttris.institute = 'MUA';
            globalAttris.source = 'Operational measurements';
            %%
            savename = [savefile,day_list(datanum).name(28:end)];
            h5init(savename);
            
            gAttrs = fieldnames(globalAttris);
            for iField = 1:length(gAttrs)
                fn = gAttrs{iField};
                attr_item = globalAttris.(fn);
                attr_details.Name = fn;
                attr_details.AttachedTo = '/';
                attr_details.AttachType = 'group';
                
                hdf5write(savename, attr_details, attr_item, 'WriteMode', 'append');
            end
            h5create(savename,'/RCS',size(RCS));
            h5write(savename,'/RCS',RCS);
            h5create(savename,'/VDR',size(VDR));
            h5write(savename,'/VDR',VDR);
            h5create(savename,'/data_flag',size(data_flag));
            h5write(savename,'/data_flag',data_flag);
%             hdf5writedata(savename, '/RCS', RCS, ...
%                 'dataAttr', ...
%                 struct('Units', '', 'long_name', 'range Corrected Signal'));
%             hdf5writedata(savename, '/', VDR, ...
%                 'dataAttr', ...
%                 struct('Units', '', 'long_name', 'Volume Polarization Ratio'));
%             hdf5writedata(savename, '/', data_flag, ...
%                 'dataAttr', ...
%                 struct('Units', '', 'long_name', 'data recorded this minute'));
            
        end
        
    end
end