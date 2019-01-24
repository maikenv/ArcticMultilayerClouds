
%This program prepares the variables for the final pie/histogram plots.

lMLC=length(index);                        %Length of Auswertung-struct

%%
%Give each case a number: Auswertung(k).Seeddiv
%Seeding: 11, 12, 13, ...
%NonSeeding: 21, 22, 23, ...

for k=1:lMLC
    lS(k)=length(MLC_classification(k).Seeding);                    %length of seeding
    MLC_classification(k).Seeddiv(1:lS(k))=NaN;
    MLC_classification(k).ML(1:lS(k))=NaN;
    MLC_classification(k).MLjn=NaN;
end

%%
for k=1:lMLC
    for kk=1:lS(k)
        %['no cloud below, no in between, no above ']
        if MLC_classification(k).Seeding(kk)==1 && MLC_classification(k).Zbelow(kk)==0 && MLC_classification(k).Zbetween(kk)==0  && MLC_classification(k).Zabove(kk)==0
            MLC_classification(k).Seeddiv(kk)=11;       
        %['cloud below, no cloud in between, cloud above ']
        elseif MLC_classification(k).Seeding(kk)==1 && MLC_classification(k).Zbelow(kk)==1 && MLC_classification(k).Zbetween(kk)==0  && MLC_classification(k).Zabove(kk)==1
            MLC_classification(k).Seeddiv(kk)=12;
        %['cloud below, no in between, no above ']
        elseif MLC_classification(k).Seeding(kk)==1 && MLC_classification(k).Zbelow(kk)==1 && MLC_classification(k).Zbetween(kk)==0  && MLC_classification(k).Zabove(kk)==0
            MLC_classification(k).Seeddiv(kk)=13;
        %['no cloud below, no in between, above ']
        elseif MLC_classification(k).Seeding(kk)==1 && MLC_classification(k).Zbelow(kk)==0 && MLC_classification(k).Zbetween(kk)==0  && MLC_classification(k).Zabove(kk)==1
            MLC_classification(k).Seeddiv(kk)=14;
        %['no cloud below, in between, no above ']
        elseif MLC_classification(k).Seeding(kk)==1 && MLC_classification(k).Zbelow(kk)==0 && MLC_classification(k).Zbetween(kk)==1  && MLC_classification(k).Zabove(kk)==0
            MLC_classification(k).Seeddiv(kk)=15;
        %['cloud below, in between, no above ']
        elseif MLC_classification(k).Seeding(kk)==1 && MLC_classification(k).Zbelow(kk)==1 && MLC_classification(k).Zbetween(kk)==1  && MLC_classification(k).Zabove(kk)==0
            MLC_classification(k).Seeddiv(kk)=16;  
        %['no cloud below, in between, above ']
        elseif MLC_classification(k).Seeding(kk)==1 && MLC_classification(k).Zbelow(kk)==0 && MLC_classification(k).Zbetween(kk)==1  && MLC_classification(k).Zabove(kk)==1
            MLC_classification(k).Seeddiv(kk)=17;
        %['cloud below, in between, above ']
        elseif MLC_classification(k).Seeding(kk)==1 && MLC_classification(k).Zbelow(kk)==1 && MLC_classification(k).Zbetween(kk)==1 && MLC_classification(k).Zabove(kk)==1
            MLC_classification(k).Seeddiv(kk)=18;   
        %Non Seeding: 
             %['no cloud below, no in between, no above ']
        elseif MLC_classification(k).Seeding(kk)==0 && MLC_classification(k).Zbelow(kk)==0 && MLC_classification(k).Zbetween(kk)==0  && MLC_classification(k).Zabove(kk)==0
            MLC_classification(k).Seeddiv(kk)=21;       
        %['cloud below, no cloud in between, cloud above ']
        elseif MLC_classification(k).Seeding(kk)==0 && MLC_classification(k).Zbelow(kk)==1 && MLC_classification(k).Zbetween(kk)==0  && MLC_classification(k).Zabove(kk)==1
            MLC_classification(k).Seeddiv(kk)=22;
        %['cloud below, no in between, no above ']
        elseif MLC_classification(k).Seeding(kk)==0 && MLC_classification(k).Zbelow(kk)==1 && MLC_classification(k).Zbetween(kk)==0  && MLC_classification(k).Zabove(kk)==0
            MLC_classification(k).Seeddiv(kk)=23;
        %['no cloud below, no in between, above ']
        elseif MLC_classification(k).Seeding(kk)==0 && MLC_classification(k).Zbelow(kk)==0 && MLC_classification(k).Zbetween(kk)==0  && MLC_classification(k).Zabove(kk)==1
            MLC_classification(k).Seeddiv(kk)=24;
        %['no cloud below, in between, no above ']
        elseif MLC_classification(k).Seeding(kk)==0 && MLC_classification(k).Zbelow(kk)==0 && MLC_classification(k).Zbetween(kk)==1  && MLC_classification(k).Zabove(kk)==0
            MLC_classification(k).Seeddiv(kk)=25;
        %['cloud below, in between, no above ']
        elseif MLC_classification(k).Seeding(kk)==0 && MLC_classification(k).Zbelow(kk)==1 && MLC_classification(k).Zbetween(kk)==1  && MLC_classification(k).Zabove(kk)==0
            MLC_classification(k).Seeddiv(kk)=26;  
        %['no cloud below, in between, above ']
        elseif MLC_classification(k).Seeding(kk)==0 && MLC_classification(k).Zbelow(kk)==0 && MLC_classification(k).Zbetween(kk)==1  && MLC_classification(k).Zabove(kk)==1
            MLC_classification(k).Seeddiv(kk)=27;
        %['cloud below, in between, above ']
        elseif MLC_classification(k).Seeding(kk)==0 && MLC_classification(k).Zbelow(kk)==1 && MLC_classification(k).Zbetween(kk)==1 && MLC_classification(k).Zabove(kk)==1
            MLC_classification(k).Seeddiv(kk)=28;             
        end
    end
