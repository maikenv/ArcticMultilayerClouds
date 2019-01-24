
%In this program the evaluation of the Cloudnet data is done.

clear nocloudZ_Zeit cloudZ_Zeit cloudZmeanhalf3 

if NoRasoNum==0                                %only if Raso is available  
if NoCloudnetNum==0                            %only if Cloudnet exists
if sizeZ(2)>30                                 %only if there is min one cloudless laye
if numcloud_i>=2                               %only if min 1 nocloudlayer (=Auswertung(i).layers_nocloud>=1)   

%%
%For evaluation of the subsaturated layer:

%This part is needed, since Cloudixd contains the indicies of Raso and this has to be converted to
%cloudnet indicies:

for k=1:layers
    x = Cloudnet_short.height;
    valueToMatch = Cloudixd.height_sub_bottom(k);
    [minDifferenceValue, indexAtBottomNoCloud(k)] = min(abs(x - valueToMatch));   %find the closest value

    x = Cloudnet_short.height;
    valueToMatch = Cloudixd.height_sub_top(k);
    [minDifferenceValue, indexAtTopNoCloud(k)] = min(abs(x - valueToMatch));      %find the closest value
    
end

%%

%Z either NaN or mean value:

for k=1:layers                                              %go through subsaturated layers
    if indexAtBottomNoCloud(k)+5 > indexAtTopNoCloud(k)
        indexend_noCloud(k)=indexAtTopNoCloud(k);
    else
        indexend_noCloud(k)=indexAtBottomNoCloud(k)+5;
    end
    nocloud(k).ZNan(:,:)=Cloudnet_short.Z(indexAtBottomNoCloud(k):indexend_noCloud(k),indexAtStart:indexAtEnd);
    Nansum(k)=sum(sum(isnan(nocloud(k).ZNan)));
    Nansumnot(k)=sum(sum(~isnan(nocloud(k).ZNan)));
end

%%
%Check if there is more NaN or non-NaN in the subsaturated layers

for k=1:layers
  
    if Nansum(k)>Nansumnot(k)                %more Nan than NotNan
        nocloudZmeanhalf(k)=NaN;
    
    elseif Nansum(k)<=Nansumnot(k)           %more NotNan than Nan
        nocloud(k).ZnNhalf(:,:)=Cloudnet_short.Z(indexAtBottomNoCloud(k):indexend_noCloud(k),indexAtStart:indexAtEnd);
        nocloudZ(:)=nanmean(nocloud(k).ZnNhalf,1);
        nocloudZmeanhalf(k)=nanmean(nocloudZ); 
    end
end

nocloudZ_Zeit=nocloudZmeanhalf; %IMP OUTPUT
nocloudZ_Zeit

% Convert NaN into: 0=no cloud, 1=cloud (inside subsaturated layer)

for k=1:layers
    if isnan(nocloudZmeanhalf(k))
        nocloudZmeanhalf2(k)=0;                     %if Nan, then =0 =no cloud
    elseif ~isnan(nocloudZmeanhalf(k))
         nocloudZmeanhalf2(k)=1;                    %if not Nan, then =1 =cloud
    end
end

MLC_classification(i).Zbetween=nocloudZmeanhalf2;


%%
%In supersaturated layers:

lCloud=length(Cloudixd.height_super_bottom);        %lCloud= Amount of supersaturated layers

%Find indicies of cloudnet (taken from Raso=Cloudixd), where there is supersaturation:

for k=1:lCloud
    x = Cloudnet_short.height;
    valueToMatch = Cloudixd.height_super_bottom(k);
    [minDifferenceValue, indexAtBottomCloud(k)] = min(abs(x - valueToMatch));   %find the closest value

    x = Cloudnet_short.height;
    valueToMatch = Cloudixd.height_super_top(k);
    [minDifferenceValue, indexAtTopCloud(k)] = min(abs(x - valueToMatch));      %find the closest value
    
    %find index at bottom+100m
    x = Cloudnet_short.height;
    valueToMatch = Cloudixd.height_super_bottom(k)+100;
    [minDifferenceValue, indexAtBottomCloud100(k)] = min(abs(x - valueToMatch));%find the closest value
    
    %if index of bottom+100 is bigger than index of top, then use the index of top. 
    if indexAtBottomCloud100(k)>indexAtTopCloud(k)
        indexAtBottomCloud100(k)=indexAtTopCloud(k);
    end
    
end

%%
%Count NaN anod non-NaN in supersaturated layers: 

for k=1:lCloud                                                  %in supersaturated layers   
        cloud(k).ZNan(:,:)=Cloudnet_short.Z(indexAtBottomCloud(k):indexAtBottomCloud100(k),indexAtStart:indexAtEnd);
        Nansum_cloud(k)=sum(sum(isnan(cloud(k).ZNan)));         %Amount of NaN in supersaturated layers 
        Nansumnot_cloud(k)=sum(sum(~isnan(cloud(k).ZNan)));     %Amount of non-NaN in supersaturated layers
end 

%Check if there is more NaN or non-NaN in supersaturated layers:
for k=1:lCloud
    if Nansum_cloud(k)>Nansumnot_cloud(k)                   %more NaN than non-NaN
        cloudZmeanhalf(k)=NaN;
    elseif Nansum_cloud(k)<=Nansumnot_cloud(k)              %more non-NaN than Nan
        helpcloud=Cloudnet_short.Z(indexAtBottomCloud(k):indexAtBottomCloud100(k),indexAtStart:indexAtEnd);
        cloudZ(:)=nanmean(helpcloud,1);
        cloudZmeanhalf(k)=nanmean(cloudZ);
    end 
