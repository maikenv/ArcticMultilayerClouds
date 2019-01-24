
%This program makes the Cloudnet structure smaller. For this only the time period that is needed is
%saved in the structure Cloudnet_short. This reduces the size from 492x2875 to 492x481 datatpoints.
%This will probably make the further evaluation a bit faster in computing time. 

clear Cloudnet_short

%Here the time for the shortend Cloudnet is defined [h]
timeStart=9;
timeEnd=13;

if i==344                               %Special case 19.5.: Raso at 16:51
    timeStart=15;
    timeEnd=19;
end

%%

if NoCloudnetNum==0                %Only if Cloudnetfile exists

    %Make Cloudnet. Struct smaller:

    [yy mm dd]=datevec(Cloudnet.N(1));

    %for limiting height where we look for multi-layer clouds:
    x = Cloudnet.N;
    valueToMatch = datenum(yy,mm,dd,timeStart,00,00);
    % Find the closest value.
    [minDifferenceValue, indexAtStart] = min(abs(x - valueToMatch));

    %for limiting height where we look for multi-layer clouds:
    x = Cloudnet.N;
    valueToMatch = datenum(yy,mm,dd,timeEnd,00,00);
    % Find the closest value.
    [minDifferenceValue, indexAtEnd] = min(abs(x - valueToMatch));

    Cloudnet_short.number=Cloudnet.number;
    Cloudnet_short.N=Cloudnet.N(indexAtStart:indexAtEnd);
    Cloudnet_short.date=datestr(Cloudnet_short.N(1));
    Cloudnet_short.height=Cloudnet.height(:);
    Cloudnet_short.Z=Cloudnet.Z(:,indexAtStart:indexAtEnd); 
    Cloudnet_short.Zsens=Cloudnet.Zsens;
    Cloudnet_short.beta=Cloudnet.beta(:,indexAtStart:indexAtEnd);
    Cloudnet_short.gasatten=Cloudnet.gasatten(:,indexAtStart:indexAtEnd);
    Cloudnet_short.v=Cloudnet.v(:,indexAtStart:indexAtEnd);
    Cloudnet_short.width=Cloudnet.width(:,indexAtStart:indexAtEnd);

    sizeZ=size(Cloudnet_short.Z);           %to check if cloudnet is long enough/covers time of Raso
    
end                 

%%

%clear indexAtEnd indexAtStart 
clear minDifferenceValue valueToMatch x




