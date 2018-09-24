
%In this program the two plots of the Paper are generated: 1. fallspeed and mass 2. fall distance

mkdir('Plots','4_Sublimation');                 %create folder for plots 
close all
set(0, 'DefaultFigureRenderer', 'OpenGL');      %to remove the distance between 100 and mu in label.
Rsize_orig=Rsize;                               %needed to set back to original later

%%
%for including all three sizes r=50,100,150:

%Alternativ 1: fast (only if already existing)
load(strxcat('Sublimation_50','_',i,'.mat'))           %for multiple Sublimation calculation
load(strxcat('Sublimation_100','_',i,'.mat'))          %for multiple Sublimation calculation
load(strxcat('Sublimation_150','_',i,'.mat'))          %for multiple Sublimation calculation

%%
%Alternativ 2: slow (needed, if not already existing for that specific day)
%{
Rsize=50;                                   %define new Rsize
Raso_1_read                                 %do again with new Rsize 
Raso_3_layers                               %do again with new Rsize
maxtime50=maxtime;                        
Sublimation50=Sublimation;                
name=strxcat(Rsize);                               
save(strxcat('Sublimation_',name,'_',i,'.mat'), strxcat('maxtime',Rsize),strxcat('Sublimation',Rsize));

Rsize=100;                                  %define new Rsize  
Raso_1_read                                 %do again with new Rsize  
Raso_3_layers                               %do again with new Rsize
maxtime100=maxtime;                        
Sublimation100=Sublimation;                
name=strxcat(Rsize);                                
save(strxcat('Sublimation_',name,'_',i,'.mat'), strxcat('maxtime',Rsize),strxcat('Sublimation',Rsize));

Rsize=150;                                  %define new Rsize 
Raso_1_read                                 %do again with new Rsize 
Raso_3_layers                               %do again with new Rsize 
maxtime150=maxtime;                        
Sublimation150=Sublimation;                
name=strxcat(Rsize);                               
save(strxcat('Sublimation_',name,'_',i,'.mat'), strxcat('maxtime',Rsize),strxcat('Sublimation',Rsize));

%set settings back to original
Rsize=Rsize_orig;                       %Rsize back to original 
name=strxcat(Rsize);                                
Raso_1_read                                 %do again with original Rsize  
Raso_3_layers                               %do again with original Rsize
%}

%%
%Specify which layer should be used: 
%In the paper the layer 1 is the upper most. This equals kchose=4 in the program.

kvec=[1:k];
layervec=fliplr(kvec);
kchose=layervec(layer);

%Alternative chose kchose here:
%kchose=4;                    %kchose is program nr. (1 is at bottom) 
%layer=layervec(kchose);      %layer is paper nr. (1 is at top)

%%
%Plot1: Fallspeed and mass

figure(1);                                              
set(gcf,'units','normalized','position',[.5 .5 0.5 0.4]);

fs=12;              %define common fontSize Schriftgröße

hl1=plot(Sublimation50(kchose).time_min,Sublimation50(kchose).mass,'Color',cm(1,:),'DisplayName',strxcat('r=',50,'\mum'),'LineWidth',1.5);
hold on;
hl2=line(Sublimation100(kchose).time_min,Sublimation100(kchose).mass,'Color',cm(2,:),'DisplayName',strxcat('r=',100,'\mum'),'LineWidth',1.5);
hold on;
hl3=line(Sublimation150(kchose).time_min,Sublimation150(kchose).mass,'Color',cm(4,:),'DisplayName',strxcat('r=',150,'\mum'),'LineWidth',1.5);
hold on;
xlim([0 20]);
ylim([0 1.4e-8]);
ylabel('Mass of particle in kg');
xlabel('Time in min');
grid on;
set(gca,'FontSize',fs);

[hl4,ax2,ax3] = floatAxisY_M(Sublimation50(kchose).time_min(2:end),Sublimation50(kchose).speed(2:end),'--',strxcat('Fall speed in m s^{-1}'),[0 20 0 0.7],2.5,cm(1,:),10);
set(ax3,'FontSize',fs)                  %Size of xlabel;

