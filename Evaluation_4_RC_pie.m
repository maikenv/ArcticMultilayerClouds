
%This program generates the final Pie-plot

mkdir('Plots','11_RC_final');                   %Here the plots are stored
Evaluation_4_RC_calc                            %is needed

%%
%Pie Plot: without missing data

%XP(1)=Anz_Nan/lAusw;                               
XP(2)=Anz_0cloud/Anz_nonNan;                             
XP(3)=Anz_noML0/Anz_nonNan;
XP(4)=Anz_1cloud/Anz_nonNan; 
XP(5)=Anz_noML1/Anz_nonNan; 
XP(6)=Anz_onlyseed/Anz_nonNan;    
XP(7)=Anz_both/Anz_nonNan;    
XP(8)=Anz_nonseed/Anz_nonNan;  

ans1=Anz_Nan+Anz_0cloud+Anz_1cloud+Anz_onlyseed+Anz_both+Anz_nonseed+Anz_noML;
ans2=Anz_0cloud+Anz_1cloud+Anz_onlyseed+Anz_both+Anz_nonseed+Anz_noML;

txt={['No data (raso&radar)']; ...                      
    ['No cloud by radiosounding: ']; ...                 
    ['No cloud: MLC by radiosounding, but no cloud by radar: ']; ...
    ['Single layer clouds by radiosounding: ']; ...
    ['Single layer cloud: MLC by radiosounding, but single layer cloud by radar: ']; ...
    ['Only seeding MLCs: ']; ...                   
    ['Both seeding and non-seeding MLCs: ']; ...                   
    ['Only non-seeding MLCs: ']};    

%%
grey =[0.702 0.702 0.702];

Xcolor(1,:)=grey;
Xcolor(2,:)=cm(1,:);
Xcolor(3,:)=colordg(21);
Xcolor(4,:)=cm(5,:);
Xcolor(5,:)=colordg(8);
Xcolor(6,:)=cm(3,:);
Xcolor(7,:)=cm(2,:);
Xcolor(8,:)=cm(7,:);

%Find, where XP==0. Remove label and color.
idx_0=find(XP==0);                             
txt(idx_0)=[];
Xcolor(idx_0,:)=[];

%Pie Plot:
f=figure(13);
set(gcf,'units','normalized','position',[.1 .1 0.8 0.3]);
h=pie(XP);
colormap(Xcolor);

%%
%t=title(strxcat('Days between June 2016 - June 2017 detected by Radiosonde and Radar, r=',Rsize,'\mum'));
hText = findobj(h,'Type','text');                               % text object handles
percentValues = get(hText,'String');                            % percent values
combinedtxt = strcat(txt,percentValues);                        % strings and percent values
%Change position and label
oldExtents_cell = get(hText,'Extent');                          % cell array
oldExtents = cell2mat(oldExtents_cell);                         % numeric array
try
hText(1).String = combinedtxt(1);
pos= hText(1).Position;
hText(1).Position=[pos(1)+0.8 pos(2) pos(3)];
hText(2).String = combinedtxt(2);
pos= hText(2).Position;
hText(2).Position=[pos(1)+1.7 pos(2) pos(3)];
hText(3).String = combinedtxt(3);
pos= hText(3).Position;
hText(3).Position=[pos(1)+1.15 pos(2) pos(3)];
hText(4).String = combinedtxt(4);
pos= hText(4).Position;
hText(4).Position=[pos(1)-4.15 pos(2) pos(3)];
hText(5).String = combinedtxt(5);
pos= hText(5).Position;
hText(5).Position=[pos(1)-0.65 pos(2) pos(3)];
hText(6).String = combinedtxt(6);
pos= hText(6).Position;
hText(6).Position=[pos(1)-1.0 pos(2) pos(3)];
hText(7).String = combinedtxt(7);
pos= hText(7).Position;
hText(7).Position=[pos(1)-0.7 pos(2) pos(3)];
hText(8).String = combinedtxt(8);
catch
end
newExtents_cell = get(hText,'Extent');                          % cell array
newExtents = cell2mat(newExtents_cell);                         % numeric array 
width_change = newExtents(:,3)-oldExtents(:,3);
signValues = sign(oldExtents(:,1));
offset = signValues.*(width_change/2);
textPositions_cell = get(hText,{'Position'});                   % cell array
textPositions = cell2mat(textPositions_cell);                   % numeric array
textPositions(:,1) = textPositions(:,1) + offset;               % add offset 
try
hText(1).Position = textPositions(1,:);
hText(2).Position = textPositions(2,:);
hText(3).Position = textPositions(3,:);
hText(4).Position = textPositions(4,:);
hText(5).Position = textPositions(5,:);
hText(6).Position = textPositions(6,:);
hText(7).Position = textPositions(7,:);
pos= hText(7).Position;
hText(7).Position=[pos(1)+0.1 pos(2)-0.0 pos(3)];
hText(8).Position = textPositions(8,:);
catch
end

saveas(gcf,strxcat('Plots/11_RC_final/RC_Pie_',name,'.png'));
matlab2tikz(strxcat('Plots/11_RC_final/RC_Pie_',name,'.tex'));

%%
%Write result into struct:
XPstruct.(ending) = XP(2:8);
%%

clear ans1 ans2 Anz_2cloud Anz_nonseeding Anz_nonseeding_help Anz_seeding Anz_seeding_help Anz_trenn MLC_cloudlayers MLC_hmax combinedtxt ...
    grey hText idx_2cloud idx_nonseeding idx_seeding k newExtents newExtents_cell offset oldExtents oldExtents_cell ...
    percentValues pos signValues textPositions textPositions_cell txt width_change xoffset XP Xcolor f h idx_0 t

%%




