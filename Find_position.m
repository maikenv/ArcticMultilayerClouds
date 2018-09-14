
ncfile='NYA-RS-01_2_RS92-GDP_002_20161103T120000_1-000-001.nc';

ncdisp(ncfile);
lon  = ncread(ncfile,'lon');       %degree east
lat  = ncread(ncfile,'lat');        %degree north
alt  = ncread(ncfile,'alt');        %in m

%Find position of 3,85km= 3850m and 4,26km=4260m
[minDistance, idx1] = min(abs(alt-3850)); %idx=801
[minDistance, idx2] = min(abs(alt-4260)); %idx=878
[minDistance, idx3] = min(abs(alt-4055)); %idx=840

%Find lon and lat:
lon(801)
lat(801)
lon(878)
lat(878)
lon(840)
lat(840)


