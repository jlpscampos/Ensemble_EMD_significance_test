function [imf, resid, ageBP, m, b] = MC_emd2(d, timespan, n)
    % years
    wbh = waitbar(0,'0%','Name','Performing Monte-Carlo EMD');
    for i = 1:1000
        %% Unpacking the data from dataframe 
        
        crop = dsearchn(d.age',[min(timespan),max(timespan)]');
        
        ageBP{i} = d.age(min(crop):max(crop));
        d18O{i}  = d.d18O(min(crop):max(crop),i);
        
        %% Filling gaps in the data
        
        X = loader_data(i, timespan, d);
        d18O{i} = recvar(X,n);
        
        %% Normalizing the time series
        [d18O{i}, m{i}, b{i}] = normalization(ageBP{i}, d18O{i});
        
        %% Empirical Mode Decomposition
        [imf{i}, resid{i}, ~] = emd(d18O{i},'Interpolation','pchip','MaxNumExtrema',1,'Display',0);
        
        waitbar(i/1000,wbh,strcat(num2str(i/1000*100),'%'));
    end
    close(wbh);
    
end

function [d18O, m, b] = normalization(time, data)

    %ts1 = timeseries(data, time);
    %[~,m,b] = regression([quantile(ts1.data(~isnan(ts1.data)),.25),quantile(ts1.data(~isnan(ts1.data)),.75)],[-1,1]);
    %d18O = m*ts1.data+b;
    m = nanstd(data); b = nanmean(data);
    d18O = (data-b)/m;

end