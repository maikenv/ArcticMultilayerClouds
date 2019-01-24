
%This file reads the Raso data. 

%The Raso data is stored in different folders and is given in different dataformats (.nc and .tab). 
%Therefore the data has to be treated different depending on which day 'i' it is. Regardless how the
%data is red/treated, the output of this file is a Raso-struct containing the important data. The 
%Raso-struct contains the following: 
%Raso.number        %=i
%Raso.date          %=Start time of radiosounding ['day-month-year hh:mm:sek']
%Raso.alt           %=Altitude [m] Vector
%Raso.N             %=Matlab datetime Vector 
%Raso.tempK         %=Temperature [K] Vector
%Raso.press         %=Pressure in SI [Pa] Vector
%Raso.RHl           %=Relative Humidity (RH) regarding liquid [%] Vector
%Raso.RHi           %=RH regarding ice [%] Vector 
%Raso.RHmax         %=either RHl or RHi, depending on which of those two is the highest. Vector
%Any other kind of data can be used. Thereby this file needs to be replaced by a file that reads the 
%data of a given day 'i' (each day only 1 radiosounding), converts it to SI-units and puts it into a 
%Raso.-struct. 
%The variable NoRasoNum must to be defined as =0, unless no radisounding exists for this day 
%(then NoRasoNum=1). 
%Note that there are a few cases treated differently.

clear NoRasoNum Raso

NoRasoNum=0;       %NoRasoNum=0: a radiosounding exists, NoRasoNum=1=no raso exists for this day i. 


if i<206                    %June 2016 - Dez 2016
    Raso.number=i;
    addpath('Inputdata/Raso2016/');

    try         %trys to read the following file
    file=strxcat('NYA-RS-01_2_RS92-GDP_002_',yyyy(i),Monthfile(i,:),Dayfile(i,:),'T120000_1-000-001.nc');
   
    %Starttime:
    starttime = ncreadatt(file,'/','g.Ascent.StartTime');   
    Rasoyear=str2num(starttime(1:4));
    Rasomonth=str2num(starttime(6:7));
    Rasoday=str2num(starttime(9:10));
    Rasohour=str2num(starttime(12:13));
    Rasomin=str2num(starttime(15:16));
    Rasosek=str2num(starttime(18:19));

    %Timestep
    time=ncread(file,'time');
    timestep=double(time);
    
    %Rasotime=Starttime+Timestep:
    Raso.N=datenum(Rasoyear,Rasomonth,Rasoday,Rasohour,Rasomin,Rasosek+timestep);
    Raso.date=datestr(Raso.N(1));

    %Reading the Raso variables:   
    alt  = ncread(file, 'alt');         %Altitude in m
    temp = ncread(file, 'temp');        %Temp in K          
    press= ncread(file, 'press');       %Pressure in hPa 
    RHl  = ncread(file, 'rh');          %RHl in 1
    lon  = ncread(file, 'lon');         %degree east
    lat  = ncread(file, 'lat');         %degree north
    
    %Convert in SI: 
    Raso.alt=alt;
    Raso.tempK=temp;
    Raso.press=press*1e2;
    Raso.RHl=RHl.*100.0;
    Raso.lon=lon;
    Raso.lat=lat;
    
    %display Raso Date:
    disp(strxcat('Raso start time: ',Raso.date));
    
    catch                   %if reading of the file did not work, then there is no raso available for this day.
        disp('no Raso')
        NoRasoNum=1;
    end      
    
elseif i>=206 &&  i<296     %Jan, Feb, March 2017
    
    Raso.number=i;
    addpath('Inputdata/Raso2017_JanFebMarch/');
    
    try
    file=strxcat('NYA-RS-01_2_RS92-GDP_002_',yyyy(i),Monthfile(i,:),Dayfile(i,:),'T120000_1-000-001.nc');
    
    %Starttime:
    starttime = ncreadatt(file,'/','g.Ascent.StartTime');   
    Rasoyear=str2num(starttime(1:4));
    Rasomonth=str2num(starttime(6:7));
    Rasoday=str2num(starttime(9:10));
    Rasohour=str2num(starttime(12:13));
    Rasomin=str2num(starttime(15:16));
    Rasosek=str2num(starttime(18:19));

    %Timestep
    time=ncread(file,'time');
    timestep=double(time);
    
    %Rasotime=Starttime+Timestep:
    Raso.N=datenum(Rasoyear,Rasomonth,Rasoday,Rasohour,Rasomin,Rasosek+timestep);
    Raso.date=datestr(Raso.N(1));

    %Reading the Raso variables:   
    alt  = ncread(file, 'alt');         %Altitude in m
    temp = ncread(file, 'temp');        %Temp in K          
    press= ncread(file, 'press');       %Pressure in hPa 
    RHl  = ncread(file, 'rh');          %RHl in 1
    lon  = ncread(file, 'lon');         %degree east
    lat  = ncread(file, 'lat');         %degree north
    
    %Convert in SI: 
    Raso.alt=alt;
    Raso.tempK=temp;
    Raso.press=press*1e2;
    Raso.RHl=RHl.*100.0;
    Raso.lon=lon;
    Raso.lat=lat;   
    
    %display Raso Date:
    disp(strxcat('Raso start time: ',Raso.date));
    
    catch 
        disp('no Raso')
        NoRasoNum=1;
    end      
    
