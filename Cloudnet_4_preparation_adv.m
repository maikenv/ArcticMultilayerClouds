
%This program sorts out some special cases.
%Thereafter the program defines (by using gapmin) where to avarage the Cloudnet data. 

if i==244                                   %8.2.: Cloudnet Data begins at 11:30
    NoCloudnetNum=1;                        %deleted, since no overlap with Raso
    MLC_classification(i).hmax=NaN;                             
    MLC_classification(i).cloud_layers=NaN;
    MLC_classification(i).nocloud_layers=NaN;
    MLC_classification(i).Seeding=NaN;
    MLC_classification(i).fallbeginn=NaN;
    MLC_classification(i).fallend=NaN;   
end

if NoRasoNum==1                             %f there is no Raso
    MLC_classification(i).Zbelow=NaN; 
    MLC_classification(i).Zbetween=NaN;
    MLC_classification(i).Zabove=NaN;
end      

if NoCloudnetNum==1                         %If there is no Cloudnet Data
    MLC_classification(i).hmax=NaN;                 %hmax and all other variables are not evaluated.
    MLC_classification(i).cloud_layers=NaN;
    MLC_classification(i).nocloud_layers=NaN;
    MLC_classification(i).Seeding=NaN;
    MLC_classification(i).fallbeginn=NaN;
    MLC_classification(i).fallend=NaN;
    MLC_classification(i).Zbelow=NaN;
    MLC_classification(i).Zbetween=NaN;
    MLC_classification(i).Zabove=NaN;   
end

if sizeZ(2)<=30                             %i=34,289,290,328
    MLC_classification(i).hmax=NaN;                 %The cloudnet data is only during a short part of the day
    MLC_classification(i).cloud_layers=NaN;
    MLC_classification(i).nocloud_layers=NaN;
    MLC_classification(i).Seeding=NaN;
    MLC_classification(i).fallbeginn=NaN;
    MLC_classification(i).fallend=NaN; 
    MLC_classification(i).Zbelow=NaN;  
    MLC_classification(i).Zbetween=NaN;
    MLC_classification(i).Zabove=NaN;
    disp('This day is deleted since there is not enough Cloudnet data.');
end                                                     
    
try
if numcloud_i<=1 && NoCloudnetNum==0 && NoRasoNum==0 && sizeZ(2)>30          %If there is only one or no cloudlayer
    MLC_classification(i).nocloud_layers=0;   
    MLC_classification(i).Zbelow=NaN;
    MLC_classification(i).Zbetween=NaN;
    MLC_classification(i).Zabove=NaN;
end
catch
end

%%
%in all other cases 

if NoRasoNum==0                              %if there is Raso available  
if NoCloudnetNum==0                          %if Cloudnet is available
if sizeZ(2)>30                               %if Cloudnet is available at right time
if numcloud_i>=2                             %if there are min 2 supersaturated layers
    
    %check if tadv has been calculated and exists.
    ex=isfield(Raso10km,'tadv');
       
    if ex==1
        tadv= Raso10km.tadv;
        tadv(find(tadv==Inf))=NaN;      %case i=2  idx 597 is inf.
        tadv_mean=nanmean(tadv); 
        tadv_mean=double(tadv_mean);
    elseif ex==0                            %case 24
        tadv_mean=0;
    end
    
    %%
                  
    %Finding timeperiod
    [yy mm dd hh minu sek]=datevec(Raso10km.N(1));
    Nbefore = datenum(yy,mm,dd,hh,minu-gap_min,sek+tadv_mean);  %with advection
    %Nbefore = datenum(yy,mm,dd,hh,minu-gap_min,sek);           %without advection

    [yy mm dd hh minu sek]=datevec(Raso10km.N(end));       %Rasolaunch end +30min
    %[yy mm dd hh minu sek]=datevec(Raso10km.N(1));          %Rasolaunch begin +30min
    Nafter = datenum(yy,mm,dd,hh,minu+gap_min,sek+tadv_mean);   %with advection  
    %Nafter = datenum(yy,mm,dd,hh,minu+gap_min,sek);            %without advection

    x = Cloudnet_short.N;
    valueToMatch = Nbefore;
    [minDifferenceValue, indexAtStart] = min(abs(x - valueToMatch));    % Find the closest value

    x = Cloudnet_short.N;
    valueToMatch = Nafter;
    [minDifferenceValue, indexAtEnd] = min(abs(x - valueToMatch));      % Find the closest value

end
end
end
end

%%

clear cloud cloudZ cloudZmean40 cloudZmean402 cloudZmeanhalf cloudZmeanhalf2 h h1 height helpcloud hh hline ...
indexAtMin minDifferenceValue minu mu Nafter_new Nansum ...
Nansum_cloud Nansumnot Nansumnot_cloud Nbefore_new nocloud nocloudZ nocloudZmean40 nocloudZmean402 nocloudZmeanhalf ...
nocloudZmeanhalf2 pos1 reso valueToMatch ZnN x sek mm dd yy yy1 mm1 dd1 ab ac c ...
Nafter_vec Nbefore_vec Y22 kminus k tadv ex extadv

%%
   
    