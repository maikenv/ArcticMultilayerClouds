
%This program creates a plot containing a) Radar reflectvity, b) Doppler velocity, c) Doppler spectral with, 
%d) Cloudnet classification

mkdir('Plots','5_Cloudnet');                 %create folder for plots 

if NoCloudnetNum==0                    %Only if Cloudnetfile exists
   
%Plot:
[yy mm dd]=datevec(Cloudnet.N(1));

figure(11)
%set(gcf,'Visible','off','units','normalized','position',[.5 .15 0.5 0.7]);
set(gcf,'units','normalized','position',[.5 .15 0.6 0.9]);

a(1)=subplot(4,1,1);
contourf(Cloudnet.N,Cloudnet.height*1e-3,Cloudnet.Z,20,'LineColor','none');
pos1 = get(a(1),'Position');
c= colorbar;
c.Label.String = 'Z in dBZ';
caxis([-40 20]);
hold on;
if NoRasoNum==0  
    h(1)=line(Raso.N,Raso.alt*1e-3,'Color',cm(2,:),'DisplayName',strxcat('Raso'),'LineWidth',3.0);
    hold on;
end
datetick('x','keeplimits');
ylabel('Height in km','FontSize',10);
ylim([0.2228 hmax]);
xlim([datenum(yy,mm,dd,0,0,0) datenum(yy,mm,dd+1,0,0,0)]);
if NoRasoNum==0
    h1=legend(h(1),'Radiosounding','Location','northeast');
    set(h1,'FontSize',10);
end
set(gca,'FontSize',10)
%set(gca, 'XTick', []);
title(strxcat('a) Radar Reflectivityfactor Z'),'FontSize',10);

pos = get(gca, 'Position');
xoffset = -0.07;
pos(1) = pos(1) + xoffset;
set(gca, 'Position', pos)

%%
a(2)=subplot(4,1,2);
contourf(Cloudnet.N,Cloudnet.height*1e-3,Cloudnet.v,20,'LineColor','none');
pos2 = get(a(2),'Position');
colormap(parula(20));
cbar2= colorbar;
set(cbar2,'YTick', ([-3, -2, -1, 0, 1 , 2])); % Einteilung der Skala
set(cbar2,'YTickLabel', {'-3 down', '-2','-1','0','1','2 up'}); % Beschriftung der Skala  
cbar2.Label.String = 'v in ms^{-1}';
caxis([-3 2]);
hold on;
if NoRasoNum==0  
    h(1)=line(Raso.N,Raso.alt*1e-3,'Color',cm(2,:),'DisplayName',strxcat('Raso'),'LineWidth',3.0);
    hold on;
end
datetick('x','keeplimits');
ylabel('Height in km','FontSize',20);
ylim([0.2228 hmax]);
xlim([datenum(yy,mm,dd,0,0,0) datenum(yy,mm,dd+1,0,0,0)]);
%legend(h(1),'Raso','Location','northeast');
%set(h1,'FontSize',10);
set(gca,'FontSize',10);
%set(gca, 'XTick', []);
title('b) Doppler velocity','FontSize',10);

pos = get(gca, 'Position');
xoffset = -0.07;
pos(1) = pos(1) + xoffset;
set(gca, 'Position', pos)

%%
a(3)=subplot(4,1,3);
contourf(Cloudnet.N,Cloudnet.height*1e-3,Cloudnet.width,20,'LineColor','none');
pos3 = get(a(3),'Position');
c= colorbar;
c.Label.String = ({'width in ms^{-1}'});
caxis([0.03 1]);
hold on;
if NoRasoNum==0
    h(1)=line(Raso.N,Raso.alt*1e-3,'Color',cm(2,:),'DisplayName',strxcat('Raso'),'LineWidth',3.0);
    hold on;
end
datetick('x','keeplimits');
ylabel('Height in km','FontSize',10);
ylim([0.2228 hmax]);
xlim([datenum(yy,mm,dd,0,0,0) datenum(yy,mm,dd+1,0,0,0)]);
xlabel('Time in UTC','FontSize',10);
%legend(h(1),'Raso','Location','northeast');
%set(h1,'FontSize',10);
set(gca,'FontSize',10);
title('c) Doppler Spectral Width','FontSize',10);

pos = get(gca, 'Position');
xoffset = -0.07;
pos(1) = pos(1) + xoffset;
set(gca, 'Position', pos)

%%

%colors:
cm1(1,:)=[1 1 1];                       %first color is white
cm1(2,:)=cm(6,:);                       
cm1(3,:)=colordg(3);                      
cm1(4,:)=colordg(1);                       
cm1(5,:)=colordg(29);                       
cm1(6,:)=[0 0.6667 0];  
cm1(7,:)=colordg(11);               
cm1(8,:)=colordg(17);                 
cm1(9,:)=[0.7500 0.7500 0.7500];         
cm1(10,:)=[0.5000 0.5000 0.5000];         
cm1(11,:)=[0.2500 0.2500 0.2500];         

