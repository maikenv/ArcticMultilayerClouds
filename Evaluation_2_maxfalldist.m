
%This program evaluated when the longest seeding case occurrs

%%
%finding max amount of nocloud layers 
for k=1:lMLC
    nocloud_max(k)=MLC_classification(k).nocloud_layers;
end
nocloud_max=nanmax(nocloud_max);

%Calculate fall distance:
for k=1:lMLC
    try
    for kk=1:nocloud_max
    MLC_classification(k).falldist(kk)=MLC_classification(k).fallbeginn(kk)-MLC_classification(k).fallend(kk);
    end
    catch
    end
end

%Consider only fall distance if seeding is possible
for k=1:lMLC
    try
    for kk=1:nocloud_max
        if MLC_classification(k).Seeding(kk)==0
            MLC_classification(k).falldist(kk)=NaN;
        end
    end
    catch
    end
end

%Finding maximal fall height

for k=1:lMLC
    falldist_max(k) =nanmax(MLC_classification(k).falldist);
end

[falldist_max idx_max]=nanmax(falldist_max);

%Display max fall distance, where seeding occurrs. And display number i:
falldist_max
idx_max
MLC_classification(idx_max).date

%%

clear idx_max falldist_max nocloud_max k kk ans

%%
