end

cloudZ_Zeit=cloudZmeanhalf; %IMP OUTPUT
cloudZ_Zeit
%Convert NaN into 0=no cloud 1=cloud in supersaturated layer

for k=1:lCloud
    if isnan(cloudZmeanhalf(k))
        cloudZmeanhalf2(k)=0;                     %if Nan, then =0 =no cloud 
    elseif ~isnan(cloudZmeanhalf(k))
         cloudZmeanhalf2(k)=1;                    %if not Nan, then =1 =cloud
    end
end

MLC_classification(i).Zabove=cloudZmeanhalf2;

%%
MLC_classification(i).Zbelow=MLC_classification(i).Zabove;
MLC_classification(i).Zbelow(:)=3;

for k=1:lCloud                                              %all supersaturated layers
    idxTop(k)=indexAtTopCloud(k);
    last=0;
    
    if indexAtTopCloud(k)==indexAtBottomCloud(k)            %case 359
        cloud(k).ZNan2=Cloudnet_short.Z(indexAtBottomCloud(k):indexAtTopCloud(k),indexAtStart:indexAtEnd);
        Nansum_cloud(k)=sum(sum(isnan(cloud(k).ZNan2)));    %Amount of NaN in supersaturated layers 
        Nansumnot_cloud(k)=sum(sum(~isnan(cloud(k).ZNan2)));%Amount of non-NaN in supersaturated layers 
        
        if Nansum_cloud(k)>Nansumnot_cloud(k)               %more NaN than non-NaN
            cloudZmeanhalf3(k)=NaN;                         %write provisoric =no cloud (that can be rewriteted in the next step)                                               
        elseif Nansum_cloud(k)<=Nansumnot_cloud(k)          %more non-NaN than NaN
            helpcloud=Cloudnet_short.Z(indexAtBottomCloud(k):indexAtTopCloud(k),indexAtStart:indexAtEnd);
            cloudZ(:)=nanmean(helpcloud,1);
            cloudZmeanhalf3(k)=nanmean(cloudZ);             %if a cloud is found                                       
        end 
        
    else
    while idxTop(k)>indexAtBottomCloud(k)                   %only as long as index at searchbeginning is bigger than the cloudbottom
        idxBot(k)=idxTop(k)-5;
        if idxBot(k)<=indexAtBottomCloud(k)                 %if lower border is reached 
            idxBot(k)=indexAtBottomCloud(k);
            %disp('last');
            last=1;
            idxTop(k);
        end
        
        cloud(k).ZNan2=Cloudnet_short.Z(idxBot(k):idxTop(k),indexAtStart:indexAtEnd);
        Nansum_cloud(k)=sum(sum(isnan(cloud(k).ZNan2)));    %Amount of NaN in supersaturated layer 
        Nansumnot_cloud(k)=sum(sum(~isnan(cloud(k).ZNan2)));%Amount of non-NaN in supersaturated layer 
        
        if Nansum_cloud(k)>Nansumnot_cloud(k)               %more Nan than non-NaN
            cloudZmeanhalf3(k)=NaN;                         %write provisoric no cloud. There is a possibility that this will be changed in the next step. 
            if last==0                                      %if it is not the last round
                idxTop(k)=idxTop(k)-1;                      %if there is no cloud, then go to next part and repeat
            else                                            %if it is the last round
                idxTop(k)=idxBot(k);
            end                                             %again from idxBot
       
        elseif Nansum_cloud(k)<=Nansumnot_cloud(k)          %more non-Nan than NaN
            helpcloud=Cloudnet_short.Z(idxBot(k):idxTop(k),indexAtStart:indexAtEnd);
            cloudZ(:)=nanmean(helpcloud,1);
            cloudZmeanhalf3(k)=nanmean(cloudZ); %IMP OUTPUT %if a cloud is found, then end.
            break                                           %end: go to k=k+1
        end 
        
    end 
    end 
end

cloudZmeanhalf3
%%
%Convert NaN into 0=no cloud, 1=cloud in lowest supersaturated layer

for k=1:lCloud
    if isnan(cloudZmeanhalf3(k))
        cloudZmeanhalf3(k)=0;                     %if NaN, then =0 =no cloud
    elseif ~isnan(cloudZmeanhalf3(k))
         cloudZmeanhalf3(k)=1;                    %if non-NaN, then =1 =cloud
    end
end

MLC_classification(i).Zbelow=cloudZmeanhalf3;
MLC_classification(i).Zbelow=MLC_classification(i).Zbelow(1:end-1); %top cloud is not needed
MLC_classification(i).Zabove=MLC_classification(i).Zabove(2:end);   %cloud below is not needed

end
end
end
end

%%
clear cloud cloudZ cloudZmean40 cloudZmean402 cloudZmeanhalf cloudZmeanhalf2 h h1 height helpcloud hh hline ...
    indexAtMin minDifferenceValue minu mu Nafter_new Nansum ...
    Nansum_cloud Nansumnot Nansumnot_cloud Nbefore_new nocloud nocloudZ nocloudZmean40 nocloudZmean402 nocloudZmeanhalf ...
    nocloudZmeanhalf2 pos1 reso valueToMatch ZnN x sek mm dd yy yy1 mm1 dd1 ab ac c ...
    Nafter_vec Nbefore_vec Y22 kminus k indexAtBottomCloud100 ...
    idxTop idxBot last indexend_noCloud ans Anz_0 %...
    %nocloudZ_Zeit cloudZ_Zeit cloudZmeanhalf3 

%%

