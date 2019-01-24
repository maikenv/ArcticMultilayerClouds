
%This program creates the plot of both Raso and Cloudnet.
fs=10;              %fontsize. 10=std. Poster:15

if NoRasoNum==0                                %only if Raso is available  
if NoCloudnetNum==0                            %only if Cloudnet exists
if sizeZ(2)>30                                 %only if there is min one cloudless laye
if numcloud_i>=2                               %only if min 1 nocloudlayer   

%%
%Black lines indicating time in plot: Find time beginn and time end
%Nbefore and Nafter taken from Cloudnet_4_preparation_adv

[Nbefore_vec,Y22] = meshgrid(Nbefore',Cloudnet_short.height');
[Nafter_vec,Y22] = meshgrid(Nafter',Cloudnet_short.height');   


%%
%Defining time period of Cloudnet colours: use this for more cloud signal before and after:
%{
[yy mm dd hh minu sek]=datevec(Raso10km.N(1));
Nbefore_more = datenum(yy,mm,dd,9,0,0);  
[yy mm dd hh minu sek]=datevec(Raso10km.N(end));
Nafter_more = datenum(yy,mm,dd,13,0,0);     

x = Cloudnet_short.N;
valueToMatch = Nbefore_more;
[minDifferenceValue, indexAtStart_more] = min(abs(x - valueToMatch));

x = Cloudnet_short.N;
valueToMatch = Nafter_more;
[minDifferenceValue, indexAtEnd_more] = min(abs(x - valueToMatch));

indexAtStart=indexAtStart_more;
indexAtEnd=indexAtEnd_more;
%}
%%
reso=20;                        %Plot-Color-Resolution
%Plot Reflectivity:
[yy1 mm1 dd1]=datevec(Cloudnet_short.N(1));

%%
ab=figure(13);
%set(gcf,'Visible','off','units','normalized','position',[.5 .15 0.6 0.5]);
set(gcf,'units','normalized','position',[.5 .15 0.6 0.5]);

%First plot: Raso
ax1=subplot(1,2,1);
plot(Raso.RHl,Raso.alt*1e-3,'LineWidth',1.5,'DisplayName','RH liquid','Color',cm(1,:));
line(Raso.RHi,Raso.alt*1e-3,'LineWidth',1.5,'DisplayName','RH ice','Color',cm(2,:));
ylim([0.2228 hmax]);
%ylim([0 hmax]);
xlim([0 150]);
ax1=gca;
ylabel('Height in km','FontSize',fs);
xlabel('RH in %','FontSize',fs);
h=legend(ax1,'show','Location','northwest');
set(h,'FontSize',fs);
set(gca,'FontSize',fs)
grid on;

%Plotting red horisontal lines 
for k=1:layers                                                  
    mu=Cloudnet_short.height(indexAtTopNoCloud(k))*1e-3;
    hline = refline([0 mu]);
    hline.Color = 'r';

    mu=Cloudnet_short.height(indexAtBottomNoCloud(k))*1e-3;
    hline = refline([0 mu]);
    hline.Color = 'r';

end

%for grey transparent boxes:
greyt =[0.702 0.702 0.702 0.3];                          %transparent grey color
for k=1:layers

    mu=Cloudnet_short.height(indexAtTopNoCloud(k))*1e-3;
    muk(k)=mu;

    mu=Cloudnet_short.height(indexAtBottomNoCloud(k))*1e-3;
    muk2(k)=mu;

end

%für subsaturated layers = grey
for j=1:length(muk2)
    rectangle('Position',[0 muk2(j) 150 muk(j)-muk2(j)],'EdgeColor','none','Facecolor', greyt)
end

%Make label a) in plot
str = 'a)';
dim = [.165 .09 .03 .07];
annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor','none','LineStyle','none','FontSize',fs);

%%
%Name the subsaturated layers by numbers
%disp('careful, please check numbers');

xt = [140 140 140 140 140 140 140];
str_layer = {'1','2','3',' ',' ',' ',' '};
number=i;
switch number
    case 65;   yt = [8.85 8.25 6.8 5 1.8 0.5 0.4];                   
    case 69;   yt = [8.7 8.4 7.95 6.3 5.2 4.1 2.5];
    case 70;   yt = [7.9 7.05 6.17 3.8 5 2 1.8];  
    case 127;  yt = [3 0.95 5 4 6.8 5 1.8];                               
    case 135;  yt = [8 4 1.5 6.8 5 2 1.8]; 
    case 140;  yt = [6.2 3.1 4.1 2.5 1 0.5 0.3];                              
    case 147;  yt = [4 2 1.55 1.25 5 2 1.8];  str_layer = {'1','2','3','4',' ',' ',' '};                            
    case 322;  yt = [8.7 5.5 2 1.25 5 2 1.8];    
    otherwise;  yt = [8.7 5.5 2 1.25 5 2 1.8];  str_layer = {' ',' ',' ',' ',' ',' ',' '};
end
text(xt,yt,str_layer,'FontSize',fs)
hold on;