end

txt={['no cloud below, no cloud in between, no cloud above ']; ...    %Seeding          %11 -1 
    ['cloud below, no cloud in between, cloud above ']; ...                             %12 +1
    ['cloud below, no cloud in between, no cloud above ']; ...                          %13 -1
    ['no cloud below, no cloud in between, cloud above ']; ...                          %14 +1 new: -1
    ['no cloud below, cloud in between, no cloud above ']; ...                          %15 +1 new: -1
    ['cloud below, cloud in between, no cloud above ']; ...                             %16 -1  
    ['no cloud below, cloud in between, cloud above ']; ...                             %17 +1 new: -1
    ['cloud below, cloud in between, cloud above ']; ...                                %18 +1
    ['no cloud below, no cloud in between, no cloud above ']; ...     %NotSeeding       %21 -1
    ['cloud below, no cloud in between, cloud above ']; ...                             %22 +1
    ['cloud below, no cloud in between, no cloud above ']; ...                          %23 -1
    ['no cloud below, no cloud in between, cloud above ']; ...                          %24 -1
    ['no cloud below, cloud in between, no cloud above ']; ...                          %25  0
    ['cloud below, cloud in between, no cloud above ']; ...                             %26 -1  
    ['no cloud below, cloud in between, cloud above ']; ...                             %27 -1
    ['cloud below, cloud in between, cloud above ']};                                   %28 +1

%%
%Multilayer or Non-Multilayer:
%ML=10: seeding ML
%ML=19: seeding, but no ML
%ML=20: non-seeding ML
%ML=29: non-seeding no ML

for k=1:lMLC
    for kk=1:lS(k)
        %Seeding ML:
        if MLC_classification(k).Seeddiv(kk)==12  || MLC_classification(k).Seeddiv(kk)==18
            MLC_classification(k).ML(kk)=10;
        %Seeding not ML:
        elseif MLC_classification(k).Seeddiv(kk)==11 ||MLC_classification(k).Seeddiv(kk)==13 ||MLC_classification(k).Seeddiv(kk)== 14 ||MLC_classification(k).Seeddiv(kk)==15 || MLC_classification(k).Seeddiv(kk)==16 || MLC_classification(k).Seeddiv(kk)==17 
            MLC_classification(k).ML(kk)=19;  
        %Non-seeding ML:
        elseif MLC_classification(k).Seeddiv(kk)== 22  %||Auswertung(k).Seeddiv(kk)==28
            MLC_classification(k).ML(kk)=20;
        %Non-seeding not ML:
        elseif MLC_classification(k).Seeddiv(kk)==28 || MLC_classification(k).Seeddiv(kk)==21 ||MLC_classification(k).Seeddiv(kk)==23 || MLC_classification(k).Seeddiv(kk)==24 ||MLC_classification(k).Seeddiv(kk)==25 || MLC_classification(k).Seeddiv(kk)==26 ||MLC_classification(k).Seeddiv(kk)==27
            MLC_classification(k).ML(kk)=29;  
        end
    end
end

%%
%find amount, where Raso or Cloudnet= Nan (hmax).

for k=1:lMLC
    Ausw_hmax(k,:)=MLC_classification(k).hmax;
    Ausw_cloudlayers(k,:)=MLC_classification(k).cloud_layers;
end

%%
%if Hmax=Nan, then Rasofile or Cloudnet at Rasotime is missing:
idx_Nan=find(isnan(Ausw_hmax));                 %Nan                         
Anz_Nan=length(idx_Nan);                                            

idx_0cloud=find(Ausw_cloudlayers==0);           %no cloudlayer                       
Anz_0cloud=length(idx_0cloud);                                     

idx_1cloud=find(Ausw_cloudlayers==1);           %exact one cloud layer                        
Anz_1cloud=length(idx_1cloud);                  

idx_2cloud=find(Ausw_cloudlayers>=2);           %Multilayer cloud                          
Anz_2cloud=length(idx_2cloud);                   

