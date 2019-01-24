
%Finding length of Auswertung-struct:
lMLC=length(index);

%%
%find amount, where Raso=NaN or Cloudnet=NaN. This is done by using hmax.

for k=1:lMLC
    MLC_hmax(k)=MLC_classification(k).hmax;
    MLC_cloudlayers(k)=MLC_classification(k).cloud_layers;
end

%%
%if Hmax=NaN, then Rasofile or Cloudnet at Rasotime is missing:
idx_Nan=find(isnan(MLC_hmax));                 %index of Position                         
Anz_Nan=length(idx_Nan);                        %length of Index List                     

idx_0cloud=find(MLC_cloudlayers==0);           %index of Position                         
Anz_0cloud=length(idx_0cloud);                  %length of Index List                    

idx_1cloud=find(MLC_cloudlayers==1);           %index of Position                         
Anz_1cloud=length(idx_1cloud);                  %length of Index List  

idx_2cloud=find(MLC_cloudlayers>=2);           %index of Position                         
Anz_2cloud=length(idx_2cloud);                  %length of Index List  

idx_cloudcover=find(MLC_cloudlayers>=1);       %index of Position                         
Anz_cloudcover=length(idx_cloudcover);          %length of Index List  

idx_nonNan=find(~isnan(MLC_hmax));             %index of Position                         
Anz_nonNan=length(idx_nonNan);                  %length of Index List                     

%%
%look only at cases with 2 or more clouds:

Anz_seeding(index)=NaN;
Anz_nonseeding(index)=NaN;

for k=1:Anz_2cloud

    MLC_seeding_all(:)=MLC_classification(idx_2cloud(k)).Seeding;
    
    idx_seeding=find(MLC_seeding_all==1);              %index of Position                         
    Anz_seeding_help=length(idx_seeding);               %length of Index List 
    Anz_seeding(idx_2cloud(k))=Anz_seeding_help;
    
    idx_nonseeding=find(MLC_seeding_all==0);           %index of Position 
    Anz_nonseeding_help=length(idx_nonseeding);         %length of Index List 
    Anz_nonseeding(idx_2cloud(k))=Anz_nonseeding_help;
   
    clear MLC_seeding_all;    
    
end

%%
Anz_trenn(index)=NaN;

for k=1:lMLC
    
    if Anz_seeding(k)==0 && Anz_nonseeding(k) >=1                   %if no Seeding occurrs
        Anz_trenn(k)=0;
    elseif Anz_seeding(k)>=1 && Anz_nonseeding(k) ==0               %if only Seeding occurrs
        Anz_trenn(k)=1;
    elseif Anz_seeding(k)>=1 && Anz_nonseeding(k) >=1               %if Seeding and no Seeding ocurrs
        Anz_trenn(k)=2;
    end
end

%%

idx_nonseed=find(Anz_trenn==0);                                  
Anz_nonseed=length(idx_nonseed);        %no Seeding 

idx_onlyseed=find(Anz_trenn==1);                                 
Anz_onlyseed=length(idx_onlyseed);      %only Seeding 

idx_both=find(Anz_trenn>1);                                    
Anz_both=length(idx_both);              %both Seeding and no Seeding 

%for control: should be = Anz_2cloud
%Anz_nonseed+Anz_onlyseed+Anz_both

%%
%Include missing Data into Auswertung-struct (where Cloudnet is missing):

for k=1:lMLC
    MLC_date(k)=datenum(MLC_classification(k).date);
end

idx_DateNan=find(isnan(MLC_date));                                 
Anz_DateNan=length(idx_DateNan);                    

for k=1:Anz_DateNan
    [yy2(k-1) mm2(k-1) dd2(k-1)]= datevec(MLC_classification(idx_DateNan(k)-1).date);
    MLC_classification(idx_DateNan(k)).date=datestr(datenum(yy2(k-1), mm2(k-1), dd2(k-1)+1,0,0,0));        
end

%%

clear Anz_2cloud Anz_nonseeding Anz_nonseeding_help Anz_seeding Anz_seeding_help Anz_trenn MLC_cloudlayers MLC_hmax combinedtxt ...
    grey hText idx_2cloud idx_nonseeding idx_seeding k newExtents newExtents_cell offset oldExtents oldExtents_cell ...
    percentValues pos signValues textPositions textPositions_cell txt width_change xoffset XP Xcolor f4 h ...
    MLC_dateRaso idx_DateNan Anz_DateNan yy2 mm2 dd2 


%%





