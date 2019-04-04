
%%Arctic multilayer cloud detection algorithm
%Written by Maiken Vassel, latest update 2019

%This is the main program of the classification algorithm. Here the dataset is analysed for
%seeding/non-seeding multilayer clouds from day to day.
%The general structure is that one day (i) is evaluated and the resulting information is written into 
%the structure MLC_classification.mat. As soon as MLC_classification.mat is filled for one year
%(loop), the rest of the evaluation is done based on MLC_classification.mat and the loop can be replaced 
%by any single day. 
%The structure of this program is the following:
%1.Settings for the classification
%2.Name: Used as ending for MLC_classification.mat and for saved plots
%3.Date: Defines the time period of the classification.
%4.Single day or loop over time period
%5.Radiosonde evaluation
%6.Sublimation calculation 
%7.Cloudnet (Radar) evaluation as additional information
%8.Pieplots 
%9.Skill scores
%Turn on/off specific programs for the specific need.

clearvars -except MLC_classification

close all;

%Some extra Matlab programs are needed:
addpath('Matlab_extra_functions');                          %Path added for Matlab extra Programs (colors,etc.)
addpath('Matlab_extra_functions/matlab2tikz-master/src');   %Path added for converting Pie Plot into .tex file. 
addpath('Matlab_extra_functions/floatAxis');
addpath('Matlab_extra_functions/export_fig-master');
load cm.mat;                                                %line colors

%The path to the radiosonde data needs to be specified in Raso_1_read 
addpath('Inputdata/Cloudnet');                              %Path for Cloudnet (Radar) data

%%
%1.Settings:
%Here you can adjust some settings (max height, relative humidity threshold, etc.):

hmin=0.2228;                %Minimum height at groud [m]. Std: hmin=0.2228
hmax=10;                    %Maximum height [km] upto where it is searched for. Std: hmax=10; 
Rsize=400;                  %Radius of ice crystal [mikrometer]. Std Rsize=100 
rhthres=100.0;              %Relative Humidity threshold [%]. Std rhgrenze=100.0 
minsub=100;                 %Minimum thickness of subsaturated layer [m]. Std:20
minsuper=100.0;             %Minimum thickness of supersaturated layer [m]. Std:100
%uncert=0.0;                 %Raso uncertainty -5.0, 0.0, 5.0
gap_min=30;                 %This number [min] defines the timeperiod for evaluation of Cloudnet. %Std:30min, for test: 15min
ending='MHP_WC';            %Defines the kind of ice particle calculation.
                            %MHP_WC: Mitchell, 1994: Hexagonal plate; Witchell, 2008: capacitance
                            %AG: Aggregate, RC: rimed column, SP: star particle 

%2.Name:
%Define an name/ending here. This will be used as ending for the struct MLC_classification....mat and
%for the generated plots.
%It is recommended to change the name if the settings are changed.