idx_cloudcover=find(Ausw_cloudlayers>=1);       %Cloudcover                         
Anz_cloudcover=length(idx_cloudcover);          

idx_nonNan=find(~isnan(Ausw_hmax));             %non-NaN days                         
Anz_nonNan=length(idx_nonNan);                  

%%
%look only at cases with 2 or more clouds:

Anz_seeding(index)=NaN;
Anz_nonseeding(index)=NaN;

for k=1:Anz_2cloud

    MLC_ML_all(:)=MLC_classification(idx_2cloud(k)).ML;
    
    idx_seeding=find(MLC_ML_all==10);                                      
    Anz_seeding_help=length(idx_seeding);               
    Anz_seeding(idx_2cloud(k))=Anz_seeding_help;
    
    idx_nonseeding=find(MLC_ML_all==20);           
    Anz_nonseeding_help=length(idx_nonseeding);         
    Anz_nonseeding(idx_2cloud(k))=Anz_nonseeding_help;
   
    clear MLC_ML_all;    
    
end

%%
%decide if only Seedning, only not seeding, both or nothing. And write in MLC_classification.MLjn
Anz_trenn(index)=NaN;

for k=1:lMLC
    if Anz_seeding(k)>=1 && Anz_nonseeding(k) ==0           %if only Seeding occurrs
        Anz_trenn(k)=31;
    elseif Anz_seeding(k)==0 && Anz_nonseeding(k) >=1       %if non-Seeding occurrs
        Anz_trenn(k)=32;
    elseif Anz_seeding(k)>=1 && Anz_nonseeding(k) >=1       %if both Seeding and non-Seeding occurrs
        Anz_trenn(k)=33;
    elseif Anz_seeding(k)==0 && Anz_nonseeding(k) ==0       %if no ML occurrs
        Anz_trenn(k)=34;
    end
end

for k=1:lMLC
    MLC_classification(k).MLjn=Anz_trenn(k);
end

%%

idx_onlyseed=find(Anz_trenn==31);                                  
Anz_onlyseed=length(idx_onlyseed);          %only Seeding 

idx_nonseed=find(Anz_trenn==32);                                
Anz_nonseed=length(idx_nonseed);            %non-Seeding 

idx_both=find(Anz_trenn==33);                               
Anz_both=length(idx_both);                  %both Seeding and non-Seeding 

idx_noML=find(Anz_trenn==34);                                 
Anz_noML=length(idx_noML);                  %Seeding and/or non-Seeding, but no-MLC 

%%
%Divid nr.34 noML cloud into a) no cloud= only if Seediv: 11 or 21 or b) singel layer 
%find cases where non-MLC:
clear Anz_34
Anz_34(idx_noML)=NaN;
Anz_34(end+1:lMLC)=0;               %only needed for RH=120???
Anz_34(isnan(Anz_34))=1;
Anz_34(Anz_34==0)=NaN;

%%
%find cases, where there is no cloudlayer.
for k=1:lMLC
    if isnan(Anz_34(k))
            MLC_classification(k).noML=NaN;
    else
    for kk=1:lS(k)
            if MLC_classification(k).Seeddiv(kk)== 11 ||MLC_classification(k).Seeddiv(kk)==21 ...
                && MLC_classification(k).Seeddiv(kk)~=12 && MLC_classification(k).Seeddiv(kk)~=13 && MLC_classification(k).Seeddiv(kk)~=14 ...
                && MLC_classification(k).Seeddiv(kk)~=15 && MLC_classification(k).Seeddiv(kk)~=16 && MLC_classification(k).Seeddiv(kk)~=17 ...
                && MLC_classification(k).Seeddiv(kk)~=18 && MLC_classification(k).Seeddiv(kk)~=19 ...
                && MLC_classification(k).Seeddiv(kk)~=22 && MLC_classification(k).Seeddiv(kk)~=23 && MLC_classification(k).Seeddiv(kk)~=24 ...
                && MLC_classification(k).Seeddiv(kk)~=25 && MLC_classification(k).Seeddiv(kk)~=26 && MLC_classification(k).Seeddiv(kk)~=27 ...
                && MLC_classification(k).Seeddiv(kk)~=28 && MLC_classification(k).Seeddiv(kk)~=29
            
                MLC_classification(k).noML(kk)=0;                   %0= no cloudlayer (Fall 11&21)
            else 
                MLC_classification(k).noML(kk)=1;                   %1= one single cloudlayer

            end
    end
    end
end

%%
%summing up: 0: no cloudlayer, 1 or more: 1 cloudlayer.
for k=1:lMLC
    sum_34(k)=sum(MLC_classification(k).noML);
end

%finding index
idx_noML0=find(sum_34==0);                                       
Anz_noML0=length(idx_noML0);           % Seeding and/or non-Seeding, no MLC, no single-layer cloud 

idx_noML1=find(sum_34>=1);                                    
Anz_noML1=length(idx_noML1);           % Seeding and/or non-Seeding, but no MLC 

%control
Anz_noML0+Anz_noML1;                    %should be = Anz_noML

%%











