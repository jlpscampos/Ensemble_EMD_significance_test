function [imf, resid, ageBP, m, b] = MC_emd(datafile, timespan)

    res = 50; % years
    wbh = waitbar(0,'0%','Name','Performing Monte-Carlo EMD');
    for i = 1:1000
        %% Loading the data 
        loc = strcat('/data_joined/',num2str(i),'/');
        ageBP{i} = h5read(datafile,strcat(loc,'ageBP'));
        d18O{i}  = h5read(datafile,strcat(loc,'d18O'));
        
        %% Slicing the data
        x = dsearchn(ageBP{i},timespan');
        ageBP{i} = ageBP{i}(min(x):max(x));
        d18O{i}  = d18O{i}(min(x):max(x));
        
        %% Syincing the time series
        %[ageBP{i}, d18O{i}] = syncing(ageBP{i}, d18O{i}, res);
        
        %% Normalizing the time series
        [d18O{i}, m{i}, b{i}] = normalization(ageBP{i}, d18O{i});
        
        %% Empirical Mode Decomposition
        d18O{i} = d18O{i}(~isnan(d18O{i}));
        ageBP{i}= ageBP{i}(~isnan(d18O{i}));
        
        [im, r, ~] = emd(d18O{i},'Interpolation','spline','Display',0);
        
        for j = 1:size(im,2)
           [~, odata(:,j)] = syncing(ageBP{i}, im(:,j), res);
        end
        imf{i} = odata; clear odata im
        [ageBP{i},resid{i}] = syncing(ageBP{i},r,res);
        clear r
        
        waitbar(i/1000,wbh,strcat(num2str(i/1000*100),'%'));
    end
    close(wbh);
    
end

function [d18O, m, b] = normalization(time, data)

    ts1 = timeseries(data, time);
    [~,m,b] = regression([quantile(ts1.data(~isnan(ts1.data)),.25),quantile(ts1.data(~isnan(ts1.data)),.75)],[-1,1]);
    d18O = m*ts1.data+b;
    
end