
%This program finds the postion at each time => calculation of velocity/ horizontal movement 
%=> advection away from the radiosonde 

if NoRasoNum==0                                %only if a raso exists  

lRaso=length(Raso.N);       %length of Raso
idx=find(~isnan(Raso.lon));     %finds the first index where there in a value. 

try                             %Case i=24: no lat/lon Data
idx_nonnan=idx(1);              %(i=147 => idx_nonnan=10)

%%
%Calculate the time difference and the horizontal distance in between two points => Velocity in this layer.
  
for ii=2:lRaso
    
    dN3(ii)=etime(datevec(Raso.N(ii)),datevec(Raso.N(ii-1)));  %Time difference between two points in sek

    %Haversine formula:
    %taken from https://www.movable-type.co.uk/scripts/latlong.html

    lon2= Raso.lon(ii);             %Position 2=up
    lat2= Raso.lat(ii);             
    lon3=Raso.lon(ii-1);            %Position 3=mid
    lat3= Raso.lat(ii-1);    
    
    R=6371e3;
    lambda1=lon2.*pi/180;
    lambda3=lon3.*pi/180;
    phi1= lat2.*pi/180;         %lat1
    phi3= lat3.*pi/180;         %lat2
    dphi= phi3-phi1;            %difference lat2-lat1
    dlambda= lambda3-lambda1;   %differece lon2-lon1
    a=sin(dphi/2).^2+cos(phi1)*cos(phi3)*sin(dlambda/2).^2;
    c=2*atan2(sqrt(a),sqrt(1-a));
    dhelp=R*c;                                              %Distance in m between two points
   
    d3(ii)=dhelp;
    v3(ii)=d3(ii)/dN3(ii);                                   %wind speed in level ii
    
end

%%
%Find distance away from radar. Assumtion: idx_nonnan is first entry closest to radar

for ii=2:lRaso
    
    dN(ii)=etime(datevec(Raso.N(ii)),datevec(Raso.N(idx_nonnan)));  %Time in sek

    %Haversine formula:
    %taken from https://www.movable-type.co.uk/scripts/latlong.html

    %lon1= Raso.lon(idx_nonnan);         %use for: Distance between start and point ii 
    %lat1= Raso.lat(idx_nonnan);
    lat1=78.9230;                       %Radar position
    lon1=11.9210;                       %Radar position
    lon2= Raso.lon(ii);
    lat2= Raso.lat(ii);
    
    R=6371e3;
    lambda1=lon1.*pi/180;
    lambda2=lon2.*pi/180;
    phi1= lat1.*pi/180;         %lat1
    phi2= lat2.*pi/180;         %lat2
    dphi= phi2-phi1;            %difference lat2-lat1
    dlambda= lambda2-lambda1;   %differece lon2-lon1
    a=sin(dphi/2).^2+cos(phi1)*cos(phi2)*sin(dlambda/2).^2;
    c=2*atan2(sqrt(a),sqrt(1-a));
    d(ii)=R*c;                                              %Distance in m from start   
 
end

%%
%Use windspeed and distance away from radar in order to calculate the time the cloud needed between
%radar and radiosonde.

for ii=2:lRaso
    tadv(ii)=d(ii)./v3(ii);          %Time due to advection in sek   
end
Raso.tadv=tadv';                     %Write the Advection into the Raso struct.

%%
%write in Raso10km struct (shorter)
%for limiting height where we look for multi-layer clouds:
x = Raso.alt;
valueToMatch = hmax*1e3;
% Find the closest value.
[minDifferenceValue, indexAtMin] = min(abs(x - valueToMatch));

Raso10km.tadv=Raso.tadv(1:indexAtMin);
Raso10km.tadv=double(Raso10km.tadv);

catch
end

end
