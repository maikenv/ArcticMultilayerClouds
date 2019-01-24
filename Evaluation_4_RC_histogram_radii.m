
%This program generates the final histogram plot

mkdir('Plots','11_RC_final');                   %Here the plots are stored

%%
%for including all three sizes r=50,100,150:

load(strxcat('MLC_classification_r100MHP_WC.mat')) 
MLC_classification100=MLC_classification;
[XL100] = func_5_histogram(MLC_classification100, index);

load(strxcat('MLC_classification_r200MHP_WC.mat')) 
MLC_classification200=MLC_classification;
[XL200] = func_5_histogram(MLC_classification200, index);

load(strxcat('MLC_classification_r400MHP_WC.mat'))
MLC_classification400=MLC_classification;         
[XL400] = func_5_histogram(MLC_classification400, index);

XLall(:,1,:)=[XL100];
XLall(:,2,:)=[XL200];
XLall(:,3,:)=[XL400];

%%

NumStacksPerGroup = 3;                      %Radii
NumStackElements = 7;                       %Categories
NumGroupsPerAxis = 12;                      %Months
%groupLabels = {'J','F','M','A','M','J','J','A','S','O','N','D'};
groupLabels = {'J=21d','F=11d','M=22d','A=30d','M=27d','J=23d','J=23d','A=21d','S=24d','O=25d','N=28d','D=23d'};

txt3={['Only non-seeding MLCs ']; ...
    ['Both seeding and non-seeding MLCs ']; ...                   
    ['Only seeding MLCs ']; ...                   
    ['MLC by radiosounding, but single-layer cloud by radar']; ...
    ['Single-layer clouds by radiosounding ']; ...
    ['MLC by radiosounding, but not even single-layer cloud by radar ']; ...
    ['No cloud by radiosounding ']};                
       
%%
%Plot histogram
fs=12;                                       %common font size

figure(15)
%set(gcf,'units','normalized','position',[.1 .1 0.6 0.45]);
set(gcf,'units','normalized','position',[.5 .15 0.7 0.5]);

b2=plotBarStackGroupsM(XLall*1e2, groupLabels);
axis([0 13 0 100]);
xtickangle(45)

for ij=1:3
    b2(ij,1).FaceColor = [cm(7,:)];
    b2(ij,2).FaceColor = [cm(2,:)];
    b2(ij,3).FaceColor = [cm(3,:)];
    b2(ij,4).FaceColor = [colordg(8)];
    b2(ij,5).FaceColor = [cm(5,:)];
    b2(ij,6).FaceColor = [colordg(21)];
    b2(ij,7).FaceColor = [cm(1,:)];
end
xlabel('Month');
ylabel('Relative occurrence in %');
legend(txt3,'Location','bestoutside','FontSize',fs);
set(gca,'FontSize',fs);
legend boxoff

fig = gcf;
fig.PaperPositionMode = 'auto';
%fig.PaperSize =  [30.5 14];
fig.PaperSize =  [34 16];

saveas(gcf,strxcat('Plots/11_RC_final/RC_histogram_radii',name,'.pdf'));


%%

clear a_0cloud a_1cloud a_all a_both a_cloudcover a_Nan a_noML0 a_noML1 a_nonNan a_nonseed a_onlyseed ...
    ans Anz_0cloud Anz_1cloud Anz_2cloud Anz_34 Anz_both Anz_cloudcover Anz_Nan Anz_noML Anz_noML0 ...
    Anz_noML1 Anz_nonNan Anz_nonseed Anz_nonseeding Anz_nonseeding_help Anz_onlyseed Anz_seeding ...
    Anz_seeding_help Anz_trenn MLC_cloudlayers MLC_hmax b2 b_0cloud b_1cloud b_all b_both ...
    b_cloudcover b_Nan b_noML0 b_noML1 b_nonNan b_nonseed b_onlyseed both_nonNan cloud0_nonNan ...
    cloud1_nonNan fig fs grey idx_0cloud idx_1cloud idx_2cloud idx_both idx_cloudcover idx_Nan ...
    idx_noML idx_noML0 idx_noML1 idx_nonNan idx_nonseed idx_nonseeding idx_onlyseed idx_seeding ...
    kk k list_0cloud list_1cloud list_all list_both list_cloudcover list_Nan list_noML0 list_noML1 ...
    list_nonNan list_nonseed list_onlyseed lS mon_0cloud mon_1cloud mon_both mon_Nan mon_noML0 ...
    mon_noML1 mon_nonseed mon_onlyseed month_all month_cloudcover month_nonNan noML0_nonNan ...
    noML1_nonNan onlyseed_nonNan SeedingS sum_34 txt txt3 XL yy Zcloudabove Zcloudbelow ...
    nonseed_nonNan ans groupLabels ij MLC_classification100 MLC_classification150 MLC_classification50 ...
    NumGroupsPerAxis NumStackElements NumStacksPerGroup XL50 XL100 XL150 XLall

%%





