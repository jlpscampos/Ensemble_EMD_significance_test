function plot_timeseries(emd_obj)
    %addpath(fullfile(pwd,'src','figs'),'-end');
    
    %% Maximum number of IMFs
    [n,idx,opt] = return_nemd(emd_obj);
    
    %%
    odir = fullfile(pwd,'tmp');
    if ~isfolder(odir)
        mkdir(odir)
    end
    %%
    letter = {'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)','(i)','(j)','(k)','(l)'};
    for i = 1:n+1
        ofile = fullfile(odir,strcat(num2str(i),'.png'));
        if i <= n
            ylab = strcat(letter{i},{' '},'IMF',{' '},num2str(i));
            [data] = return_data(emd_obj,idx,i);
            plot_data( emd_obj.time, data, ylab,opt(i), ofile);
        else
            ylab = strcat(letter{i},{' '},'Residual');
            [data] = return_data(emd_obj,idx,0);
            plot_data( emd_obj.time, data, ylab,opt(i), ofile);
        end
        clear data ylab ofile
    end
    
end

function plot_data(time, data, ylab, opt, ofile)
    addpath(fullfile('C:','Users','jlpsc','Documents','MATLAB','export_fig'));

    figure('Color','white','Position',[0 0 1000 400],'visible','off');
    
    c = parula(100); cc = randi([1,100]);
    
    mdata = nanmean(data,2);
    %lower = mdata-quantile(data,.25,2);
    %upper = quantile(data,.75,2)-mdata;
    sdata = nanstd(data,[],2);
    
    h = shadedErrorBar(time,mdata,sdata,...
        'lineprops',{'-k','color',c(cc,:),'Linewidth',2},'transparent',true,...
        'patchSaturation',.1);
    hold on
    plot(time,mdata,'color','black','linewidth',1);
    
    mn = min(mdata)-min(nanstd(data,[],2));
    mx = max(mdata)+max(nanstd(data,[],2));
    yy = linspace(mn,mx,7);
    
    for i = 1:length(yy)
        lbls{i} = num2str(yy(i),'%4.1f');
    end
    lbls{1} = '';lbls{end} = '';
    
    %xlimm = [min(time),max(time)];
    xlimm = [0,9000]; xtk = [0:1000:9000]; xtkl = [0:1:9];
    
    set(gca,'Xlim',xlimm,'XTick',xtk,'XTickLabel',xtkl,'Linewidth',2,...
        'fontsize',15,...
        'box','off','Ylim',[mn mx],'YTick',yy,'YTickLabel',lbls);
    ytickangle(90);
    ylabel(ylab,'fontsize',20,'Color','black');
    
    if opt == 1
        set(gca,'Xcolor','black','XaxisLocation','bottom','YaxisLocation',...
            'left');
        xtickangle(180)
        xlabel('time (ka BP)');
        
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
        xlabel('time (ka BP)');
    elseif opt == 5
        set(gca,'Xcolor','black','XaxisLocation','top','YaxisLocation',...
            'left');
        xlabel('time (ka BP)');
    end
    
    set(gcf, 'color', 'none');
    set(gca, 'color', 'none');
    %disp(ofile)
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
    for i = 1:nemd
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