% === main_parameter_setting.m ===
%% === Set pair data generation options ===
noiseLevel = 0.01;  % define level of noise added to CCA pair data for computational stabilization
dataType = "PC"; % define data type for analysis; 
dataDim = 50; % define PC dimensions being used in the analysis % define seed for noise 
pairDataGenerationOptions = PairDataGenerationOptions(noiseLevel,dataType,dataDim); % parameters group

%% === Set reconstruction options ===
dimPI = 5; % define dimension being used for reconstruction
threshWidth = 0.01; % define threshold width for ROC curve
reconstructionParameters = ReconstructionParameters(dimPI,threshWidth); % parameter group

%% === Set holdout options ===
trainRatio = 0.8; % define data ratio to learn
numSplits_main = 200; % number of holdout split in the main data analysis
holdoutParameters_main = HoldoutParameters(trainRatio,numSplits_main);

numSplits_nulls = 5; % number of holdout split in the random connectome data analysis
holdoutParameters_nulls = HoldoutParameters(trainRatio,numSplits_nulls);

%% === Set null connectome test times ===
numRandomConnectome = 1000; % number of random connectome data per each null model

%% === Setup for figure ===
set(groot, 'DefaultAxesFontName', 'Arial');
set(groot, 'DefaultTextFontName', 'Arial');
colorList = orderedcolors("gem");