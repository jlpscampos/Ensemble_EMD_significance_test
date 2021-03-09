function periodogram_emd(emd_obj)

    psd = [];
    for i = 1:length(emd_obj.sign)
        ps = [];
        for j = 1:10%length(emd_obj.sign{1}.psdx)
            ps = cat(2,ps,emd_obj.sign{i}.psdx(:,j));
        end
        psd = cat(3,psd,ps);
    end
    
    strr = {'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)','(i)',...
        '(j)','(k)','(l)','(m)','(n)','(o)','(p)','(q)'};
    
    freq = (emd_obj.sign{1}.freq);
    mpsd(:,:) = mean(psd,3)/1e4; spsd(:,:) = std(psd,[],3)/1e4;
    
    c = parula(10);
    for i = 1:10
       figure('Color','white','position',[0 0 600 500]);

       h = shadedErrorBar(freq(:,i),mpsd(:,i),spsd(:,i),...
        'lineprops',{'-k','color',c(i,:),'Linewidth',2},'transparent',true,...
        'patchSaturation',.1);
       hold on
       plot( freq(:,i),mpsd(:,i) ,'linewidth',1,'color','black');   
       set(gca,'Xlim',[10^-5 10^0],'Ylim',[0, max(mpsd(:,i)+spsd(:,i))], ...
           'Xscale','log');
       
       box on
       ylabel('Power (\sigma^2 \times 10^4)'); 
       xlabel('Freq (A.U.)');
       title(strcat(strr{i},{' '},'IMF',{' '},num2str(i)));
    
       ofile = fullfile('tmp',strcat(num2str(i),'_power.png'));
       saveas(gcf,ofile);
       close all
    end
   

end