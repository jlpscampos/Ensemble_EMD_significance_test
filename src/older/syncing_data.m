function [odata1, mon_insolation, time] = syncing_data(time1, data1, timeins, datains)

    ts1 = timeseries(data1(~isnan(data1)),time1(~isnan(data1)));

    mon_insolation = [];
    for i = 1:size(datains,2)
        ts2 = timeseries(datains(:,i),timeins);
        ts2 = resample(ts2,ts1.time);
        mon_insolation = cat(2,mon_insolation,ts2.data);
    end
    
    odata1 = ts1.data; 
    time = ts1.time;
end