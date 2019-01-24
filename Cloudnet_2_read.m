
%This program reads the Radar(Cloudnet) data. The path to the data is specified at the beginning of the
%in the main program.

clear Cloudnet NoCloudnetNum

Cloudnet_long.number=i;

try                             %only if Cloudnetfile exists
    
%open file:
file=strxcat(yyyy(i),Monthfile(i,:),Dayfile(i,:),'_ny-alesund_categorize.nc');
ncid=netcdf.open(file,'NC_NOWRITE');

yyyyf=double(yyyy(i));
mmf=str2num(Monthfile(i,:));
ddf=str2num(Dayfile(i,:));       

varid = netcdf.inqVarID(ncid,'time');
time = double(netcdf.getVar(ncid,varid));
Cloudnet_long.N=datenum(yyyyf,mmf,ddf,time,0,0);
Cloudnet_long.date=datestr(Cloudnet_long.N(1));

%height in m
varid = netcdf.inqVarID(ncid,'height');
height = double(netcdf.getVar(ncid,varid));
Cloudnet_long.height=height;

%Radar reflectivity factor in dBz:
varid = netcdf.inqVarID(ncid,'Z');
Z = double(netcdf.getVar(ncid,varid));
Z(Z == -999) = NaN;
Cloudnet_long.Z=Z;

%Radar sensitivity in dBz:
varid = netcdf.inqVarID(ncid,'Z_sensitivity');
Zsens = double(netcdf.getVar(ncid,varid));
Cloudnet_long.Zsens=Zsens;

%Radar sensitivity in dBz:
varid = netcdf.inqVarID(ncid,'radar_gas_atten');
gasatten = double(netcdf.getVar(ncid,varid));
Cloudnet_long.gasatten=gasatten;

%Attenuated backscatter coefficient in m-1 sr-1
varid = netcdf.inqVarID(ncid,'beta');
beta = double(netcdf.getVar(ncid,varid));
Cloudnet_long.beta=beta;

%Doppler velocity in m s-1
v=ncread(file, 'v');             
Cloudnet_long.v=v;

%Doppler spectral width in m s-1 
width=ncread(file, 'width');             
Cloudnet_long.width=width;

%category_bits
category_bits=ncread(file, 'category_bits');             
Cloudnet_long.category=category_bits;

%quality_bits
quality_bits=ncread(file, 'quality_bits');             
Cloudnet_long.quality=quality_bits;

%model_height for temperature
model_height=ncread(file, 'model_height');             
Cloudnet_long.model_height=model_height;

temperature=ncread(file, 'temperature');             
Cloudnet_long.temperature=temperature;

netcdf.close(ncid)

%%
%make Cloudnet smaller, to hmax.

%for limiting height where we look for multi-layer clouds:
x = Cloudnet_long.height;
valueToMatch = hmax*1e3;
[minDifferenceValue, indexAtMin] = min(abs(x - valueToMatch));          % Find the closest value.

Cloudnet.number=Cloudnet_long.number;
Cloudnet.N=Cloudnet_long.N;
Cloudnet.date=Cloudnet_long.date;
Cloudnet.height=Cloudnet_long.height(1:indexAtMin,:);
Cloudnet.Z=Cloudnet_long.Z(1:indexAtMin,:);
Cloudnet.Zsens=Cloudnet_long.Zsens(1:indexAtMin,:);
Cloudnet.beta=Cloudnet_long.beta(1:indexAtMin,:);
Cloudnet.gasatten=Cloudnet_long.gasatten(1:indexAtMin,:);
Cloudnet.v=Cloudnet_long.v(1:indexAtMin,:);
Cloudnet.width=Cloudnet_long.width(1:indexAtMin,:);
Cloudnet.category=Cloudnet_long.category(1:indexAtMin,:);
Cloudnet.quality=Cloudnet_long.quality(1:indexAtMin,:);
Cloudnet.model_height=Cloudnet_long.model_height;
Cloudnet.temperature=Cloudnet_long.temperature;

NoCloudnetNum=0;                                %if Cloudnet exists: NoCloudnetNum=0

catch                                           %if no Cloudnet exitst
    Cloudnet.number=Cloudnet_long.number;
    Cloudnet.N=NaN;
    Cloudnet.date=NaN;
    Cloudnet.height=NaN;
    Cloudnet.Z=NaN;
    Cloudnet.Zsens=NaN;
    Cloudnet.beta=NaN;
    Cloudnet.gasatten=NaN;
    Cloudnet.v=NaN;
    Cloudnet.width=NaN;
    Cloudnet.category=NaN;
    Cloudnet.quality=NaN;
    Cloudnet.model_height=NaN;
    Cloudnet.temperature=NaN;
    
    NoCloudnetNum=1;                            %if no Cloudnet exitst: NoCloudnetNum=1
    disp('no Cloudnet');
    
end


%%

clear quality_bits minDifferenceValue valueToMatch x last mmf ddf yyyyf ncid time v Z width varid ...
   beta Cloudnet_long indexAtMin category_bits model_height temperature height lon lat Zsens gasatten





       
        
        