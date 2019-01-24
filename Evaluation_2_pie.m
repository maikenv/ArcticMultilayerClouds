
%In this program the plot of only using Raso is generated.
mkdir('Plots','8_Raso'); 
close(gcf)

Evaluation_1_calc                        %This is needed

%%
%Pie Plot in percentages

%XP(1)=Anz_Nan/Anz_nonNan;                               
XP(2)=Anz_0cloud/Anz_nonNan;                             
XP(3)=Anz_1cloud/Anz_nonNan;                             
XP(4)=Anz_onlyseed/Anz_nonNan;    
XP(5)=Anz_both/Anz_nonNan;    
XP(6)=Anz_nonseed/Anz_nonNan;    

Anz_0cloud+Anz_1cloud+Anz_onlyseed+Anz_both+Anz_nonseed;

%%
grey =[0.702 0.702 0.702];

Xcolor(1,:)=grey;
Xcolor(2,:)=cm(1,:);
Xcolor(3,:)=cm(5,:);
Xcolor(4,:)=cm(3,:);
Xcolor(5,:)=cm(2,:);
Xcolor(6,:)=cm(7,:);

txt={['no data: ']; ...                      
    ['No supersaturated layer: ']; ...                 
    ['Only one single supersaturated layer: ']; ...                         
    ['Only seeding subsaturated layers: ']; ...                   
    ['Both seeding and non-seeding subsaturated layers: ']; ...                   
    ['Only non-seeding subsaturated layers: ']};    

%Find, where XP==0. Remove label and color
idx_0=find(XP==0);                           %index of Position                         
txt(idx_0)=[];
Xcolor(idx_0,:)=[];

%Pie Plot:
f4=figure(4);
set(gcf,'units','normalized','position',[.1 .1 0.65 0.3]);
h=pie(XP);
colormap(Xcolor);

%%
%title(strxcat('Multilayer RHi>100% during 2016-2017, Iceradius: ',Rsize,'\mum'))
%title(strxcat('Multilayer RH_i>100% days between June 2016 - June 2017, r=',Rsize,'\mum'))
hText = findobj(h,'Type','text');                           % text object handles
percentValues = get(hText,'String');                        % percent values
combinedtxt = strcat(txt,percentValues);                    % strings and percent values
oldExtents_cell = get(hText,'Extent');                      % cell array
oldExtents = cell2mat(oldExtents_cell);                     % numeric array
try
hText(1).String = combinedtxt(1);
pos= hText(1).Position;                                     % change position of labels
hText(1).Position=[pos(1)+0.8 pos(2) pos(3)];
hText(2).String = combinedtxt(2);
pos= hText(2).Position;                                     % change position of labels
hText(2).Position=[pos(1)+1.1 pos(2) pos(3)];
hText(3).String = combinedtxt(3);
pos= hText(3).Position;                                     % change position of labels
hText(3).Position=[pos(1)-0.9 pos(2) pos(3)];
hText(4).String = combinedtxt(4);
pos= hText(4).Position;                                     % change position of labels
hText(4).Position=[pos(1)-1.3 pos(2) pos(3)];
hText(5).String = combinedtxt(5);
pos= hText(5).Position;                                     % change position of labels
hText(5).Position=[pos(1)-0.9 pos(2) pos(3)];
hText(6).String = combinedtxt(6);
catch
end
newExtents_cell = get(hText,'Extent');                      % cell array
newExtents = cell2mat(newExtents_cell);                     % numeric array 
width_change = newExtents(:,3)-oldExtents(:,3);
signValues = sign(oldExtents(:,1));
offset = signValues.*(width_change/2);
textPositions_cell = get(hText,{'Position'});               % cell array
textPositions = cell2mat(textPositions_cell);               % numeric array
textPositions(:,1) = textPositions(:,1) + offset;           % add offset 
try
hText(1).Position = textPositions(1,:);
hText(2).Position = textPositions(2,:);
hText(3).Position = textPositions(3,:);
hText(4).Position = textPositions(4,:);
hText(5).Position = textPositions(5,:);
hText(6).Position = textPositions(6,:);
catch
end

%move plot inside figure (if label is cutted off)
pos = get(gca, 'Position');
xoffset = -0.1;
pos(1) = pos(1) + xoffset;
set(gca, 'Position', pos)

saveas(gcf,strxcat('Plots/8_Raso/Pie_',name,'.png'));
matlab2tikz(strxcat('Plots/8_Raso/Pie_',name,'.tex'));


%%
clear Anz_2cloud Anz_nonseeding Anz_nonseeding_help Anz_seeding Anz_seeding_help Anz_trenn ...
    MLC_loudlayers Ausw_hmax combinedtxt grey hText idx_2cloud idx_nonseeding idx_seeding k ...
    newExtents newExtents_cell offset oldExtents oldExtents_cell percentValues pos signValues ...
    textPositions textPositions_cell txt width_change xoffset Xcolor XP f4 h 

%%










