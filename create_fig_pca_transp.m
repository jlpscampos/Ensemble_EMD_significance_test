function create_fig_pca_transp(age,d18osym, ofile, ystr, opt, prt )
    addpath(fullfile('C:','Users','jlpsc','Documents','MATLAB','colours'));
    addpath(fullfile('C:','Users','jlpsc','Documents','MATLAB','export_fig'));
    
    %% plotting data
    
    col = 'blue';
    d18o = mean(d18osym,2);
    plot_fig(age, d18osym, col);
    
    %%
    p = dsearchn(age,[0 3000]');
    mn = min(d18o(min(p):max(p)));
    mx = max(d18o(min(p):max(p)));
    
    yy = [(mn-.9)*10:5:(mx+.9)*10]*.1;
    if length(yy) > 7
        ytk = cat(2,yy(1)*10,round(linspace(yy(2)*10,yy(end-1)*10,5)),yy(end)*10)*.1;
    elseif length(yy) < 7
        yyy = linspace(yy(1)*10, (yy(end)+.2)*10,7)*.1;
        ytk = cat(2,yyy(1)*10,linspace(yyy(2)*10,yyy(end-1)*10,5),yyy(end)*10)*.1;
        clear yyy
    else
        ytk = yy;
    end
    
    for i = 1:length(ytk)
        if i == 1 || i == length(ytk)
            lbls{i} = '';
        else
            lbls{i} = num2str(ytk(i),'%.1f');
        end
    end
    
    
    %% Spec
    
    xl = 1000;
    if opt == 1
        set(gca,'XaxisLocation','Top','Xlim',[0 xl],...
            'Ylim',[min(ytk), max(ytk)],'Ytick',ytk,'YTickLabel',lbls,...
            'XTick',[0:100:xl],'XTickLabels',[0:.1:1],'Xgrid','off');
        xlabel('Age (ky BP)','FontSize',15);
    elseif opt == 2
        set(gca,'YaxisLocation','left','Xcolor','none',...
        'Xlim',[0 xl],'XTick',[0:100:xl],'XTickLabels',[0:.1:1],...
        'Ylim',[min(ytk), max(ytk)],'Ytick',ytk,'YTickLabel',lbls,...
        'Xgrid','off');
    elseif opt == 3
        set(gca,'YaxisLocation','right','Xcolor','none',...
        'Xlim',[0 xl],'XTick',[0:100:xl],'XTickLabels',[0:.1:1],...
        'Ylim',[min(ytk), max(ytk)],'Ytick',ytk,'YTickLabel',lbls,...
        'Xgrid','off');
    elseif opt == 4
        set(gca,'YaxisLocation','left','Xcolor','black','XaxisLocation',...
        'bottom','Xlim',[0 xl],'XTick',[0:100:xl],'XTickLabels',[0:.1:1],...
        'Ylim',[min(ytk), max(ytk)],'Ytick',ytk,'YTickLabel',lbls,'Xgrid','off');
        xlabel('Age (ky BP)','FontSize',15);
    elseif opt == 5
        set(gca,'YaxisLocation','right','Xcolor','black','XaxisLocation',...
        'bottom','Xlim',[0 xl],'XTick',[0:100:xl],'XTickLabels',[0:.1:1],...
        'Ylim',[min(ytk), max(ytk)],'Ytick',ytk,'YTickLabel',lbls,'Xgrid','off');
        xlabel('Age (ky BP)','FontSize',15);
    end
    ytickangle(90);
    ylabel(ystr);
    
    box off
    if strcmp(prt,'-print')
        set(gcf, 'color', 'none');
        set(gca, 'color', 'none');
        disp(ofile)
        export_fig(gcf,ofile,'-dpng','-transparent','-nocrop','-r250');
    end
end


function plot_fig(time, data, col)
    addpath source\plotters\
    figure('Position',[0 0 800 400],'Alphamap',.2);

    med = nanmean(data,2);
    error1 = abs(med-quantile(data,.75,2));
    error2 = abs(med-quantile(data,.25,2));
    
    s = shadedErrorBar(time,med,[error1,error2],'lineprops',...
        {'LineWidth',2,'Color','blue'},...
        'transparent',true,'patchSaturation',.1);
    hold on
    
    plot(time, med,'LineWidth',1,'Color','black');
    
    set(gca,'Xlim',[0 3]*1e3,'fontsize',15)
    box on
end
