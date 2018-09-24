
%This is a very simple plot of the Radiosounding.

%The plot is stored in the folder Plots/1_Raso_nolines/.
dirname='2_Raso_nolines';
mkdir(strxcat('Plots/',dirname)); 

if NoRasoNum ==0                   %only if a radiosounding exists at this day-
    
    figure(1)
    set(gcf,'units','normalized','position',[.5 .15 0.25 0.5]);

    plot(Raso.RHl,Raso.alt*1e-3,'LineWidth',1.5,'DisplayName','RelHum liquid');
    line(Raso.RHi,Raso.alt*1e-3,'LineWidth',1.5,'DisplayName','RelHum ice','Color',cm(2,:));
    ylim([0 hmax]);
    xlim([0 150]);
    ax1=gca;
    ylabel('Height in km','FontSize',10);
    xlabel('Rel Hum in %','FontSize',10);
    h=legend(ax1,'show','Location','northwest');
    set(h,'FontSize',10);
    set(gca,'FontSize',10)
    grid on;

    suptitle(strxcat('Raso beginn at ', datestr(Raso.N(1))),'FontSize',12);
    saveas(gcf,strxcat('Plots/',dirname,'/',datestr(Raso.N(1),'yyyy-mm-dd'),'_Raso.png')); 

    clear h ax1

end
