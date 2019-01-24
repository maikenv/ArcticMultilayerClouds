
function[XL,list_nonNan]=func_4_histogram(MLC_classification, index)

Evaluation_1_calc                               %is needed 

%%
%find month

for k=1:lMLC
    [yy(k) month(k) dd(k)]=datevec(MLC_classification(k).date);
end

%%
%Montly distribution for histogram

%Nan:
mon_Nan=month(idx_Nan);                         %List of month of occurrence
[a_Nan,b_Nan]=hist(mon_Nan,unique(mon_Nan));
list_Nan(1:12)=NaN;
for k=1:length(b_Nan)
    list_Nan(b_Nan(k))=a_Nan(k);                %List of amount per month
end
list_Nan(isnan(list_Nan))=0;                    %for April: there is no NaN

%0cloud:
mon_0cloud=month(idx_0cloud);                   %List of month of occurrence
[a_0cloud,b_0cloud]=hist(mon_0cloud,unique(mon_0cloud));
list_0cloud(1:12)=NaN;
for k=1:length(b_0cloud)
    list_0cloud(b_0cloud(k))=a_0cloud(k);       %List of amount per month
end

%1cloud:
mon_1cloud=month(idx_1cloud);                   %List of month of occurrence
[a_1cloud,b_1cloud]=hist(mon_1cloud,unique(mon_1cloud));
list_1cloud(1:12)=NaN;
for k=1:length(b_1cloud)
    list_1cloud(b_1cloud(k))=a_1cloud(k);       %List of amount per month
end
list_1cloud(isnan(list_1cloud))=0;

%both:
mon_both=month(idx_both);                       %List of month of occurrence
[a_both,b_both]=hist(mon_both,unique(mon_both));
list_both(1:12)=NaN;
for k=1:length(b_both)
    list_both(b_both(k))=a_both(k);             %List of amount per month
end

%nonseed:
mon_nonseed=month(idx_nonseed);                 %List of month of occurrence
[a_nonseed,b_nonseed]=hist(mon_nonseed,unique(mon_nonseed));
list_nonseed(1:12)=NaN;
for k=1:length(b_nonseed)
    list_nonseed(b_nonseed(k))=a_nonseed(k);    %List of amount per month
end
list_nonseed(isnan(list_nonseed))=0;

%only seeding:
mon_onlyseed=month(idx_onlyseed);               %List of month of occurrence
[a_onlyseed,b_onlyseed]=hist(mon_onlyseed,unique(mon_onlyseed));
list_onlyseed(1:12)=NaN;
for k=1:length(b_onlyseed)
    list_onlyseed(b_onlyseed(k))=a_onlyseed(k); %List of amount per month
end

%Amount of all:
month_all=month(index);                         %List of month of occurrence
[a_all,b_all]=hist(month_all,unique(month_all));
list_all(1:12)=NaN;
for k=1:length(b_all)
    list_all(b_all(k))=a_all(k);
end

%Cloudcover:
month_cloudcover=month(idx_cloudcover);           %List of month of occurrence
[a_cloudcover,b_cloudcover]=hist(month_cloudcover,unique(month_cloudcover));
list_cloudcover(1:12)=NaN;
for k=1:length(b_cloudcover)
    list_cloudcover(b_cloudcover(k))=a_cloudcover(k);
end

%measurement days:
month_nonNan=month(idx_nonNan);                    %List of month of occurrence
[a_nonNan,b_nonNan]=hist(month_nonNan,unique(month_nonNan));
list_nonNan(1:12)=NaN;
for k=1:length(b_nonNan)
    list_nonNan(b_nonNan(k))=a_nonNan(k);
end

%%
%For histogram:

onlyseed_nonNan=list_onlyseed./list_nonNan;
nonseed_nonNan=list_nonseed./list_nonNan;
both_nonNan=list_both./list_nonNan; 
cloud1_nonNan=list_1cloud./list_nonNan; 
cloud0_nonNan=list_0cloud./list_nonNan; 

XL(:,1)=nonseed_nonNan;
XL(:,2)=both_nonNan;
XL(:,3)=onlyseed_nonNan;
XL(:,4)=cloud1_nonNan;
XL(:,5)=cloud0_nonNan;

end
