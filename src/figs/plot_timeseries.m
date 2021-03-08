function plot_timeseries(emd_obj)

    %% Maximum number of IMFs
    [n,idx,opt] = return_nemd(emd_obj);
    
    %%
    odir = fullfile(pwd,'tmp');
    if ~isfolder(odir)
        mkdir(odir)
    end
    %%
    letter = {'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)','(i)','(j)',...
        '(k)','(l)','(m)','(n)','(o)','(p)'};
    for i = 1:n+2
        ofile = fullfile(odir,strcat(num2str(i),'.png'));
        if i == 1
            ylab = strcat(letter{i},{' '},'Full data',{' '});
            [data] = emd_obj.data; %return_data(emd_obj,idx,i);
            plot_data( emd_obj.time, data, ylab, opt(i), ofile);
        elseif i > 1 && i < n+2 
            ylab = strcat(letter{i},{' '},'IMF',{' '},num2str(i-1));
            [data] = return_data(emd_obj,idx,i-1);
            plot_data( emd_obj.time, data, ylab, opt(i), ofile);
        elseif i == n+2 
            ylab = strcat(letter{i},{' '},'Residual');
            [data] = return_data(emd_obj,idx,0);
            plot_data( emd_obj.time, data, ylab, opt(i), ofile);
        end
        clear data ylab ofile
    end
    
end

function plot_data(time, data, ylab, opt, ofile)

    figure('Color','white','Position',[0 0 1000 400],'visible','off');
    
    c = parula(100); cc = randi([1,100]);
    
    mdata = nanmean(data,2);
    sdata = nanstd(data,[],2);
    
    if isdatetime(time(1))
        tim = 1:length(time);
    else
        tim = time;
    end
    
    h = shadedErrorBar(tim,mdata,sdata,...
        'lineprops',{'-k','color',c(cc,:),'Linewidth',2},'transparent',true,...
        'patchSaturation',.1);
    hold on
    plot(tim,mdata,'color','black','linewidth',1);
    
    mn = min(mdata)-min(nanstd(data,[],2));
    mx = max(mdata)+max(nanstd(data,[],2));
    yy = linspace(mn,mx,7);
    
    for i = 1:length(yy)
        lbls{i} = num2str(yy(i),'%4.1f');
    end
    lbls{1} = '';lbls{end} = '';
    
    if isdatetime(time(1))
        x = 1:length(time);
        xlimm = [min(x), max(x)];
        xtk = [min(x):(max(x)-min(x))/10:max(x)];
        
        for i = 1:length(xtk)
            xtkl{i} = datestr(time(xtk(i)),'mm/yyyy');
        end
        
    else
        xlimm = [min(time), max(time)];
        xtk = [min(time):(max(time)-min(time))/10:max(time)];
        xtkl = [min(time):(max(time)-min(time))/10:max(time)];
    end
    
    set(gca,'Xlim',xlimm,'XTick',xtk,'XTickLabel',xtkl,'Linewidth',2,...
        'fontsize',12,...
        'box','off','Ylim',[mn mx],'YTick',yy,'YTickLabel',lbls);
    ytickangle(90);
    ylabel(ylab,'fontsize',15,'Color','black');
    
    if opt == 1
        set(gca,'Xcolor','black','XaxisLocation','bottom','YaxisLocation',...
            'left');
        xtickangle(180)
        xlabel('time');
        
        xlh = get(gca,'xlabel');                                                      % Object Information
        xlp = get(xlh, 'Position');
        set(xlh, 'Rotation',180, 'Position',xlp, 'VerticalAlignment','middle')
        
    elseif opt == 2
        set(gca,'Xcolor','none','XaxisLocation','bottom','YaxisLocation',...
            'right');
    elseif opt == 3
        set(gca,'Xcolor','none','XaxisLocation','bottom','YaxisLocation',...
            'left');
    elseif opt == 4
        set(gca,'Xcolor','black','XaxisLocation','top','YaxisLocation',...
            'right');
        xlabel('time');
    elseif opt == 5
        set(gca,'Xcolor','black','XaxisLocation','top','YaxisLocation',...
            'left');
        xlabel('time');
    end
    
    set(gcf, 'color', 'none');
    set(gca, 'color', 'none');
    export_fig(gcf,ofile,'-dpng','-transparent','-nocrop','-r250');
    close all
    
end

function [data] = return_data(emd_obj,idx,comp)

    data = [];
    for i = 1:length(idx)
        if comp == 0
            data = cat(2,data,emd_obj.residual{idx(i)});
        else
            data = cat(2,data,emd_obj.imf{idx(i)}(:,comp));
        end
    end
    
end

function [nemd,idx,opt] = return_nemd(emd_obj)
    %% Mean number of IMFs
    % emd_obj - Ensemble EMD object 
    % 
    % nemd - more recurrent number of IMFs - (integer)
    % idx  - index to select more recurrents IMFs
    % opt  - opt index to be used in plotting the figures
    
    x = [];
    for i = 1:length(emd_obj.imf)
        x = cat(1,x,size(emd_obj.imf{i},2));
    end
    
    [countn,edges,nbins] = histcounts(x);
    bins = (edges(1:end-1)+edges(2:end))/2;
    
    nemd = bins(countn==max(countn));
    pos = find(bins==nemd);
    idx = find(nbins==pos);
    
    opt = [];
    for i = 1:nemd+1
        if mod(i,2) == 0
            opt = cat(1,opt,2);
        else
            opt = cat(1,opt,3);
        end
    end
    
    opt(1) = 1;
    
    if mod(length(opt)+1,2)==0
        opt = cat(1,opt,4);
    else
        opt = cat(1,opt,5);
    end
end