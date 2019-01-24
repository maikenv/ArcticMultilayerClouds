
%In this program the radiosoundings are analysed. 
%Given, that a radiosounding exists, the first step is to determine how many super/subsaturated layers exist. 
%The second step is to calculate the mean values of the subsaturated layer.
%The third step is to calculate the survival of a falling ice crystal. 
%The fourth step is to determine if it is a seeding case or not. 
%The results are written into the Auswertung-struct. 

%%

if NoRasoNum==1                                     %If there is no raso
    MLC_classification(i).number_i=i;
    MLC_classification(i).date=datestr(NCloudnet(i));
    MLC_classification(i).hmax=NaN;                         %If there is no raso: Auswertung.hmax=NaN
    MLC_classification(i).cloud_layers=NaN;
    MLC_classification(i).nocloud_layers=NaN;
    MLC_classification(i).Seeding=NaN; 
    MLC_classification(i).fallbeginn=NaN;
    MLC_classification(i).fallend=NaN;

elseif NoRasoNum==0                                 %If a raso exists
      
    %First step: Count how many cloud layers exist
    [Raso10km, numcloud_i, Cloudixd] = func_1_layers(Raso,hmax,rhthres,minsub,minsuper); %neu k=1 = _layers

    %numcloud_i                           %Amount of supersaturated layers (including ice and max 1x liquid)     
    
    MLC_classification(i).number_i=i;
    MLC_classification(i).date=Raso.date;
    MLC_classification(i).hmax=hmax;
    MLC_classification(i).cloud_layers=numcloud_i;

    %%
    %Second step: If there are min two supersaturated layers, then there is min one subsaturated layer in between.
    %Calculation of mean RH, Temp, Press for this subsaturated layer in between     
       
    if numcloud_i>=2                                   %If there are min 2 supersaturated layers 
          
        [H_fallbeginn , H_falldown , Press_nocloud ,RHi_nocloud, TK_nocloud]= func_2_avg(Raso, Raso10km, Cloudixd);
        layers=length(H_fallbeginn);                 %Amount of subsaturated layers
       
        %%
        %Third step: Calculate the survival of the ice crystal

        for k=1:layers                              %all subsaturated layers

            %Here the mean values can be manipulated:
            RHi1=RHi_nocloud(k);
            TK1=TK_nocloud(k);
            P1=Press_nocloud(k);
            z1(1)=H_fallbeginn(k);
            r1(1)=Rsize;
           
            %Calculate the sublimation:
            
            funcname=strxcat('func_3_icesubl_',ending); %use ending for selection of type function.
            fh = str2func(funcname);
            [maxtime(k), Sublimation(k), esati, esatiM]=fh(RHi1,TK1,P1,z1,r1);
            %[maxtime(k), Sublimation(k), esati, esatiM]=func_3_icesubl_HKrP(RHi1,TK1,P1,z1,r1);      %with use of diameter-mass relationsship of S&B.
            %[maxtime(k), Sublimation(k), esati, esatiM]=func_3_icesubl_Mitchell(RHi1,TK1,P1,z1,r1);      %with use of diameter-mass relationsship of S&B.

        end

        %Fourth step: Check if there is seeding or not
        for k=1:layers   
            if Sublimation(k).height(end) <= H_falldown(k)  
                Seeding(k)=1;
            else
                Seeding(k)=0;
            end
        end    
        
        MLC_classification(i).nocloud_layers=layers; 
        MLC_classification(i).Seeding=Seeding;                      %write seeding in MLC_classification sturcture
        MLC_classification(i).fallbeginn=H_fallbeginn;
        MLC_classification(i).fallend=H_falldown;
        
        clear Seeding
                
     elseif numcloud_i==1 || numcloud_i==0                 %if there is only one or no cloud layer
        
        MLC_classification(i).nocloud_layers=NaN;
        MLC_classification(i).Seeding=NaN;                          %no seeding
        MLC_classification(i).fallbeginn=NaN;
        MLC_classification(i).fallend=NaN;
       
    end         
    
end             

clear funcname fh



