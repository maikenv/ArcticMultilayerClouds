
%This program creates plots of the sublimation calculation (the plots are not used/maintained further)
%The layer numbers are here (starting at the bottom) the opposite from those in the paper (starting at the top).

mkdir('Plots','3_Sublimation');                                     %in this folder are the plots saved.

kmax=MLC_classification(i).nocloud_layers;

kvec=[1:kmax];
layervec=fliplr(kvec);

for k=1:kmax                %k number starts counting from bottom 
%k=1;

    kchose=layervec(k);     %to get the layer number counting from top

    figure(k);
    set(gcf,'units','normalized','position',[.5 .5 0.5 0.5]);

    ax1=subplot(2,2,1);
    semilogy(Sublimation(k).time_min,Sublimation(k).mass,'Color',cm(1,:),'DisplayName',strxcat('r=',Rsize,'\mum'),'LineWidth',1.5);
    hold on;
    xlim([0 maxtime(k)]);
    ylabel('Mass of particle in kg');
    xlabel('Time in min');
    legend(ax1,'show','Location','northeast');
    grid on;

    ax2=subplot(2,2,2);
    plot(Sublimation(k).time_min,Sublimation(k).radius*1e6,'Color',cm(1,:),'DisplayName',strxcat('r=',Rsize,'\mum'),'LineWidth',1.5)
    hold on;
    xlim([0 maxtime(k)]);
    ylabel('Radius in \mum');
    xlabel('Time in min');
    legend(ax2,'show','Location','northeast');
    grid on;

    ax3=subplot(2,2,3);
    plot(Sublimation(k).time_min(2:end),Sublimation(k).speed(2:end),'Color',cm(1,:),'DisplayName',strxcat('r=',Rsize,'\mum'),'LineWidth',1.5)
    hold on;
    xlim([0 maxtime(k)]);
    ylabel('Fallspeed in m/s');
    xlabel('Time in min');
    legend(ax3,'show','Location','northeast');
    grid on;

    ax4=subplot(2,2,4);
    plot(Sublimation(k).time_min,Sublimation(k).height*1e-3,'Color',cm(1,:),'DisplayName',strxcat('r=',Rsize,'\mum'),'LineWidth',1.5)
    hold on;
    xlim([0 maxtime(k)]);
    ylim([0 Sublimation(k).initial_cond(4)*1e-3]);
    %ylim([0 1.5]);
    ylabel('Height in km (0=groud)');
    xlabel('Time in min');
    yticks(0:0.2:10);
    legend(ax4,'show','Location','northeast');
    grid on;

    suptitle(strxcat('Layer ',kchose,': Sublimation of a round ice crystal of the radius ',Sublimation(k).initial_cond(5),' mikro m at ',Sublimation(k).initial_cond(3),'hPa, ',Sublimation(k).initial_cond(2)-273.15,'°C and ',Sublimation(k).initial_cond(1),'% RHi'), 'FontSize',8);
    saveas(gcf,strxcat('Plots/2_Sublimation/',datestr(Raso.N(1),'yyyy-mm-dd'),'_Sublimation_layer',kchose,'.png'));

end

%%

clear kmax ax1 ax2 ax3 ax4 

%%
