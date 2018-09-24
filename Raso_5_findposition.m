
%This program uses the height of a subsaturated layer and finds the radiosonde positon at this heigth.
%This position can be used together with the position of the radar to find the drift of the radiosonde.

%%
%In the paper the layer 1 is the upper most. This equals kchose=4 in the program.
kvec=[1:k];
layervec=fliplr(kvec);
kchose=layervec(layer);

%%
%finding the index of the subsaturated layer: top, bottom, mid.
H_mid=(H_falldown(kchose)+H_fallbeginn(kchose))/2;                   %finding middle point of layer
[minDistance, idx_bottom] = min(abs(Raso.alt-H_falldown(kchose)));   %idx=801
[minDistance, idx_top] = min(abs(Raso.alt-H_fallbeginn(kchose)));    %idx=878
[minDistance, idx_mid] = min(abs(Raso.alt-H_mid));                   %idx=840

%Finding lon and lat:
lon_bottom=Raso.lon(idx_bottom);
lat_bottom=Raso.lat(idx_bottom);
lon_top=Raso.lon(idx_top);
lat_top=Raso.lat(idx_top);
lon_mid=Raso.lon(idx_mid);
lat_mid=Raso.lat(idx_mid);

%Select which height should be used (3 options):
lon2=lon_mid;    %_bottom, _top, _mid
lat2=lat_mid;    %_bottom, _top, _mid

%%
%The position of the town center/radar is:
lon1=11.9208;           %lon= 11° 55' 15"E => 11.9208 E
lat1=78.9233;           %lat= 78° 55' 24"N => 78.9233 N

%%
%Haversine formula:
%taken from https://www.movable-type.co.uk/scripts/latlong.html

R=6371e3;
lambda1=lon1.*pi/180;
lambda2=lon2.*pi/180;
phi1= lat1.*pi/180;         %lat1
phi2= lat2.*pi/180;         %lat2
dphi= phi2-phi1;            %difference lat2-lat1
dlambda= lambda2-lambda1;   %differece lon2-lon1
a=sin(dphi/2).^2+cos(phi1)*cos(phi2)*sin(dlambda/2).^2;
c=2*atan2(sqrt(a),sqrt(1-a));
d=R*c                       %Distance in m

%%
clear lon_bottom lat_bottom lon_top lat_top lon_mid lat_mid H_mid minDistance idx_bottom idx_top idx_mid ...
    layervec kvec kchose lon2 lat2 lon1 lat1 R lambda1 lambda2 dlambda phi1 phi2 dphi a c d 

