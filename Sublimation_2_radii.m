
%In this program the two plots of the Paper are generated: 1. fallspeed and mass 2. fall distance

mkdir('Plots','4_Sublimation_var_icecrystal');                 %create folder for plots 

close all
set(0, 'DefaultFigureRenderer', 'OpenGL');      %to remove the distance between 100 and mu in label.
%OpenGL does not solve the problem 400   mum. Instead: save as .png, open if, print it into folder, choose pdf.
Rsize_orig=Rsize;                               %needed to set back to original later

%Define the size of the axis:
layer=1;            %Which layer? layer nr starts counting from top. 
dt=20;              %Time axis
fls=0.5;            %Fall speed axis
dm=1.4e-8;          %Mass axis

fs=10;              %define common fontSize Schriftgröße

%%
%for including all three sizes r=50,100,150:

%Alternativ 1: fast (only if already existing)
%load(strxcat('Sublimation_100','_',i,'.mat'))           %for multiple Sublimation calculation
%load(strxcat('Sublimation_200','_',i,'.mat'))          %for multiple Sublimation calculation
%load(strxcat('Sublimation_400','_',i,'.mat'))          %for multiple Sublimation calculation

%%
%Alternativ 2: slow (needed, if not already existing for that specific day)

Rsize=100;                                  %define new Rsize
Raso_1_read                                 %do again with new Rsize 
Raso_3_layers                               %do again with new Rsize
maxtime100=maxtime;                        
Sublimation100=Sublimation;                
name=strxcat(Rsize);                               
save(strxcat('Sublimation_',name,'_',i,'.mat'), strxcat('maxtime',Rsize),strxcat('Sublimation',Rsize));

Rsize=200;                                  %define new Rsize  
Raso_1_read                                 %do again with new Rsize  
Raso_3_layers                               %do again with new Rsize
maxtime200=maxtime;                        
Sublimation200=Sublimation;                
name=strxcat(Rsize);                                
save(strxcat('Sublimation_',name,'_',i,'.mat'), strxcat('maxtime',Rsize),strxcat('Sublimation',Rsize));

Rsize=400;                                  %define new Rsize 
Raso_1_read                                 %do again with new Rsize 
Raso_3_layers                               %do again with new Rsize 
maxtime400=maxtime;                        
Sublimation400=Sublimation;                
name=strxcat(Rsize);                               
save(strxcat('Sublimation_',name,'_',i,'.mat'), strxcat('maxtime',Rsize),strxcat('Sublimation',Rsize));

%set settings back to original
Rsize=Rsize_orig;                       %Rsize back to original 
name=strxcat(Rsize);                                
Raso_1_read                                 %do again with original Rsize  
Raso_3_layers                               %do again with original Rsize

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

hl1=plot(Sublimation100(kchose).time_min,Sublimation100(kchose).mass,'Color',cm(1,:),'DisplayName',strxcat('r=',100,'\mum'),'LineWidth',2.5);
hold on;
hl2=line(Sublimation200(kchose).time_min,Sublimation200(kchose).mass,'Color',cm(4,:),'DisplayName',strxcat('r=',200,'\mum'),'LineWidth',2.5);
hold on;
hl3=line(Sublimation400(kchose).time_min,Sublimation400(kchose).mass,'Color',cm(2,:),'DisplayName',strxcat('r=',400,'\mum'),'LineWidth',2.5);
hold on;
xlim([0 dt]);
ylim([0 dm]);
ylabel('Mass of particle in kg');
xlabel('Time in min');
grid on;
set(gca,'FontSize',fs);
   
[hl4,ax2,ax3] = floatAxisY_M(Sublimation100(kchose).time_min(2:end),Sublimation100(kchose).speed(2:end),'--',strxcat('Fall speed in m s^{-1}'),[0 dt 0 fls],2.5,cm(1,:),10);
set(ax3,'FontSize',fs)                  %Size of xlabel;

[hl5,ax4,ax5] = floatAxisY_M(Sublimation200(kchose).time_min(2:end),Sublimation200(kchose).speed(2:end),'--',strxcat('Fall speed in m s^{-1}'),[0 dt 0 fls],2.5,cm(4,:),15);
set(ax5,'FontSize',fs)                  %Size of xlabel;

[hl6,ax6,ax7] = floatAxisY_M(Sublimation400(kchose).time_min(2:end),Sublimation400(kchose).speed(2:end),'--',strxcat('Fall speed in m s^{-1}'),[0 dt 0 fls],2.5,cm(2,:),10);
set(ax7,'FontSize',fs)                  %Size of xlabel;

h1=legend([hl1 hl2 hl3 hl4 hl5 hl6],'Mass of initial r=100 \mum','Mass of initial r=200 \mum','Mass of initial r=400 \mum','Fall speed of initial r=100 \mum','Fall speed of initial r=200 \mum','Fall speed of initial r=400 \mum', ...
   'Location','best'); 
set(h1,'FontSize',fs);
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
set(fig, 'DefaultFigureRenderer', 'openGL');      %to remove the distance between 100 and mu in label.
saveas(gcf,strxcat('Plots/4_Sublimation_var_icecrystal/',datestr(Raso.N(1),'yyyy-mm-dd'),'_Sublimation_layer',layer,'_mass_speed',ending,'.png'));

%%
%2.Plot Fall distance 

f2=figure(2);                 
set(gcf,'units','normalized','position',[.5 .5 0.3 0.4]);

plot(Sublimation100(kchose).time_min,Sublimation100(kchose).height*1e-3,'Color',cm(1,:),'DisplayName','Fall distance of initial r=100 \mum','LineWidth',2.5)
hold on;
line(Sublimation200(kchose).time_min,Sublimation200(kchose).height*1e-3,'Color',cm(4,:),'DisplayName','Fall distance of initial r=200 \mum','LineWidth',2.5)
hold on;
line(Sublimation400(kchose).time_min,Sublimation400(kchose).height*1e-3,'Color',cm(2,:),'DisplayName','Fall distance of initial r=400 \mum','LineWidth',2.5)
hold on;
xlim([0 dt]);
ylim([Cloudixd.height_sub_bottom(kchose)*1e-3; Sublimation100(kchose).initial_cond(4)*1e-3]);
ylabel(strxcat('Height of layer ',layer,' in km'));
xlabel('Time in min');
yticks(0:0.1:10);
h2=legend('show','Location','northeast');
grid on;
set(h2,'FontSize',fs);
set(gca,'FontSize',fs);
set(h2,'units','normalized');

%insert b) in plot
str = 'b)';
dim = [.005 .1 .03 .07];
annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor','none','LineStyle','none','FontSize',fs);

set(0, 'DefaultFigureRenderer', 'OpenGL');      %to remove the distance between 100 and mu in label.

fig = gcf;
fig.PaperPositionMode = 'auto';
fig.PaperSize =  [15 12.6];
saveas(gcf,strxcat('Plots/4_Sublimation_var_icecrystal/',datestr(Raso.N(1),'yyyy-mm-dd'),'_Sublimation_layer',layer,'_dist',ending,'.png'));

%%

clear kmax ax1 ax2 ax3 ax4 ax5 ax6 ax7 hl1 hl2 hl3 hl4 hl5 hl6 dim f2 fig fs h1 h2 str ans Rsize_orig
clear maxtime maxtime50 maxtime100 maxtime150 Sublimation Sublimation50 Sublimation100 Sublimation150 
clear kchose kvec layervec
%%


