load('D:\DATA\Parsivel_temporary\Rainevents-allR-3-30','Rainev_day');
load('D:\DATA\Parsivel_temporary\Rainevents-allR-3-30','Rainev_detal');


Plidarfile = 'E:\DATA\PLidar532\cloud_base\';
rainfile = 'E:\DATA\OTTParsivel\nonQC2019-\';
cloudbase = [];
RR = [];
Dm = [];
Nw = [];
cloudbaseC = [];
RRC = [];
DmC = [];
NwC = [];
cloudbaseS = [];
RRS = [];
DmS = [];
NwS = [];
for ifile = 1:length(Rainev_day)
    filename = [Rainev_day{ifile,1},'.h5'];
    if exist([Plidarfile,filename],'file')
        cldbs = h5read([Plidarfile,filename],'/cloudbase');
        RRtemp = h5read([rainfile,filename],'/RR');
        Dmtemp = h5read([rainfile,filename],'/Dm');
        Nwtemp = h5read([rainfile,filename],'/Nw');
        rainflag = h5read([rainfile,filename],'/rainflag');
        typeflag = h5read([rainfile,filename],'/typeflag');
        tempdt = Rainev_detal{ifile,1};
        for iday = 1:size(tempdt,1)
            rkey = intersect(find(rainflag > 0 & ~isnan(cldbs)),tempdt(iday,1):tempdt(iday,2));
            ckey = intersect(find(typeflag ==1 & ~isnan(cldbs)),tempdt(iday,1):tempdt(iday,2));
            skey = intersect(find(typeflag ==2 & ~isnan(cldbs)),tempdt(iday,1):tempdt(iday,2));
           cloudbase = [cloudbase;cldbs(rkey)];
            RR = [RR;RRtemp(rkey)];
            Dm = [Dm;Dmtemp(rkey)];
            Nw = [Nw;Nwtemp(rkey)];
            cloudbaseC = [cloudbaseC;cldbs(ckey)];
            RRC = [RRC;RRtemp(ckey)];
            DmC = [DmC;Dmtemp(ckey)];
            NwC = [NwC;Nwtemp(ckey)];
            cloudbaseS = [cloudbaseS;cldbs(skey)];
            RRS = [RRS;RRtemp(skey)];
            DmS = [DmS;Dmtemp(skey)];
            NwS = [NwS;Nwtemp(skey)];
        end
        
    end
end