elseif i>=296 &&  i<326             %April 2017
      
    addpath('Inputdata/');   
    [year month day hour min sek lat lon altitude ETIM press temp RHl] = textread('NYA_radiosonde_2017-04.tab','%u-%u-%u%*c%u:%u:%u %f %f %f %*f %f %f %f %f %*f %*f','headerlines', 23);
    lRaso=length(year);                 %counts the length of the file entries

    %There can be multipe radiosoundings at one day. They are all listed in the .tab file. The way to
    %separate those is the variable ETIM. Each new sounding begins with ETIM=0;
    
    %Search for specific day and count the number of radiosondes at this day.
    i1st=295; 
    k=1;
    l=1;
    
    for j=1:lRaso                               %going through the file
        %collect all indicies (idx_dayk) for one day:       
        if day(j)==i-i1st
            idx_dayk(k)=j;                      %all indicies of raso launch
            k=k+1;
        end
        %count how often a raso was started at this one day
        if day(j)==i-i1st && ETIM(j)==0         %Each Raso begins with ETIM==0     
            idx_dayl(l)=j;                      %First index of raso launch
            l=l+1;
        end
    end
    l=l-1;                                      %Amount of Rasos at this single day
    
    if l==0                                     %If there is no Raso at this day
        disp('no Raso')
        NoRasoNum=1;
    
    else                                        %If there are Rasos at this day
    
    %There can be multiple (l) Raso launches at one day.
    %Raso launches times:
    Rasohelp.Ndate=datenum(year(idx_dayl),month(idx_dayl),day(idx_dayl),hour(idx_dayl),min(idx_dayl),sek(idx_dayl));
    Rasohelp.date=datestr(Rasohelp.Ndate);  %Time of the raso launches 
    sR=size(Rasohelp.date);
    lDate=(sR(1));   
        
    if lDate==1                  %if there is only one radiosonde launch at this day
        step=1;
        disp(strxcat('Raso start time: ',Rasohelp.date)); %dispay the date&time of this single launch
        
    elseif lDate>1               %if there are more raso launches at this day
        
        %to display the different launch starting times:
        % for ii=1:lDate
        %    disp(strxcat('Raso Date: ',Rasohelp.date(ii,:)));
        % end
        %The chose of raso launch number can be done manually:
        %prompt = 'Please choose number of launch: ';
        %step = input(prompt);
        
        %The chose of raso launch number can be done automatically (step 2 is usually at 12UTC):
        step=2;        
        disp(strxcat('More than one Raso at this day. Nr.2 is used.'));
        disp(strxcat('Raso start time: ',Rasohelp.date(2,:)));
        
    end
    
    %Write into raso-struct:
    Raso.number=i;
    Raso.date=datestr(Rasohelp.date(step,:));   %Time of that single radiosonde 
    
    %indicies of that single radiosonde:
    idx_begin=idx_dayl(step);
    
    if step==1                              %if there is only one raso
        idx_last=idx_dayk(end);
    elseif step<lDate                       %if there are more than one raso at this day 
        idx_last=idx_dayl(step+1)-1;     
    end
        
    %Write the time into the Raso Struct:
    Raso.N=datenum(year(idx_begin:idx_last),month(idx_begin:idx_last),day(idx_begin:idx_last),hour(idx_begin:idx_last),min(idx_begin:idx_last),sek(idx_begin:idx_last));
    
    %Write variables into the Raso-truct und convert to SI:
    Raso.alt=altitude(idx_begin:idx_last);  
    Raso.tempK=temp(idx_begin:idx_last)+273.15;
    Raso.press=press(idx_begin:idx_last)*1e2;
    Raso.RHl=RHl(idx_begin:idx_last);
    Raso.lat=lat(idx_begin:idx_last);
    Raso.lon=lon(idx_begin:idx_last);    
    
    end
     