name=strxcat('r',Rsize,ending);                         %Used as Std
%name=strxcat(Rsize,'_msub',minsub','RH',rhthres);      %Alternative, if RH is changed
%name=strxcat(Rsize,'_msub',minsub,'uncert95');         %Alternative, if minsub is changed
%name=strxcat(Rsize,'_minsuper',minsuper);              %Alternative, if minsuper is changed
%name=strxcat(Rsize,'_avgtime',gap_min);                %Alternative, if average time is changed 

%%
%3.Date:
%Chose the time period for the analysis: Define the length and start date of the analysed time period.

%1-year dataset:
ii=1:365;                                           %Dataset length [days]: Std:1:365
NCloudnet=datenum(2016,06,9+ii,00,00,00);           %Dataset start date (use one day before actual start date), [year, month, day] Std: 2016,06,9 => 10.6.16-9.6.17 
%24.5-year dataset:
%ii=[1:8926];                                       %Alternative: until 9.6.2017
%NCloudnet=datenum(1993,01,00+ii,00,00,00);         %Alternative
%datestr(NCloudnet);                                %This is only for control to display chosen time period.                

Cloudnet_1_calcN                                    %This function prepares the time for further use

%4.Single day or loop
%Here you specify if you want to analyse only a single day (if you want a plot only for a single day) or do 
%the full loop over the 1-year dataset. If you have done the loop once, it will be saved in 
%MLC_classification.mat as a structure. Then there is no need to do the loop again over all days. Instead 
%load MLC_classification.mat in the beginning. Choose a random single day and run make_MLC_classification
%without the loop (if you e.g. want to plot pie plots). 
%If you use/do not use the loop, uncomment/comment out the lines 81 (for i=...) and 123 (end). 
%Each day is given an index 'i', which is kept for the entire calculation (i=1=> 9.6.2016).
    
%i=147; %13, 157;                                          %Single day, 147=3.Nov 2017                            
for i=1:365                                                %Loop, std: 1:365

    %Output for each day:
    i                                                           %Gives i-number as output
    disp(strxcat('Date: ',timestruct.time(i,:)));               %Gives date of i-number as output

    %% 
    %5.Radiosonde evaluation
    %Here the evaluation of the radiosonde (Raso) data is done.

    Raso_1_read                 %Reads the Raso data of the actual day 'i' and writes it in a Raso-structure. 
    Raso_3_layers               %Calculates mean RH for each subsaturated layer and calculates the sublimation/seeding
    layer=1;                    %Specify which subsaturated layer (layer nr starts counting from top) should be used in Raso_5_findposition 
    Raso_6_advection            %Calculates the wind advection time
     
    clear a c d d3 dhelp dlambda dN dN3 dphi folder idx idx_nonnan ii lambda1 lambda2 lambda3 lat1 lat2 ...
        lat3 lon1 lon2 lon3 phi1 phi2 phi3 tadv v3
    %%
    %6.Sublimation calculation plots 

    %Sublimation_2_radii            %Plots multiple radii in one plot

    %Deleting variables that are not needed any more:
    clear layer ii j r1 Sublimation tC Seeding maxtime TK1 TK_nocloud RHmax_nocloud RHi_nocloud RHi1 ...
        Press_nocloud P1 maxtime H_falldown H_fallbeginn z1 Sublimation50 Sublimation100 Sublimation150 ...
        maxtime50 maxtime100 maxtime150 layer k

    %%
    %7. Including Cloudnet (Radar) for evaluation

    Cloudnet_2_read                     %Reads Cloudnet data and writes into structure
    Cloudnet_2_short                    %Reduces the size of Cloudnet structure from 2000 to 400 time steps.
    Cloudnet_4_preparation_adv          %Data preparation: excludes cases where radar and radiosonde do not overlap in time, includes the advection
    Cloudnet_4_evaluation               %Evaluation of Cloudnet. (Defining if cloud above,in between, below)
    %Cloudnet_4_plot_sectionlines       %Overview plot
        
end                                    %End of loop 

%%
%8. Creating Pieplots after MLC_classification- struct is created.  

%Save the struct MLC_classification. Then you only need to run the loop once.
save(strxcat('MLC_classification_',name,'.mat'), 'MLC_classification');     

index=[1:365];                      %this can be modified if only a shorter time period should be evaluated.
Evaluation_1_calc                   %finds indicies for the following pie/histogram plots.

%Only Raso(=Radiosonde):
Evaluation_2_pie                   %Raso-Pie plot                            
%Evaluation_2_histogram_radii       %Histogram with all 3 radius in one.
%Evaluation_2_visual                %Reads and evaluates the manual visual detection

%Deleting variables that are not needed any more:
clear Anz_0cloud Anz_1cloud Anz_both Anz_cloudcover Anz_Nan Anz_nonNan Anz_nonseed Anz_onlyseed idx_0cloud ...
    idx_1cloud idx_both idx_cloudcover idx_Nan idx_nonNan idx_nonseed idx_onlyseed Anz_noML Anz_noML0 Anz_noML1 ...
    idx_noML idx_noML0 idx_noML1

%Cloud categories:
%Evaluation_3_nonSeeding                    %Cloud category of non-seeding
%Evaluation_3_Seeding                       %Cloud category of seeding

%Raso and Radar (RC) combined:             
Evaluation_4_RC_calc                        %Preparation of following plots (is included in the two following programs)
Evaluation_4_RC_pie                         %Pie-plot        
%Evaluation_4_RC_histogram_radii            %Histogram with all 3 radius in one

