
READ ME
written by Maiken Vassel, 2017-2019

The following programmes can be used to classify multilayer clouds based on radiosonde and radar data. They can be further
separated in seeding and non-seeding multilayer cloud cases. Detailed information about the assumptions the classification
algorithm is based on, and one example study using this algorithm can be found in the following publication: Vassel, M., Ickes,
L., Maturilli, M., and Hoose, C.: Classification of Arctic multilayer clouds using radiosonde and radar data in Svalbard, Atmos. Chem. Phys.
Discuss., https://doi.org/10.5194/acp-2018-774, in review, 2018. Please refer to this publication when using this programme
suite. 

The main program is called 1make_MLC_classification. It creates a file containing the information of how many clouds could be
found for each radiosonde profile and how many seeding/non-seeding cases exist. The input data for the classification must be
stored in the folder Inputdata. You can choose if you want to evaluate an entire year by using the loop or only one single day.
The results of each day from the loop are stored in the MLC_classification...mat file. The structure of this outputfile
MLC_classification.mat is explained below.
As soon as the file MLC_classification.mat is created the data can be further evaluated. To plot the data the specific
plot-routine must be uncommented in 1make_MLC_classification and the main program 1make_MLC_classification must be run again. All
generated plots are stored in the folder Plots.

The structure/variable list of the output file MLC_classification.mat is the following:
number_i:	Each day is given a number, from 1 to 365.
date: 		Day-month-year (additionally hour-min-sek is the start time of the Raso (=radiosonde))
hmax:		If data is missing, this is =NaN, else =height until which the data is evaluated [km].
cloud_layers:	Number of cloud layers.
nocloud_layers: Number of subsaturated layers.
Seeding: 	0= no seeding, 1= seeding inside noncloudy layer. Dimension of variable Seeding: nocloud_layers.
fallbegin:   	Heigth of cloud base from where the ice crystal begins to fall. Dimension of variable fallbegin: nocloud_layers
fallend: 	Heigth of next cloudtop until where the ice crystal falls reaching the next supersaturated layer. Dimension of variable
fallbegin:     nocloud_layers
Zbeteen:       0= no radar reflectivity (Z) inside nocloud_layer. 1= Z inside nocloud_layer.
Zabove:        0= no Z inside cloud layer above. 1= Z inside cloud layer above.
Zbelow:        0= no Z inside cloud layer below. 1= Z inside cloud layer below.
Seeddiv:	Sorts into different cloud categories: 11,12,13,...,18= seeding, 21,22,23,...,28=non-seeding
ML:		Sorts MLC into different seeding and non-seeding cases: ML=10: seeding ML; ML=19: seeding but no ML; ML=20: non-seeding ML;
ML=29: non-seeding and no MLC
MLjn:		Sorts MLjn=31: only seeding occurrs but no MLC, MLjn=32: non-seeding occurrs, MLjn=33: both seeding and non-seeding
occurrs, MLjn=34: no MLC occurs
noML:		Case where there is no ML. noML=NaN: no MLC, noML=0:no cloudlayer, noML=1: single cloud layer  
Visual:        Manual visual detection taken from 'Inputdata/Visual.txt' 

Example: 
Plot the pie chart for the 1-year analysed time period
1. load('MLC_classification_r400MHP_WC.mat')
2. uncomment Evaluation_4_RC_pie
3. run 1make_MLC_classification



