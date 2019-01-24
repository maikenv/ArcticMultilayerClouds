
%This program reads a list where the visual MLC (multilayer cloud) detection is stored.
%The list is done manually by going through the images and deciding wheater it is a visual or
%non-visual MLC case.

mkdir('Plots','9_Visual'); 

%Read the list:
file = (strxcat('Data/Visual.txt'));
[day_all month_all year_all Visual]=textread(file,'%d-%d-%d %d %*[^\n]', 'headerlines',3);
lguck=length(Visual);                     %total length: alle measurement days

%%
%Count amount of days having different layers

idx_nan=find(isnan(Visual));                                                  %index of Position         
lidx_nan=length(idx_nan);                   %Non-MLC: 1 or less layers          %length of Index List  

idx_0=find(Visual==0);                           
lidx_0=length(idx_0);                       %cloudless: no cloud

idx_1=find(Visual==1);                              
lidx_1=length(idx_1);                       %exact 1 cloud

idx_2=find(Visual>=2);                               
lidx_2=length(idx_2);                       %2 or more layers

idx_cloudcover=find(Visual>=1);                               
lidx_cloudcover=length(idx_cloudcover);     %1 or more layers (cloudcover)  

idx_nonNan=find(~isnan(Visual));                                     
lidx_nonNan=length(idx_nonNan);             %non-NaN                     

%%

%For Pie Plot:
%XP(1)=lidx_nan/lidx_nonNan;                               
XP(2)=lidx_0/lidx_nonNan;                             
XP(3)=lidx_1/lidx_nonNan;                             
XP(4)=lidx_2/lidx_nonNan;
%lidx_0+lidx_1+lidx_2

txt = {'no data '; 'no cloud ';'single layer clouds ';'multilayer clouds '};

%%
grey =[0.702 0.702 0.702];

Xcolor(1,:)=grey;
Xcolor(2,:)=cm(1,:);
Xcolor(3,:)=cm(5,:);
Xcolor(4,:)=cm(4,:);

%Find, where XP==0.                         %Remove the label and color
idx_0r=find(XP==0);                         %index of position                         
txt(idx_0r)=[];
Xcolor(idx_0r,:)=[];

%Pie Plot:
f=figure(9);
set(gcf,'units','normalized','position',[.1 .1 0.4 0.3]);
h=pie(XP);
colormap(Xcolor);

%%

%title('Observed clouds during june 2016 - june 2017')
hText = findobj(h,'Type','text');                       % text object handles
percentValues = get(hText,'String');                    % percent values
combinedtxt = strcat(txt,percentValues);                % strings and percent values
%Change position and label:
oldExtents_cell = get(hText,'Extent');                  % cell array
oldExtents = cell2mat(oldExtents_cell);                 % numeric array
try
hText(1).String = combinedtxt(1);
hText(2).String = combinedtxt(2);
hText(3).String = combinedtxt(3);
hText(4).String = combinedtxt(4);
catch
end
newExtents_cell = get(hText,'Extent');                  % cell array
newExtents = cell2mat(newExtents_cell);                 % numeric array 
width_change = newExtents(:,3)-oldExtents(:,3);
signValues = sign(oldExtents(:,1));
offset = signValues.*(width_change/2);
textPositions_cell = get(hText,{'Position'});           % cell array
textPositions = cell2mat(textPositions_cell);           % numeric array
textPositions(:,1) = textPositions(:,1) + offset;       % add offset 
try
hText(1).Position = textPositions(1,:);
hText(2).Position = textPositions(2,:);
pos= hText(2).Position;
hText(2).Position=[pos(1) pos(2)+0.1 pos(3)];
hText(3).Position = textPositions(3,:);
hText(4).Position = textPositions(4,:);
pos= hText(4).Position;
hText(4).Position=[pos(1) pos(2)+0.1 pos(3)];
catch
end

saveas(gcf,strxcat('Plots/9_Visual/VisualPie.png'));
%matlab2tikz(strxcat('Plots/9_Visual/VisualPie.tex'));

%%

%Monthly distribution for histogram:

%Nan cloud:
mon_nan=month_all(idx_nan);
[a_nan,b_nan]=hist(mon_nan,unique(mon_nan));
list_nan(1:12)=NaN;
for k=1:length(b_nan)
    list_nan(b_nan(k))=a_nan(k);      