%%
%Second plot part: reflectivity

ax2=subplot(1,2,2);
contourf(Cloudnet_short.N(indexAtStart:indexAtEnd),Cloudnet_short.height*1e-3,Cloudnet_short.Z(:,indexAtStart:indexAtEnd),reso,'LineColor','none');
h(1)=line(Nbefore_vec,Cloudnet_short.height*1e-3,'Color','k','LineWidth',3.0);
hold on;
h(2)=line(Raso.N,Raso.alt*1e-3,'Color',cm(2,:),'DisplayName',strxcat('Raso'),'LineWidth',3.0);
hold on;
h(3)=line(Nafter_vec,Cloudnet_short.height*1e-3,'Color','k','LineWidth',3.0);
hold on;
ylabel('Height in km','FontSize',fs);
xlabel('Time in UTC','FontSize',fs);
ylim([0.2228 hmax]);
%ylim([0 hmax]);
xlim([datenum(yy1,mm1,dd1,timeStart,0,0) datenum(yy1,mm1,dd1,timeEnd,0,0)]);
datetick('x',15,'keeplimits');

h2=legend(h(2),'Radiosounding','Location','northwest');
set(h2,'FontSize',fs);
set(gca,'FontSize',fs);
grid on;

%Plot red lines in reflectivity:
for k=1:layers

    mu=Cloudnet_short.height(indexAtTopNoCloud(k))*1e-3;
    hline = refline([0 mu]);
    hline.Color = 'r';

    mu=Cloudnet_short.height(indexAtBottomNoCloud(k))*1e-3;
    hline = refline([0 mu]);
    hline.Color = 'r';

end

%grey subsaturated layers:
for j=1:length(muk2)
    rectangle('Position',[datenum(yy1,mm1,dd1,timeStart,0,0) muk2(j) datenum(yy1,mm1,dd1,timeEnd,0,0) muk(j)-muk2(j)],'EdgeColor','none','Facecolor', greyt) %oben
end

%Label b) in plot:
dim = [.525 .09 .03 .07];
str = 'b)';
annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor','none','LineStyle','none','FontSize',fs);

%Position of numbers in reflectivity plot
indexAt1234=128;                            %Time-index for x-position of label
xt = [Cloudnet_short.N(indexAt1234) Cloudnet_short.N(indexAt1234) Cloudnet_short.N(indexAt1234) Cloudnet_short.N(indexAt1234) Cloudnet_short.N(indexAt1234) Cloudnet_short.N(indexAt1234) Cloudnet_short.N(indexAt1234)];
text(xt,yt,str_layer,'FontSize',fs)

%%
%Settings for both plots:

ax(1)=subplot(1,2,1);
ax(2)=subplot(1,2,2);

c=colorbar('EastOutside');
c.Label.String = 'Z in dBZ';
caxis([-40 +20]);
hold on; 

for ij=1:2
pos=get(ax(ij), 'Position');
set(ax(ij), 'Position', [-0.05+pos(1) pos(2) pos(3)*0.8 pos(4)]);
end;

ij=1;
pos=get(ax(ij), 'Position');
set(ax(ij), 'Position', [pos(1)+0.08 pos(2) pos(3) pos(4)]);

%for time labels:
xlim([datenum(yy1,mm1,dd1,timeStart,0,0) datenum(yy1,mm1,dd1,timeEnd,0,1)]);
datetick('x',15);
xlim([datenum(yy1,mm1,dd1,timeStart,0,0) datenum(yy1,mm1,dd1,timeEnd,0,1)]);

%%
%Save Plot: 

mkdir('Plots',strxcat('7_Sectionlines_',name)); 
fig = gcf;
fig.PaperPositionMode = 'auto';
fig.PaperSize =  [25.0 15.5];
saveas(gcf,strxcat('Plots/7_Sectionlines_',name,'/',datestr(Cloudnet_short.N(1),'yyyy-mm-dd'),'.png')); 

%close(gcf)

end
end
end
end

%%

clear h ax ax1 ax2 cloud cloudZ cloudZmean40 cloudZmean402 cloudZmeanhalf cloudZmeanhalf2 h h1 ...
    height helpcloud hh hline indexAtMin minDifferenceValue minu mu Nafter_new Nansum ...
    pos h2 Nansum_cloud Nansumnot Nansumnot_cloud Nbefore_new nocloud nocloudZ nocloudZmean40 ...
    nocloudZmean402 nocloudZmeanhalf nocloudZmeanhalf2 pos1 reso valueToMatch ZnN x sek mm dd yy yy1 ...
    mm1 dd1 ab ac c Nafter Nafter_vec Nbefore Nbefore_vec Y22 kminus layers1 kminus1 ...
    indexAtBottomNoCloud1 indexAtTopNoCloud1 filename mu muk muk2 j ij indexAt1234 dim greyt ...
    Nafter_more Nbefore_more str str_layer xt yt indexAtEnd_more indexAtStart_more fs fig

%%

