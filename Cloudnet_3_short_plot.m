
mkdir('Plots','6_Cloudnet_short');                 %create folder for plots 

if NoCloudnetNum==0                        %Only if Cloudnetfile exists
  if sizeZ(2)>1                             %Only if there are Z values at right time (need for i=34)
    
reso=20;                        %Plot-Color-Resolution

%%
%Plot:
[yy mm dd]=datevec(Cloudnet_short.N(1));

figure(11)
%set(gcf,'Visible','off','units','normalized','position',[.3 .15 0.3 0.6]);
set(gcf,'units','normalized','OuterPosition',[0.3 0.15 0.3 0.6]);
%set(gcf,'units','normalized','position',[.3 .15 0.3 0.6]);

a(1)=subplot(4,1,1);
contourf(Cloudnet_short.N,Cloudnet_short.height*1e-3,Cloudnet_short.Z,reso,'LineColor','none');
c= colorbar('location','eastoutside');
pos1 = get(a(1),'Position');
c.Label.String = 'Z in dBZ';
caxis([-40 20]);
hold on;
if NoRasoNum==0
    h(1)=line(Raso.N,Raso.alt*1e-3,'Color',cm(2,:),'DisplayName',strxcat('Raso'),'LineWidth',3.0);
    hold on;
end
ylabel('Height in km','FontSize',10);
ylim([0.2228 hmax]);
xlim([datenum(yy,mm,dd,timeStart,0,0) datenum(yy,mm,dd,timeEnd,0,0)]);
datetick('x',15,'keeplimits');
%set(gca, 'XTick', []);
if NoRasoNum==0
    h1=legend(h(1),'Raso','Location','northeast');
    set(h1,'FontSize',10);
end
set(gca,'FontSize',10)
title(strxcat('Radar Reflectivityfactor Z'),'FontSize',10);
 
%%
a(2)=subplot(4,1,2);
contourf(Cloudnet_short.N,Cloudnet_short.height*1e-3,log(Cloudnet_short.beta),reso,'LineColor','none');
cbar1 = colorbar('location','eastoutside');
pos2 = get(a(2),'Position');
set(cbar1,'YTick', log([1e-7,1e-6 ,1e-5 ,1e-4, 1e-3])); % Einteilung der Skala
set(cbar1,'YTickLabel', {'1e-7','1e-6','1e-5','1e-4','1e-3'}); % Beschriftung der Skala  
hold on;
cbar1.Label.String = '\beta in m^{-1} sr^{-1}';
caxis([log(1e-7) log(0.0001)]);
hold on;
if NoRasoNum==0
    h(1)=line(Raso.N,Raso.alt*1e-3,'Color',cm(2,:),'DisplayName',strxcat('Raso'),'LineWidth',3.0);
    hold on;
end
ylabel('Height in km','FontSize',20);
ylim([0.2228 hmax]);
xlim([datenum(yy,mm,dd,timeStart,0,0) datenum(yy,mm,dd,timeEnd,0,0)]);
datetick('x',15,'keeplimits');
%set(gca, 'XTick', []);
%legend(h(1),'Raso','Location','northeast');
%set(h1,'FontSize',10);
set(gca,'FontSize',10);
title(strxcat('Lidar Attenuated backscatter coefficient'),'FontSize',10);

%%
a(3)=subplot(4,1,3);
contourf(Cloudnet_short.N,Cloudnet_short.height*1e-3,Cloudnet_short.v,reso,'LineColor','none');
colormap(parula(20));
cbar2= colorbar('location','eastoutside');
pos3 = get(a(3),'Position');
set(cbar2,'YTick', ([-3, -2, -1, 0, 1 , 2])); % Einteilung der Skala
set(cbar2,'YTickLabel', {'-3 down', '-2','-1','0','1','2 up'}); % Beschriftung der Skala  
cbar2.Label.String = 'v in ms^{-1}';
caxis([-3 2]);
hold on;
if NoRasoNum==0
    h(1)=line(Raso.N,Raso.alt*1e-3,'Color',cm(2,:),'DisplayName',strxcat('Raso'),'LineWidth',3.0);
    hold on;
end
ylabel('Height in km','FontSize',20);
ylim([0.2228 hmax]);
xlim([datenum(yy,mm,dd,timeStart,0,0) datenum(yy,mm,dd,timeEnd,0,0)]);
datetick('x',15,'keeplimits');
%set(gca, 'XTick', []);
%legend(h(1),'Raso','Location','northeast');
%set(h1,'FontSize',10);
set(gca,'FontSize',10);
title('Doppler velocity','FontSize',10);

%%
a(4)=subplot(4,1,4);
contourf(Cloudnet_short.N,Cloudnet_short.height*1e-3,Cloudnet_short.width,reso,'LineColor','none');
c= colorbar('location','eastoutside');
pos4 = get(a(4),'Position');
c.Label.String = ({'width in ms^{-1}'});
caxis([0.03 1]);
hold on;
if NoRasoNum==0
    h(1)=line(Raso.N,Raso.alt*1e-3,'Color',cm(2,:),'DisplayName',strxcat('Raso'),'LineWidth',3.0);
    hold on;
end
ylabel('Height in km','FontSize',10);
ylim([0.2228 hmax]);
xlim([datenum(yy,mm,dd,timeStart,0,0) datenum(yy,mm,dd,timeEnd,0,0)]);
xlabel('Time in UTC','FontSize',10);
datetick('x',15,'keeplimits');
%legend(h(1),'Raso','Location','northeast');
%set(h1,'FontSize',10);
set(gca,'FontSize',10);
title('Doppler Spectral Width','FontSize',10);

%%
%Einheitliche Plotbreite:

set(a(1),'Position',pos1)
set(a(2),'Position',pos2)
set(a(3),'Position',pos3)
set(a(4),'Position',pos4)

xoffset = -0.06;
pos1(1) = pos1(1) + xoffset;
set(a(1), 'Position', pos1)
pos2(1) = pos2(1) + xoffset;
set(a(2), 'Position', pos2)
pos3(1) = pos3(1) + xoffset;
set(a(3), 'Position', pos3)
pos4(1) = pos4(1) + xoffset;
set(a(4), 'Position', pos4)


suptitle(strxcat(datestr(Cloudnet_short.N(1),'dd-mmm-yyyy')),'FontSize',15);
saveas(gcf,strxcat('Plots/6_Cloudnet_short/',datestr(Cloudnet_short.N(1),'yyyy-mm-dd'),'_Cloudnet.png')); 
%close(gcf);

clear ax c cbar1 cbar2 h h1 height pos pos1 pos2 pos3 pos4 xoffset 

  end                               %End of: only if there are Cloudnetvalues at right time.
end                                 %End of: only if Cloudnetfile exists

