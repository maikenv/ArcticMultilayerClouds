
function[XL]=func_5_histogram(MLC_classification, index)


Evaluation_4_RC_calc 

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
if length(list_both)>=13                %strange thing happens at 100MHP_WC
    list_both=list_both(1:12);
end

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

end