elseif i==326 || i== 348     %These days have a crap raso and are therefore excluded. (1.May2017 and 23.May2017)
   
    disp('crap Raso')
    NoRasoNum=1;
        
elseif i>=326 && i< 357      %Mai 2017
    
    addpath('Inputdata/');
    [year month day hour min sek lat lon altitude ETIM press temp RHl] = textread('NYA_radiosonde_2017-05.tab','%u-%u-%u%*c%u:%u:%u %f %f %f %*f %f %f %f %f %*f %*f','headerlines', 23);
    lRaso=length(year);

    i1st=325;
    k=1;
    l=1;
    
    for j=1:lRaso    
        if day(j)==i-i1st
            idx_dayk(k)=j;                      %find all indicies
            k=k+1;
        end
        if day(j)==i-i1st && ETIM(j)==0         %find all first indicies 
            idx_dayl(l)=j;
            l=l+1;
        end
    end 
    l=l-1;                                      %Number or Rasos at one day
       
    if l==0                                     %if there is no Raso
        disp('no Raso')
        NoRasoNum=1;
        
    else
       
    %Raso Begins:
    Rasohelp.Ndate=datenum(year(idx_dayl),month(idx_dayl),day(idx_dayl),hour(idx_dayl),min(idx_dayl),sek(idx_dayl));
    Rasohelp.date=datestr(Rasohelp.Ndate);       %Time of Raso begin
    sR=size(Rasohelp.date);
    lDate=(sR(1));   
    
    if lDate==1                                  %if there is only one Raso
        step=1;
        disp(strxcat('Raso Date: ',Rasohelp.date)); 
                
    elseif lDate>1                              %if there are more Rasos at one day
            % for ii=1:lDate
            %     disp(strxcat('Raso Date: ',Rasohelp.date(ii,:)))
            % end
               
        if i==348                               %Special case i=348, 23.5.2017: first entry at 10UTC
            step=1;
            disp(strxcat('Special case: First raso launch (10UTC) is used'));
           
        else                                    %if there are more than one Raso at one day            
            step=2;
            disp(strxcat('More than one Raso at this day. Nr.2 is used.'));
            disp(strxcat('Raso start time: ',Rasohelp.date(2,:)))
        end    
    end
    
    %Write in raso-struct:
    Raso.number=i;
    Raso.date=datestr(Rasohelp.date(step,:));  %Time of raso launch
 
    %Find indicies from raso launch:
    idx_begin=idx_dayl(step);
    
    if step==1                              %if there is only one raso
        idx_last=idx_dayk(end);
    elseif step<lDate                       %if there are more rasos 
        idx_last=idx_dayl(step+1)-1;
    end
           
    %Write time into raso-struct:
    Raso.N=datenum(year(idx_begin:idx_last),month(idx_begin:idx_last),day(idx_begin:idx_last),hour(idx_begin:idx_last),min(idx_begin:idx_last),sek(idx_begin:idx_last));   
    %write variables into raso-struct und convert in SI:   
    Raso.alt=altitude(idx_begin:idx_last);  
    Raso.tempK=temp(idx_begin:idx_last)+273.15;
    Raso.press=press(idx_begin:idx_last)*1e2;
    Raso.RHl=RHl(idx_begin:idx_last);
    Raso.lat=lat(idx_begin:idx_last);
    Raso.lon=lon(idx_begin:idx_last); 
    
    end
    
