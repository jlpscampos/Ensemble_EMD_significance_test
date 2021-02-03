function X = loader_data(num, timespan, d)
   
    %file = 'joined_data/result_';
    data = [];
    for i = 2:13
        if i ~= 5
            file = 'joined_data/result_';
            datafile = strcat(file,num2str(i),'_joined.h5');
            loc = strcat('/data_joined/',num2str(num),'/');
            ageBP{1} = h5read(datafile,strcat(loc,'ageBP'));
            id18O{1} =  h5read(datafile,strcat(loc,'d18O'));
            
            [age, d18O] = d.resampler_ts(timespan(1), timespan(2), 10, ageBP, id18O);
            
            %[~,d18Odata] = syncing(ageBP, d18O, 10);
            crop = dsearchn(age',[min(timespan),max(timespan)]');
            odata(:,1) = d18O(min(crop):max(crop)); % Changed
            
            data = cat(2,data,odata);
        end
        clear odata
        clear d18O
    end
    X = data;

end