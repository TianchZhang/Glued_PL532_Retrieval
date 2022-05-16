
    for mon=1:12
        for da = 1:31
            if exist(['E:\DATA\PLidar532\Raw_Data\DATA','2019','\CH1\',num2str(mon,'%02d'),num2str(da,'%02d')],'dir')
                batch_licelGlue(datenum(2019,mon,da),'PLidar',false,'MUA_PLidar_Config.m');
            end
        end
    end

