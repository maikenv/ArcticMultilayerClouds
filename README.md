#READ ME
#written by Maiken Vassel, 2017-2018
#All code will be uploaded during the following weeks. 

The following programmes can be used to classify multilayer clouds based on radiosonde and radar data. The multilayer cloud cases can be further separated into seeding and non-seeding cases. Detailed information about the assumptions the classification algorithm is based on and one example study using this algorithm can be found in the following publication: Vassel, M., L. Ickes, M. Maturilli, C.Hoose: Classification of Arctic multilayer clouds using radiosonde and radar data. Please refer to this publication when using this programme suite. 

The main program is called make_MLC_classification. Open this and go through it. It creates a file containing the information of how many clouds could be found for each radiosonde profile and how many seeding/non-seeding cases exist. The input data for the classification must be stored in the folder Inputdata.
The main settings for the classification are set here. You can choose if you want to evaluate an entire year by using the loop or only one single day. The results of each day from the loop are stored in the MLC_classification.mat file. The structure of the outputfile MLC_classification.mat is explained below.
As soon as the file MLC_classification.mat is created the data can be evaluated further. For plotting select the specific plot-routine.

The structure of the output file MLC_classification.mat is the following:
MLC_classification.mat variable list:
number_i, date, hmax, cloud_layers, nocloud_layers, seeding, fallbegin, fallend, Zbelow, Zbetween, Zabove, Seeddiv, ML, MLjn, noML, Visual
 
 
