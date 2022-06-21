% Description:
% Calculate cloud base height in PL532 data
% History:
%   2022.06.09 First Edition by  tc.zhang
%
clear
cd E:\DATA\PLidar532\h5_GluedData
listing = dir('**/*.h5');
savefile = 'E:\DATA\PLidar532\cloud_base\';
for ik = 1:length(listing)
    fname = listing(ik).name;
    
    data = PLidar_readdata('E:\DATA\PLidar532\h5_GluedData', ...
        [datenum(str2double(listing(ik).name(end-10:end-7)), ...
        str2double(listing(ik).name(end-6:end-5)), ...
        str2double(listing(ik).name(end-4:end-3)),...
        0,0,0), ...
        datenum(str2double(listing(ik).name(end-10:end-7)), ...
        str2double(listing(ik).name(end-6:end-5)), ...
        str2double(listing(ik).name(end-4:end-3)),...
        23,59,59)], ...
        [300, 20000]);
    elSig = (data.CH1_PC + 0.0829.* data.CH2_PC);
    elBG = (data.CH1_BG + 0.0829.* data.CH2_BG);
    RCS = elSig .* repmat(data.height', 1, length(data.time)).^2;
    RCB = elBG .* repmat(data.height', 1, length(data.time)).^2;
    VDR = 0.0829 .* data.CH2_PC ./ data.CH1_PC;
    SNR = PLidar_SNR(elSig,elBG);
    cloudbase = nan(1440,1);
    kloc = find(data.records > 0);
    
    for iloc = 1:length(kloc)
        temp = smooth(RCS(:,kloc(iloc)),9);
        diftemp = smooth(diff(temp)./(3.75 * 9));
        tempr = RCB(:,kloc(iloc));
        diftempr = diff(tempr)./(3.75 * 9);
        tdif = fix(diftemp*10 ./ max(diftemp));
        ttdif  = diff(tdif);
        hrange = data.height(1:size(elSig,1));
        cloudloc = find(ttdif > 1,1);
        if ~isempty(cloudloc)
            if cloudloc > 60
                if SNR(cloudloc,kloc(iloc)) > 3
                    cloudbase(kloc(iloc)) = data.height(cloudloc-2);
                end
            end
        end
    end
    %                 figure
    %                 subplot(2,2,1)
    %                 plot(temp,hrange)
    %                 subplot(2,2,2)
    %                 plot([0;tdif],hrange,'r')
    %                 subplot(2,2,3)
    %                 plot([0;0;diff(tdif)],hrange)
    
    cloc = find(~isnan(cloudbase));
    for ii = 2:length(cloc)-1
        if ~isnan(cloudbase(cloc(ii)-1)) &&...
                ~isnan(cloudbase(cloc(ii)+1)) &&...
                abs(cloudbase(cloc(ii)-1) - cloudbase(cloc(ii))) > 500 &&...
                abs(cloudbase(cloc(ii)+1) - cloudbase(cloc(ii))) >500
            cloudbase(cloc(ii)) = nan;
        end
    end
    savename = [savefile,listing(ik).name(end-10:end-3),'.h5'];
    h5init(savename);
    hdf5writedata(savename, '/cloudbase', cloudbase, ...
        'dataAttr', ...
        struct('Units', ''));
    hdf5writedata(savename, '/RCS', RCS, ...
        'dataAttr', ...
        struct('Units', ''));
    hdf5writedata(savename, '/RCB', RCB, ...
        'dataAttr', ...
        struct('Units', ''));
    hdf5writedata(savename, '/SNR', SNR, ...
        'dataAttr', ...
        struct('Units', ''));
    hdf5writedata(savename, '/VDR', VDR, ...
        'dataAttr', ...
        struct('Units', ''));
%     figure
%     plot(1:1440,cloudbase,'.');
end