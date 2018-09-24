
%This file makes a raso plot. If there are different cloud layers, then there are lines indicating these
%layers (note that these lines are modified later). 

if NoRasoNum==0                                %only if a raso exists  

mkdir('Plots','4_Raso_lines');                 %create folder for plots 

if numcloud_i>=2                               %if min 2 cloud layers exists
   
for k=1:layers

    %for limiting height where we look for multi-layer clouds:
    x = Raso.alt;
    valueToMatch = MLC_classification(i).fallbeginn(k);
    % Find the closest value.
    [~, indexAtTopNoCloud(k)] = min(abs(x - valueToMatch));

    %for limiting height where we look for multi-layer clouds:
    x = Raso.alt;
    valueToMatch = MLC_classification(i).fallend(k);
    % Find the closest value.
    [minDifferenceValue, indexAtBottomNoCloud(k)] = min(abs(x - valueToMatch));

end

%%

%Plot Raso:

figure(1)
set(gcf,'units','normalized','position',[.5 .15 0.25 0.5]);
%set(gcf,'Visible','off','units','normalized','position',[.5 .15 0.25 0.5]);

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

%Plot lines in Plot_nur Reflectivity:
for k=1:layers

    mu=Raso.alt(indexAtTopNoCloud(k))*1e-3;
    hline = refline([0 mu]);
    hline.Color = 'r';

    mu=Raso.alt(indexAtBottomNoCloud(k))*1e-3;
    hline = refline([0 mu]);
    hline.Color = 'r';

end

suptitle(strxcat('Raso beginn at ', datestr(Raso.N(1))),'FontSize',12);
saveas(gcf,strxcat('Plots/2_Raso_lines/',datestr(Raso.N(1),'yyyy-mm-dd'),'_Raso.png')); 
%close(gcf)

clear h ax1 hline indexAtBottomNoCloud indexAtTopNoCloud mu x minDifferenceValue valueToMatch

elseif numcloud_i ==1 || numcloud_i==0                 %if no cloud layer exists
%Make plot without lines

figure(1)
set(gcf,'units','normalized','position',[.5 .15 0.25 0.5]);
%set(gcf,'Visible','off','units','normalized','position',[.5 .15 0.25 0.5]);

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
saveas(gcf,strxcat('Plots/2_Raso_lines/',datestr(Raso.N(1),'yyyy-mm-dd'),'_Raso.png')); 
%close(gcf)

clear h ax1 hline indexAtBottomNoCloud indexAtTopNoCloud mu x minDifferenceValue valueToMatch  
    
end
end