end
list_nan(isnan(list_nan))=0;

%No cloud:
mon_0=month_all(idx_0);
[a_0,b_0]=hist(mon_0,unique(mon_0));
list_0(1:12)=NaN;
for k=1:length(b_0)
    list_0(b_0(k))=a_0(k);      
end
list_0(isnan(list_0))=0;

%Single Layer Clouds:
mon_1=month_all(idx_1);
[a_1,b_1]=hist(mon_1,unique(mon_1));
list_1(1:12)=NaN;
for k=1:length(b_1)
    list_1(b_1(k))=a_1(k);      
end
list_1(isnan(list_1))=0;

%2 or more clouds:
mon_2=month_all(idx_2);                         %List of month of occurrence
[a_2,b_2]=hist(mon_2,unique(mon_2));
list_2(1:12)=NaN;
for k=1:length(b_2)
    list_2(b_2(k))=a_2(k);                      %List of amount per month
end
list_2(isnan(list_2))=0;

%Total amount including NaN:
[a_all,b_all]=hist(month_all,unique(month_all));
list_all(1:12)=NaN;
for k=1:length(b_all)
    list_all(b_all(k))=a_all(k);        
end

%Cloudcover:
mon_cloudcover=month_all(idx_cloudcover);
[a_cloudcover,b_cloudcover]=hist(mon_cloudcover,unique(mon_cloudcover));
list_cloudcover(1:12)=NaN;
for k=1:length(b_cloudcover)
   list_cloudcover(b_cloudcover(k))=a_cloudcover(k);   
end

%Measurement days:
month_nonNan=month_all(idx_nonNan);          
[a_nonNan,b_nonNan]=hist(month_nonNan,unique(month_nonNan));
list_nonNan(1:12)=NaN;
for k=1:length(b_nonNan)
    list_nonNan(b_nonNan(k))=a_nonNan(k);
end

%%
%For Histogram:
%100%=nonNan: 0cloud+1cloud+2cloud

cloud2_nonNan=list_2./list_nonNan;               
cloud1_nonNan=list_1./list_nonNan;
cloud0_nonNan=list_0./list_nonNan;               

XL(:,1)=cloud2_nonNan;
XL(:,2)=cloud1_nonNan;
XL(:,3)=cloud0_nonNan;

grey =[0.702 0.702 0.702];

%%
%Plot Histogram

figure(12)
set(gcf,'units','normalized','position',[.1 .1 0.5 0.4]);
b2=bar(1:12, XL, 0.5, 'stack');
axis([0 13 0 1])
b2(1).FaceColor = [cm(4,:)];
b2(2).FaceColor = [cm(5,:)];
b2(3).FaceColor = [cm(1,:)];
set(gca, 'XTick', 1:12, 'XTickLabel',{'J','F','M','A','M','J','J','A','S','O','N','D'})    
xlabel('Month')
ylabel('Relative occurrence of observed clouds')
legend('multilayer clouds ', 'single layer clouds', 'no clouds', 'Location','bestoutside')
%suptitle({'Relative occurrence of observed clouds';strxcat('June 2016 - June 2017')},'FontSize',12)

saveas(gcf,strxcat('Plots/9_Visual/VisualHistogram.png'));

%%

clear Angucken combinedtxt f file grey h hText ii lguck newExtents newExtents_cell offset oldExtents old_Extents_cell ...
    percentValues signValues textPostions textPostitions_cell txt width_change a_0 a_1 a_2 a_all a_cloudcover a_nan ...
    a_nonNan lidx_cloudcover lidx_nonNan ax1 b1 b2 b_0 b_1 b_2 b_all b_cloudcover b_nan b_nonNan cloud0 cloud1 cloud1_cover ...
    cloud1_nonNan cloud2 cloud2_cover cloud0_nonNan cloud2_nonNan day_all idx_0 idx_1 idx_2 idx_cloudcover idx_nan ...
    idx_nonNan k lidx_0 lidx_1 lidx_2 lidx_nan list_0 list_2 list_all list_cloudcover list_nan list_nonNan mon_0 mon_1 ... 
    mon_2 mon_cloudcover mon_nan month_all month_nonNan Nanval oldExtents_cell textPostitions textPositions_cell x ...
    Xcolor XH XHc XL XP year_all list_1 textPositions

%%

