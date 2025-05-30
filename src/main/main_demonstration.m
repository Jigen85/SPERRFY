%% main_demonstration
%% Startup
clear; clc;
startup_SPERRFY;  % path setting

%% Load data
main_import_processed_data;  % import data (.mat)
main_data_preparation;

%% Parameter setting
main_parameter_setting;
% small number of null connectome test
numNullTest = 10;

%% Mouse connectome data analysis
rng(1);
mouseConnectomeDataAnalysis = ConnectomeAnalysisRunner(connectomeMatrix, geneExprLevels,crossInfo, ...
    pairDataGenerationOptions,reconstructionParameters,holdoutParameters_main,"FactoryDescription","Main Data Analysis");
mouseConnectomeDataAnalysis = mouseConnectomeDataAnalysis.runAnalysis(ReconstructionStoreTag=true);

%% Perform Gene Analysis
KTopGene = 30;
relatedGeneAnalysisResults = mouseConnectomeDataAnalysis.performRelatedGeneAnalysis(KTopGene);

%% Perform null connectome analysis

nullGenerator_1 = NullConnectomeGeneratorModel(connectomeMatrix,crossInfo,"RandomGeneration",0, ...
    "Description","RandomGeneration, Golobally");
nullGenerator_2 = NullConnectomeGeneratorModel(connectomeMatrix,crossInfo,"RandomGeneration",1, ...
    "Description","RandomGeneration, Locally");
nullGenerator_3 = NullConnectomeGeneratorModel(connectomeMatrix,crossInfo,"DistancePreserve",0, ...
    "Description","RandomGeneration, Golobally");
nullGenerator_4 = NullConnectomeGeneratorModel(connectomeMatrix,crossInfo,"DistancePreserve",1, ...
    "Description","RandomGeneration, Locally");
nullGenerator_5 = NullConnectomeGeneratorModel(connectomeMatrix,crossInfo,"NetworkPreserve",0, ...
    "Description","RandomGeneration, Golobally");
nullGenerator_6 = NullConnectomeGeneratorModel(connectomeMatrix,crossInfo,"NetworkPreserve",1, ...
    "Description","RandomGeneration, Locally");

%% sample matrix
rng(2)
randomConnectomeSample_global = nullGenerator_1.generate;
randomConnectomeSample_local = nullGenerator_2.generate;

%%

nullBatchRunner_1 = NullModelAnalysisBatchRunner(nullGenerator_1,numNullTest,holdoutParameters_nulls);
nullBatchRunner_1 = nullBatchRunner_1.run(mouseConnectomeDataAnalysis);
nullBatchRunner_2 = NullModelAnalysisBatchRunner(nullGenerator_2,numNullTest,holdoutParameters_nulls);
nullBatchRunner_2 = nullBatchRunner_2.run(mouseConnectomeDataAnalysis);
nullBatchRunner_3 = NullModelAnalysisBatchRunner(nullGenerator_3,numNullTest,holdoutParameters_nulls);
nullBatchRunner_3 = nullBatchRunner_3.run(mouseConnectomeDataAnalysis);
nullBatchRunner_4 = NullModelAnalysisBatchRunner(nullGenerator_4,numNullTest,holdoutParameters_nulls);
nullBatchRunner_4 = nullBatchRunner_4.run(mouseConnectomeDataAnalysis);
nullBatchRunner_5 = NullModelAnalysisBatchRunner(nullGenerator_5,numNullTest,holdoutParameters_nulls);
nullBatchRunner_5 = nullBatchRunner_5.run(mouseConnectomeDataAnalysis);
nullBatchRunner_6 = NullModelAnalysisBatchRunner(nullGenerator_6,numNullTest,holdoutParameters_nulls);
nullBatchRunner_6 = nullBatchRunner_6.run(mouseConnectomeDataAnalysis);
