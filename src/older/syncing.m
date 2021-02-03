function [otime, odata] = syncing(itime, idata, res)

    otime = 0:res:10000;
    
    d_itime = diff(itime,1);
    ind = 1:length(d_itime)+1;
    
    if ~isempty(ind(d_itime>50))
        x = cat(1,1,ind(d_itime>50)',ind(end));
    else
        x = cat(1,1,ind(end));
    end
    
    for i = 1:length(x)-1
        if i == 1
            data{i} = idata(x(i):x(i+1));
            tim{i} = itime(x(i):x(i+1));
        else
            data{i} = idata(x(i)+1:x(i+1));
            tim{i} = itime(x(i)+1:x(i+1));
        end
    end
    
    otim = []; odat = [];
    for i = 1:length(data)
        if length(data{i})>3
            t = otime(otime >= min(tim{i}) & otime<= max(tim{i}));
            ts = timeseries(data{i}, tim{i});
            
            if ~isempty(t)
                ts = resample(ts,t);

                otim = cat(1,otim,ts.time);
                odat = cat(1,odat,ts.data);
            end
        end
    end
    
    yind = 1:length(otime);
    
    y =[];
    for i = 1:length(otim)
        y = cat(1,y,yind(otime==otim(i)));
    end

    odata = NaN(1,length(otime));
    odata(y) = odat;
    
    odata = odata'; otime = otime';
    
end