
%This program creates the Histogram belonging to the Raso-Pie-Plot

mkdir('Plots','8_Raso'); 

%%
%for including all three sizes r=100,200,400:

load(strxcat('MLC_classification_r100',ending,'.mat')) 
MLC_classification100=MLC_classification;
[XL100] = func_4_histogram(MLC_classification100, index);

load(strxcat('MLC_classification_r200',ending,'.mat')) 
MLC_classification200=MLC_classification;
[XL200] = func_4_histogram(MLC_classification200, index);

load(strxcat('MLC_classification_r400',ending,'.mat'))
MLC_classification400=MLC_classification;         
[XL400, listdays] = func_4_histogram(MLC_classification400, index);

XLall(:,1,:)=[XL100];
XLall(:,2,:)=[XL200];
XLall(:,3,:)=[XL400];

NumStacksPerGroup = 3;                      %Radii
NumStackElements = 5;                       %Categories
NumGroupsPerAxis = 12;                      %Months
%groupLabels = {'J','F','M','A','M','J','J','A','S','O','N','D'};
groupLabels = {'J=21d','F=11d','M=22d','A=30d','M=27d','J=23d','J=23d','A=21d','S=24d','O=25d','N=28d','D=23d'};

%%
%Plot
fs=12;                              %common fontsize
figure(8)
%set(gcf,'units','normalized','position',[.5 .15 0.5 0.4]);
set(gcf,'units','normalized','position',[.5 .15 0.7 0.5]);

b2=plotBarStackGroupsM(XLall*1e2, groupLabels);
axis([0 13 0 100]);
xtickangle(45)
for ij=1:3
    b2(ij,1).FaceColor = [cm(7,:)];
    b2(ij,2).FaceColor = [cm(2,:)];
    b2(ij,3).FaceColor = [cm(3,:)];
    b2(ij,4).FaceColor = [cm(5,:)];
    b2(ij,5).FaceColor = [cm(1,:)];
end
xlabel('Month and number of days in d')
ylabel('Relative occurrence in %')
h1=legend(  'Only non-seeding subsaturated layer', ...
            'Both seeding and non-seeding subsaturated layer', ...
            'Only seeding subsaturated layers', ...
            'Only one single supersaturated layer',...
            'No supersaturated layer',...
            'Location','bestoutside');
set(gca,'FontSize',fs);
set(h1,'FontSize',fs);
legend boxoff

fig = gcf;
fig.PaperPositionMode = 'auto';
fig.PaperSize =  [33.5 16];

saveas(gcf,strxcat('Plots/8_Raso/Histogram_Raso_radii',name,'.png'));

%%

clear a_0cloud a_1cloud a_all a_both a_cloudcover a_Nan a_nonNan a_nonseed a_onlyseed Anz_DateNan ...
    MLC_dateRaso ax1 b1 b2 b_0cloud b_1cloud b_all b_both b_cloudcover b_Nan b_nonNan b_nonseed ...
    b_onlyseed both both_cover cloud0 cloud1 cloud1_cover cloud1_nonNan grey h list_0cloud list_1cloud ...
    list_all list_both list_cloudcover list_Nan list_nonNan list_nonseed list_onlyseed mon_0cloud ...
    mon_1cloud mon_both mon_Nan mon_nonseed mon_onlyseed month_all month_cloudcover month_nonNan ...
    multilayer_nonNan Nanval nonseed nonseed_cover onlyseed onlyseed_cover XH XHc XL x yy month dd ...
    Anz_0cloud Anz_1cloud Anz_both Anz_cloudcover Anz_Nan Anz_nonNan Anz_nonseed Anz_onlyseed both_nonNan ...
    cloud0_nonNan idx_0cloud idx_1cloud idx_both idx_cloudcover idx_Nan idx_nonNan idx_nonseed idx_onlyseed ...
    k nonseed_nonNan onlyseed_nonNan XLc fs ans fig h1 idx_0 groupLabels ij MLC_classification100 ...
    MLC_classification50 MLC_classification150  NumGroupsPerAxis NumStackElements NumStacksPerGroup XL400 ...
    XL100 XL200 XLall listdays

%%

