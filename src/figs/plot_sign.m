function plot_sign(emd_obj, tit)

    %addpath(fullfile('src','colours'));
    figure('Color','white','Position',[0 0 600 600]);
     
    for j = 1:10
        mper{j} = []; mpsd{j} = [];
    end
    
    %% Plot EMD significance data
    c = parula(10);
    hd = 0;
    for i = 1:length(emd_obj.sign)
        for j = 1:length(emd_obj.sign{i}.mper)
            
            mper{j} = cat(1, mper{j}, emd_obj.sign{i}.mper(j));
            mpsd{j} = cat(1, mpsd{j}, emd_obj.sign{i}.mpsdx(j));
            
        end
        
        scatter(log(emd_obj.sign{i}.mper),log(emd_obj.sign{i}.mpsdx),...
            10,c(1:length(emd_obj.sign{i}.mpsdx),:),'filled',...
            'MarkerEdgeAlpha',0.3,'MarkerFaceAlpha',0.3);
        
        if hd==0; hold on; hd=1; end
        %if (i==1 && j==1); hold on; end
    end
    
    %% Plot significance levels
    n = size(emd_obj.imf{1},1);
    [x,y]  = return_levels(n);
    
    plot(x,[y(:,1) y(:,end)],'--','Color','red');
    hold on
    plot(x,[y(:,2) y(:,end-1)],'--','Color','blue');
    %text(8.5, -0.5,'99%','FontSize',15);
    %text(6, -8.5,'99%','FontSize',15);

    %text(8.5, -6,'95%','FontSize',15);
    %text(7, -7.5,'95%','FontSize',15);
    
    %% Plot mean and 1 sigma ray
    t = linspace(0, pi,100);
    %col = parula(10);
    for j = 1:length(mper)
        s1 = std(mper{j}); s2 = std(mpsd{j});
        m1 = mean(mper{j}); m2 = mean(mpsd{j});

        %x = m1+s1*cos(t);
        %y = m2+s2*sin(t);
        
        r = sqrt( (s1*s2)^2./((s2*cos(t)).^2+(s1*sin(t)).^2));
        x = m1-cat(2,r.*cos(t),flipud(-r.*cos(t)));
        y = m2-cat(2,r.*sin(t),flipud(-r.*sin(t)));
        
        plot(real(log(x)),real(log(y)),'-','color','black');

        text(log(m1),log(m2),num2str(j),'color','black','fontsize',12);
    end
    
    %% Labels & etc
    box on
    set(gca,'Xlim',[0 9],'Ylim',[-9 1],'XTick',[0:9],'XTickLabel',...
        [0:9],'fontsize',15);
    xlabel('log(Periodicity)'); ylabel('log(Energy)');
    t = title(tit,'FontSize',15);
    %t.HorizontalAlignment  = 'left';
    %t.Position = [0 t.Position(2) t.Position(3)];
    
end

function [x, y] = return_levels(n)
    %% Levels of significance
    %  n - data size - (integer)
    %  
    %  x - periodicity - (array)
    %  y - spectral density - (array)

    % Theoretical t-student statistics for 99% and 95%
    k = [-2.326, -0.675, 0, 0.675, 2.326];
    T = 0:10000;
    x = log(T);

    for i = 1:length(k)
        y(:,i) = -x + k(i)*sqrt(2/n)*exp(x/2);
    end
end