[hl5,ax4,ax5] = floatAxisY_M(Sublimation100(kchose).time_min(2:end),Sublimation100(kchose).speed(2:end),'--',strxcat('Fall speed in m s^{-1}'),[0 20 0 0.7],2.5,cm(2,:),15);
set(ax5,'FontSize',fs)                  %Size of xlabel;

[hl6,ax6,ax7] = floatAxisY_M(Sublimation150(kchose).time_min(2:end),Sublimation150(kchose).speed(2:end),'--',strxcat('Fall speed in m s^{-1}'),[0 20 0 0.7],2.5,cm(4,:),10);
set(ax7,'FontSize',fs)                  %Size of xlabel;

h1=legend([hl1 hl2 hl3 hl4 hl5 hl6],'Mass of initial r= 50 \mum','Mass of initial r= 100 \mum','Mass of initial r= 150 \mum','Fall speed of initial r= 50 \mum','Fall speed of initial r= 100 \mum','Fall speed of initial r= 150 \mum', ...
   'Location','best'); 
set(h1,'FontSize',11);
set(h1,'units','normalized');
set(h1,'position',[0.6255 0.6557 0.2784 0.2421])

set(ax5,'Visible','off');
set(ax7,'Visible','off');

%insert a) in plot 
str = 'a)';
dim = [.2 .08 .03 .07];
annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor','none','LineStyle','none','FontSize',fs);

tightfig(gcf);                          %makes the plot nicer

fig = gcf;
fig.PaperPositionMode = 'auto';
fig.PaperSize =  [25.5 13];
saveas(gcf,strxcat('Plots/3_Sublimation/',datestr(Raso.N(1),'yyyy-mm-dd'),'_Sublimation_layer',layer,'_mass_speed.pdf'));

%%
%2.Plot Fall distance 

f2=figure(2);                 
set(gcf,'units','normalized','position',[.5 .5 0.3 0.4]);

plot(Sublimation50(kchose).time_min,Sublimation50(kchose).height*1e-3,'Color',cm(1,:),'DisplayName',strxcat('Fall distance of initial r=50 \mum'),'LineWidth',1.5)
hold on;
line(Sublimation100(kchose).time_min,Sublimation100(kchose).height*1e-3,'Color',cm(2,:),'DisplayName',strxcat('Fall distance of initial r=100 \mum'),'LineWidth',1.5)
hold on;
line(Sublimation150(kchose).time_min,Sublimation150(kchose).height*1e-3,'Color',cm(4,:),'DisplayName',strxcat('Fall distance of initial r=150 \mum'),'LineWidth',1.5)
hold on;
xlim([0 20]);
ylim([Cloudixd.height_sub_bottom(kchose)*1e-3; Sublimation100(kchose).initial_cond(4)*1e-3]);
ylabel(strxcat('Height of layer ',layer,' in km'));
xlabel('Time in min');
yticks(0:0.1:10);
h2=legend('show','Location','best');
grid on;
set(h2,'FontSize',fs);
set(gca,'FontSize',fs);
set(h2,'units','normalized');

%insert b) in plot
str = 'b)';
dim = [.005 .1 .03 .07];
annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor','none','LineStyle','none','FontSize',fs);

fig = gcf;
fig.PaperPositionMode = 'auto';
fig.PaperSize =  [15 12.6];
saveas(gcf,strxcat('Plots/3_Sublimation/',datestr(Raso.N(1),'yyyy-mm-dd'),'_Sublimation_layer',layer,'_dist.pdf'));

%%

clear kmax ax1 ax2 ax3 ax4 ax5 ax6 ax7 hl1 hl2 hl3 hl4 hl5 hl6 dim f2 fig fs h1 h2 str ans Rsize_orig
clear maxtime maxtime50 maxtime100 maxtime150 Sublimation Sublimation50 Sublimation100 Sublimation150 
clear kchose kvec layervec
%%


