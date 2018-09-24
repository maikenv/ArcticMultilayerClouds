
%This program generates the final histogram plot

mkdir('Plots','11_RC_final');                   %Here the plots are stored
Evaluation_4_RC_calc                            %is needed

%%
%find month

for k=1:lMLC
    [yy(k) month(k) dd(k)]=datevec(MLC_classification(k).date);
end

%%
%monthly distribution for histogram

%NaN:
mon_Nan=month(idx_Nan);           
[a_Nan,b_Nan]=hist(mon_Nan,unique(mon_Nan));
list_Nan(1:12)=NaN;
for k=1:length(b_Nan)
    list_Nan(b_Nan(k))=a_Nan(k);   
end
list_Nan(isnan(list_Nan))=0;            %needed for April: there is no NaN

%0cloud:
mon_0cloud=month(idx_0cloud);           
[a_0cloud,b_0cloud]=hist(mon_0cloud,unique(mon_0cloud));
list_0cloud(1:12)=NaN;
for k=1:length(b_0cloud)
    list_0cloud(b_0cloud(k))=a_0cloud(k);   
end
list_0cloud(isnan(list_0cloud))=0;

%1cloud:
mon_1cloud=month(idx_1cloud);           
[a_1cloud,b_1cloud]=hist(mon_1cloud,unique(mon_1cloud));
list_1cloud(1:12)=NaN;
for k=1:length(b_1cloud)
    list_1cloud(b_1cloud(k))=a_1cloud(k);   
end
list_1cloud(isnan(list_1cloud))=0;

%no multilayer cloud, no single layer cloud:
mon_noML0=month(idx_noML0);           
[a_noML0,b_noML0]=hist(mon_noML0,unique(mon_noML0));
list_noML0(1:12)=NaN;
for k=1:length(b_noML0)
    list_noML0(b_noML0(k))=a_noML0(k);   
end
list_noML0(isnan(list_noML0))=0;

%no multilayer cloud, but single layer cloud:
mon_noML1=month(idx_noML1);          
[a_noML1,b_noML1]=hist(mon_noML1,unique(mon_noML1));
list_noML1(1:12)=NaN;
for k=1:length(b_noML1)
    list_noML1(b_noML1(k))=a_noML1(k); 
end
list_noML1(isnan(list_noML1))=0;

%both:
mon_both=month(idx_both);          
[a_both,b_both]=hist(mon_both,unique(mon_both));
list_both(1:12)=NaN;
for k=1:length(b_both)
    list_both(b_both(k))=a_both(k);   
end
list_both(isnan(list_both))=0;

%nonseed:
mon_nonseed=month(idx_nonseed);           
[a_nonseed,b_nonseed]=hist(mon_nonseed,unique(mon_nonseed));
list_nonseed(1:12)=NaN;
for k=1:length(b_nonseed)
    list_nonseed(b_nonseed(k))=a_nonseed(k);  
end
list_nonseed(isnan(list_nonseed))=0;

%only seeding:
mon_onlyseed=month(idx_onlyseed);          
[a_onlyseed,b_onlyseed]=hist(mon_onlyseed,unique(mon_onlyseed));
list_onlyseed(1:12)=NaN;
for k=1:length(b_onlyseed)
    list_onlyseed(b_onlyseed(k))=a_onlyseed(k);   
end
list_onlyseed(isnan(list_onlyseed))=0;

%Total amount:
month_all=month(index);          
[a_all,b_all]=hist(month_all,unique(month_all));
list_all(1:12)=NaN;
for k=1:length(b_all)
    list_all(b_all(k))=a_all(k);
end

%Cloudcover:
month_cloudcover=month(idx_cloudcover);          
[a_cloudcover,b_cloudcover]=hist(month_cloudcover,unique(month_cloudcover));
list_cloudcover(1:12)=NaN;
for k=1:length(b_cloudcover)
    list_cloudcover(b_cloudcover(k))=a_cloudcover(k);
end

%days of measurements:
month_nonNan=month(idx_nonNan);           
[a_nonNan,b_nonNan]=hist(month_nonNan,unique(month_nonNan));
list_nonNan(1:12)=NaN;
for k=1:length(b_nonNan)
    list_nonNan(b_nonNan(k))=a_nonNan(k);
end

%%
%Histogram

nonseed_nonNan=list_nonseed./list_nonNan;
both_nonNan=list_both./list_nonNan; 
onlyseed_nonNan=list_onlyseed./list_nonNan;
noML1_nonNan=list_noML1./list_nonNan; 
cloud1_nonNan=list_1cloud./list_nonNan; 
noML0_nonNan=list_noML0./list_nonNan; 
cloud0_nonNan=list_0cloud./list_nonNan; 

XL(:,1)=nonseed_nonNan;
XL(:,2)=both_nonNan;
XL(:,3)=onlyseed_nonNan;
XL(:,4)=noML1_nonNan;
XL(:,5)=cloud1_nonNan;
XL(:,6)=noML0_nonNan;
XL(:,7)=cloud0_nonNan;

txt3={['Only non-seeding MLCs ']; ...
    ['Both seeding and non-seeding MLCs ']; ...                   
    ['Only seeding MLCs ']; ...                   
    ['MLC by radiosounding, but single-layer cloud by radar']; ...
    ['Single-layer clouds by radiosounding ']; ...
    ['MLC by radiosounding, but not even single-layer cloud by radar ']; ...
    ['No cloud by radiosounding ']};                
       
%%
%Plot histogram

grey =[0.702 0.702 0.702];
fs=12;                                       %common font size

figure(15)
set(gcf,'units','normalized','position',[.1 .1 0.6 0.45]);
b2=bar(1:12, XL*1e2, 0.5, 'stack');
axis([0 13 0 100])
b2(1).FaceColor = [cm(7,:)];
b2(2).FaceColor = [cm(2,:)];
b2(3).FaceColor = [cm(3,:)];
b2(4).FaceColor = [colordg(8)];
b2(5).FaceColor = [cm(5,:)];
b2(6).FaceColor = [colordg(21)];
b2(7).FaceColor = [cm(1,:)];
set(gca, 'XTick', 1:12, 'XTickLabel',{'J','F','M','A','M','J','J','A','S','O','N','D'})    
xlabel('Month')
ylabel('Relative occurrence of clouds in %')
legend(txt3,'Location','bestoutside','FontSize',fs);
%suptitle({strxcat('Relative occurrence of clouds between June 2016 - June 2017, r=',Rsize,'\mum')},'FontSize',12)
set(gca,'FontSize',fs);
legend boxoff

fig = gcf;
fig.PaperPositionMode = 'auto';
fig.PaperSize =  [30.5 14];
saveas(gcf,strxcat('Plots/11_RC_final/RC_histogram_',name,'.pdf'));


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
    nonseed_nonNan

%%





