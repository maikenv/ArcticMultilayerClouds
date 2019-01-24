
%This program evaluates the seeding cases into different cloud categories
%and creates a Pie-plot (Paper).

mkdir('Plots','10_CloudCategories'); 
close(gcf)
lMLC=length(index);                                %Find length of evaluated data

%%
%take the needed variables

for k=1:lMLC
    SeedingS(k).number_i=MLC_classification(k).number_i;
    SeedingS(k).date=MLC_classification(k).date;
    SeedingS(k).Seeding=MLC_classification(k).Seeding;
    SeedingS(k).Zcloudbelow=MLC_classification(k).Zbelow;
    SeedingS(k).Znoncloud=MLC_classification(k).Zbetween;
    SeedingS(k).Zcloudabove=MLC_classification(k).Zabove;
end

%%
%find max amount of layers 

for k=1:lMLC
    SeedingS(k).seedAnz=NaN;
    
    if isnan(SeedingS(k).Seeding) ==false
        SeedingS(k).seedAnz=length(SeedingS(k).Seeding);
    end
    
end

for k=1:lMLC
    max_seed(k)=SeedingS(k).seedAnz;
end

max_seed=nanmax(max_seed);

%%

Seed(1:lMLC,1:max_seed)=NaN;
Zcloudbelow(1:lMLC,1:max_seed)=NaN;
Znoncloud(1:lMLC,1:max_seed)=NaN;
Zcloudabove(1:lMLC,1:max_seed)=NaN;

for k=1:lMLC
    if isnan(SeedingS(k).Seeding) ==false
        lS=length(SeedingS(k).Seeding);
        Seed(k,1:lS)=SeedingS(k).Seeding(1:lS);  
        Zcloudbelow(k,1:lS)=SeedingS(k).Zcloudbelow(1:lS);
        Znoncloud(k,1:lS)=SeedingS(k).Znoncloud(1:lS);
        Zcloudabove(k,1:lS)=SeedingS(k).Zcloudabove(1:lS);
    end   
end

%%
%consider only Seeding==1. Count Anz=total amount.

idx_Seed=find(Seed==1);                                 
Anz_Seed=length(idx_Seed);                       %Total amount seeding                     

%%
%Count the different cloud categories:

Anz1=0;
Anz2=0;
Anz3=0;
Anz4=0;
Anz5=0;
Anz6=0;
Anz7=0;
Anz8=0;

for k=1:lMLC
    for kk=1:max_seed
        %['no cloud above, no in mid, no below']
        if Seed(k,kk)==1 && Zcloudbelow(k,kk)==0 && Znoncloud(k,kk)==0  && Zcloudabove(k,kk)==0
            Anz1=Anz1+1;     
        %['no above, no in mid, cloud below']
        elseif Seed(k,kk)==1 && Zcloudbelow(k,kk)==1 && Znoncloud(k,kk)==0  && Zcloudabove(k,kk)==0
            Anz2=Anz2+1; 
        %['no above, cloud in mid, cloud below']
        elseif Seed(k,kk)==1 && Zcloudbelow(k,kk)==1 && Znoncloud(k,kk)==1  && Zcloudabove(k,kk)==0
            Anz3=Anz3+1;  
        %['no above, cloud in mid, no below']
        elseif Seed(k,kk)==1 && Zcloudbelow(k,kk)==0 && Znoncloud(k,kk)==1  && Zcloudabove(k,kk)==0
            Anz4=Anz4+1;  
        %['cloud above, cloud in mid, cloud below']
        elseif Seed(k,kk)==1 && Zcloudbelow(k,kk)==1 && Znoncloud(k,kk)==1 && Zcloudabove(k,kk)==1
            Anz5=Anz5+1;  
        %['cloud above, cloud in mid, no below']
        elseif Seed(k,kk)==1 && Zcloudbelow(k,kk)==0 && Znoncloud(k,kk)==1  && Zcloudabove(k,kk)==1
            Anz6=Anz6+1;  
        %['cloud above, no in mid, no below']
        elseif Seed(k,kk)==1 && Zcloudbelow(k,kk)==0 && Znoncloud(k,kk)==0  && Zcloudabove(k,kk)==1
            Anz7=Anz7+1; 
        %['cloud above, no in mid, cloud below']
        elseif Seed(k,kk)==1 && Zcloudbelow(k,kk)==1 && Znoncloud(k,kk)==0  && Zcloudabove(k,kk)==1
            Anz8=Anz8+1;  
        end
    end
end

%%
%Count how much is left
Anz_123=Anz1+Anz2+Anz3;
Anz_else=Anz_Seed-Anz_123;

%Control, if all is considered
Anz_12345678=Anz1+Anz2+Anz3+Anz4+Anz5+Anz6+Anz7+Anz8;
Anz_else2=Anz_Seed-Anz_12345678;

%%
%Define order of cloud categories in Pie plot: 
X=[1,2,3,4,5,6,7,8];                 %ascending
%X=[1,8,2,7,3,6,5,4];                %original
%X=[1,2,7,3,5,8,4,6];                %neu
%X=[8,1,2,7,3,5,4,6];                %neu

%%
%Labels:

txt={['1. No cloud above, no cloud in between, no cloud below: ']; ...             %Anz1 
    ['2. No cloud above, no cloud in between, cloud below: ']; ...                 %Anz2
    ['3. No cloud above, cloud in between, cloud below: ']; ...                    %Anz3   
    ['4. No cloud above, cloud in between, no cloud below: ']; ...                 %Anz4
    ['5. Cloud above, cloud in between, cloud below: ']; ...                       %Anz5
    ['6. Cloud above, cloud in between, no cloud below: ']; ...                    %Anz6
    ['7. Cloud above, no cloud in between, no cloud below: ']; ...                 %Anz7
    ['8. Cloud above, no cloud in between, cloud below: ']};                       %Anz8

%use X to change order of labels
help = java_array('java.lang.String', 8);
help(1) = java.lang.String(txt(X(1),1));
help(2) = java.lang.String(txt(X(2),1));
help(3) = java.lang.String(txt(X(3),1));
help(4) = java.lang.String(txt(X(4),1));
help(5) = java.lang.String(txt(X(5),1));
help(6) = java.lang.String(txt(X(6),1));
help(7) = java.lang.String(txt(X(7),1));
help(8) = java.lang.String(txt(X(8),1));
txt = cell(help);

%%
%Write in XP-vektor
XP(1:8)=0;
XP(1)=Anz1/Anz_Seed;                               
XP(2)=Anz2/Anz_Seed;                             
XP(3)=Anz3/Anz_Seed; 
XP(4)=Anz4/Anz_Seed; 
XP(5)=Anz5/Anz_Seed; 
XP(6)=Anz6/Anz_Seed; 
XP(7)=Anz7/Anz_Seed; 
XP(8)=Anz8/Anz_Seed; 
%Change XP by using X:
XP=XP(X);

darkgrey  = [0.55 0.55 0.55];
lightgrey =[0.75 0.75 0.75];

Xcolor(1,:)=darkgrey;
Xcolor(2,:)=darkgrey;
Xcolor(3,:)=lightgrey; 
Xcolor(4,:)=lightgrey;
Xcolor(5,:)=colordg(10);
Xcolor(6,:)=lightgrey;
Xcolor(7,:)=darkgrey;
Xcolor(8,:)=lightgrey;
%Change colors by using X:
Xcolor=Xcolor(X,:);

%%
%Find, where XP==0. Remove label and color, if not needed
idx_0=find(XP==0);                     
txt(idx_0)=[];
Xcolor(idx_0,:)=[];

%Pie Plot:
f=figure(9);
set(gcf,'units','normalized','position',[.1 .1 0.6 0.3]);
h=pie(XP);
colormap(Xcolor);

%%
%Plot:

%title(strxcat('Seeding cases, Zeit, r=',Rsize,'\mum'))
hText = findobj(h,'Type','text');                               % text object handles
percentValues = get(hText,'String');                            % percent values
combinedtxt = strcat(txt,percentValues);                        % strings and percent values
%Change position and labels
oldExtents_cell = get(hText,'Extent');                          % cell array
oldExtents = cell2mat(oldExtents_cell);                         % numeric array
try
hText(1).String = combinedtxt(1);
hText(2).String = combinedtxt(2);
hText(3).String = combinedtxt(3);
hText(4).String = combinedtxt(4);
hText(5).String = combinedtxt(5);
hText(6).String = combinedtxt(6);
hText(7).String = combinedtxt(7);
hText(8).String = combinedtxt(8);
hText(9).String = combinedtxt(9);
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
pos= hText(1).Position;
hText(1).Position=[pos(1)+1.6 pos(2) pos(3)];
hText(2).Position = textPositions(2,:);
pos= hText(2).Position;
hText(2).Position=[pos(1)-2.8 pos(2) pos(3)];
hText(3).Position = textPositions(3,:);
pos= hText(3).Position;
hText(3).Position=[pos(1)-1.44 pos(2) pos(3)];
hText(4).Position = textPositions(4,:);
pos= hText(4).Position;
hText(4).Position=[pos(1)-1.35 pos(2) pos(3)];
hText(5).Position = textPositions(5,:);
pos= hText(5).Position;
hText(5).Position=[pos(1)-1.35 pos(2) pos(3)];
hText(6).Position = textPositions(6,:);
pos= hText(6).Position;
hText(6).Position=[pos(1)-1.4 pos(2) pos(3)];
hText(7).Position = textPositions(7,:);
pos= hText(7).Position;
hText(7).Position=[pos(1)-1.3 pos(2) pos(3)];
hText(8).Position = textPositions(8,:);
%pos= hText(8).Position;
%hText(8).Position=[pos(1)-2.4 pos(2) pos(3)];
hText(9).Position = textPositions(9,:);
catch 
end

saveas(gcf,strxcat('Plots/10_CloudCategories/Seeding_',name,'.png'));
matlab2tikz(strxcat('Plots/10_CloudCategories/Seeding_',name,'.tex'));

%%

clear Anz1 Anz2 Anz3 Anz4 Anz5 Anz6 Anz7 Anz8 Anz_123 Anz_12345678 Anz_else Anz_else2 Anz_Seed f h idx_0 idx_Seed ...
    k kk lAusw lS lXP max_seed Seed Seeding Xcolor XP XPless Zcloud Znoncloud combinedtxt hText newExtents ...
    newExtents_cell offset oldExtents oldExtents_cell percentValues signValues textPositions textPositions_cell ...
    txt width_change help darkgrey lightgrey X pos fig

%%