CloudPhaselevels=[4:1:15];

%cheating:
Cloudnet.category2=Cloudnet.category;
Cloudnet.category2(Cloudnet.category2==6)=8;
Cloudnet.category2(Cloudnet.category2==7)=9;
Cloudnet.category2(Cloudnet.category2==20)=12;

%%
%For Temperature lines:

%Raso 1 day before:
i=i-1;
Raso_1_read
Rasom1=Raso;
%Raso 1 day after:
i=i+2;
Raso_1_read
Rasop1=Raso;
%Actual Raso:
i=i-1;
Raso_1_read

%Get equal length:
x = Raso.alt;
valueToMatch = hmax*1e3;
% Find the closest value.
[minDifferenceValue, indexAtMin] = min(abs(x - valueToMatch));

%Put all in one Vector:
Time(1,:)=Rasom1.N(1:indexAtMin);
Time(2,:)=Raso.N(1:indexAtMin);
Time(3,:)=Rasop1.N(1:indexAtMin);

Alt(1,:)=Rasom1.alt(1:indexAtMin);
Alt(2,:)=Raso.alt(1:indexAtMin);
Alt(3,:)=Rasop1.alt(1:indexAtMin);

Temp(1,:)=Rasom1.tempK(1:indexAtMin);
Temp(2,:)=Raso.tempK(1:indexAtMin);
Temp(3,:)=Rasop1.tempK(1:indexAtMin);

%Put it in contour form.
%includes three Radiosoundings
%Problem: all refers to starttime at ground. Does not include timedelay hihger up
x33=Time(:,1)';
y33=Alt(1,1:indexAtMin)*1e-3;
[X33,Y33] = meshgrid(x33,y33);
Z33=Temp(1:3,1:indexAtMin)'-273.15;

%%

ax1=subplot(4,1,4);
contourf(Cloudnet.N,Cloudnet.height*1e-3,Cloudnet.category2,CloudPhaselevels,'LineColor','none');
colormap(ax1,cm1);
colorbar
caxis([4 15]);
c= colorbar(ax1,'Ticks',[4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5 ],...
    'TickLabels',{'Clear sky','Cloud droplets only','Drizzle or rain','Drizzle/rain & cloud droplets','Ice','Ice & supercooled droplets', ...
    'Melting ice','Melting ice & cloud droplets', 'Aerosol', 'Insects', 'Aerosol & insects'});
hold on;

if NoRasoNum==0
    h(1)=line(Raso.N,Raso.alt*1e-3,'Color',cm(2,:),'DisplayName',strxcat('Raso'),'LineWidth',3.0);
    hold on;
end

%Temperature lines:
v=[-50 -40 -35 -30 -25 -20 -15 -10 -5 0 5];
%contour(X33,Y33,Z33,v,'k','ShowText','on');

datetick('x','keeplimits');
ylabel('Height in km','FontSize',10);
ylim([0.2228 hmax]);
xlim([datenum(yy,mm,dd,0,0,0) datenum(yy,mm,dd+1,0,0,0)]);
xlabel('Time in UTC','FontSize',10);
set(gca,'FontSize',10);
title('Cloudnet classification','FontSize',10);

%"Bit 0: Small liquid droplets are present.\n",
%"Bit 1: Falling hydrometeors are present; if Bit 2 is set then these are most likely to be ice particles, otherwise they are drizzle or rain drops.\n",
%"Bit 2: Wet-bulb temperature is less than 0 degrees C, implying the phase of Bit-1 particles.\n",
%"Bit 3: Melting ice particles are present.\n",
%"Bit 4: Aerosol particles are present and visible to the lidar.\n",
%"Bit 5: Insects are present and visible to the radar." ;

x22=Cloudnet.N';
y22=Cloudnet.model_height*1e-3;
[X22,Y22] = meshgrid(x22,y22);
Z22=Cloudnet.temperature-273.15;
contour(X22,Y22,Z22,v,'k','ShowText','on');
h1=legend(h(1),'Radiosounding','Location','northeast');

%%
%move plot inside figure (if label is cutted off)
pos = get(gca, 'Position');
xoffset = -0.07;
pos(1) = pos(1) + xoffset;
set(gca, 'Position', pos)

%suptitle(strxcat(datestr(Cloudnet.N(1),'dd-mmm-yyyy')),'FontSize',15);
saveas(gcf,strxcat('Plots/4_Cloudnet/',datestr(Cloudnet.N(1),'yyyy-mm-dd'),'_Cloudnet_class_all.png')); 
%close(gcf);

end                             %End of: Only if Cloudnetfile exists

%%
clear a ax Alt c cbar1 cbar2 h h1 height pos pos1 pos2 pos3 po4 xoffset ax1 cm1 indexAtMin ... 
    minDifferenceValue Rasom1 Rasop1 Temp Time timestruct v valueToMatch x x22 X22 x33 X33 y22 Y22 ...
    y33 Y33 Z22 Z33

%%