elseif i>= 357              %Juni 2017
    
    addpath('Inputdata/');
    [year month day hour min sek lat lon altitude ETIM press temp RHl] = textread('NYA_radiosonde_2017-06.tab','%u-%u-%u%*c%u:%u:%u %f %f %f %*f %f %f %f %f %*f %*f','headerlines', 23);
    lRaso=length(year);

    i1st=356;
    k=1;
    l=1;
        
    for j=1:lRaso
        if day(j)==i-i1st
            idx_dayk(k)=j;                  %find all indicies
            k=k+1;
        end
        if day(j)==i-i1st && ETIM(j)==0     %finde all beginn indicies (more than one raso each day)
            idx_dayl(l)=j;
            l=l+1;
        end
    end
    l=l-1;                                  %Amount of rasos at one day
       
    if l==0
        disp('no Raso')
        NoRasoNum=1;
     
    else  
    
    %Raso Begins:
    Rasohelp.Ndate=datenum(year(idx_dayl),month(idx_dayl),day(idx_dayl),hour(idx_dayl),min(idx_dayl),sek(idx_dayl));
    Rasohelp.date=datestr(Rasohelp.Ndate);  %Time of Raso begins
    sR=size(Rasohelp.date);                 
    lDate=(sR(1));                          %Amount of Raso begins

    if lDate==1                             %if there is only one raso 
        step=1;
        disp(strxcat('Raso Date: ',Rasohelp.date));
                
    elseif lDate>1                          %if there are more than one raso
        % for ii=1:lDate
        % disp(strxcat('Raso Date: ',Rasohelp.date(ii,:)));
        %end
        step=2;
        disp(strxcat('More than one Raso at this day. Nr.2 is used.'));
        disp(strxcat('Raso start time: ',Rasohelp.date(2,:)));
    end
    
    %Write in raso struct:
    Raso.number=i;
    Raso.date=datestr(Rasohelp.date(step,:));   %Time of raso begin
       
    idx_begin=idx_dayl(step);                   %Find indicies of raso launch
    
    if step==1                                  %if there is one raso 
        idx_last=idx_dayk(end);
    elseif step<lDate                           %if there are more than one raso 
        idx_last=idx_dayl(step+1)-1;
    end
        
    %Write time into raso-struct:
    Raso.N=datenum(year(idx_begin:idx_last),month(idx_begin:idx_last),day(idx_begin:idx_last),hour(idx_begin:idx_last),min(idx_begin:idx_last),sek(idx_begin:idx_last));  
    %Write variables into raso-struct und convert in SI:    
    Raso.alt=altitude(idx_begin:idx_last);              %[m]
    Raso.tempK=temp(idx_begin:idx_last)+273.15;         %[K]
    Raso.press=press(idx_begin:idx_last)*1e2;           %[Pa]
    Raso.RHl=RHl(idx_begin:idx_last);                   %[%]
    Raso.lat=lat(idx_begin:idx_last);
    Raso.lon=lon(idx_begin:idx_last);
    
    end
     
end

%%
%Show Rasos where there are more than one launch:
%try
%    if lDate>1                          %if there are more than one raso
%         for ii=1:lDate
%         disp(strxcat('Raso Date: ',Rasohelp.date(ii,:)));
%        end
%end
%catch
%end

%%
%Fix special case: replace NaN with value below. (Case 267)

try                                             %special case i==267  
    RHl=Raso.RHl;
    for j=1:length(RHl)
        if isnan(RHl(j))
            RHl(j)=RHl(j-1);
        end
    end
    Raso.RHl=RHl;
catch
end

%%
%include measurement uncertainty
try
    Raso.RHl=Raso.RHl+uncert;
catch 
end

%%
%Calculate missing variables:

%calculate Raso.RHi
 try
     
    TC=Raso.tempK-273.15;                           %TC in deg C, TK in K:
    esatwM=6.112e2.*exp((17.62.*TC)./(243.12+TC));   %Saturation equvilibrium pressure regarding water
    esatiM=6.112e2*exp((22.46*TC)./(272.62+TC));     %Saturation equilibrium pressure regarding ice
    
    logew =  1./Raso.tempK*(- 0.58002206e4) ...        %Hyland and Wexler, 1983.
             + 0.13914993e1 ...
             - 0.48640239e-1*(Raso.tempK) ...
             + 0.41764768e-4*(Raso.tempK).^2 ...
             - 0.14452093e-7*(Raso.tempK).^3 ...
             + 0.65459673e1*log(Raso.tempK);
    esatw=exp(logew);
      
    logei =  1./Raso.tempK*(- 0.56745359e4) ...          %Hyland and Wexler, 1983.                                                                
             + 0.63925247e1 ...
             - 0.96778430e-2*Raso.tempK ...
             + 0.62215701e-6*(Raso.tempK).^2 ...
             + 0.20747825e-8*(Raso.tempK).^3 ...
             - 0.94840240e-12*(Raso.tempK).^4 ...
             + 0.41635019e1*log(Raso.tempK); 
    esati=exp(logei);

    Raso.RHi=Raso.RHl.*esatw./esati;                %Calculation of RHi
    clear TC esatw esati esatwM esatiM

 catch 
 end
 
%calculate Raso.RHmax: Max of RHl and RHi
try
     
    Raso.RHmax=max(Raso.RHl,Raso.RHi);
   
 catch 
end

%%
clear starttime Rasoyear Rasoday Rasohour Rasomonth Rasomin Rasosek rhl temp time timestep press alt
clear altitude day ETIM i1st idx_begin idx_dayl idx_dayl2 idx_dayk k l idx_last lDate lRaso hour j ...
    min month press promt Rasohelp RHl sek sR step temp year logei logew lat lon




    
    