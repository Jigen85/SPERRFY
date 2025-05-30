% test_main_script.m
%% Startup
clear; clc;
startup_SPERRFY;  % path setting

%% Load data
main_import_processed_data;  % import data (.mat)
main_data_preparation;
main_parameter_setting;


%% Run main data analysis
mainDataAnalysis = ConnectomeAnalysisRunner(connectomeMatrix, geneExprLevels,crossInfo, ...
    pairDataGenerationOptions,reconstructionParameters,holdoutParameters_main,"FactoryDescription","Main Data Analysis");
mainDataAnalysis = mainDataAnalysis.runAnalysis(ReconstructionStoreTag=true);

%% Perform gene analysis

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

num_randomData = 3;
nullBatchRunner_1 = NullModelAnalysisBatchRunner(nullGenerator_1,num_randomData,holdoutParameters_nulls);
nullBatchRunner_1 = nullBatchRunner_1.run(mainDataAnalysis);
nullBatchRunner_2 = NullModelAnalysisBatchRunner(nullGenerator_2,num_randomData,holdoutParameters_nulls);
nullBatchRunner_2 = nullBatchRunner_2.run(mainDataAnalysis);
nullBatchRunner_3 = NullModelAnalysisBatchRunner(nullGenerator_3,num_randomData,holdoutParameters_nulls);
nullBatchRunner_3 = nullBatchRunner_3.run(mainDataAnalysis);
nullBatchRunner_4 = NullModelAnalysisBatchRunner(nullGenerator_4,num_randomData,holdoutParameters_nulls);
nullBatchRunner_4 = nullBatchRunner_4.run(mainDataAnalysis);
nullBatchRunner_5 = NullModelAnalysisBatchRunner(nullGenerator_5,num_randomData,holdoutParameters_nulls);
nullBatchRunner_5 = nullBatchRunner_5.run(mainDataAnalysis);
nullBatchRunner_6 = NullModelAnalysisBatchRunner(nullGenerator_6,num_randomData,holdoutParameters_nulls);
nullBatchRunner_6 = nullBatchRunner_6.run(mainDataAnalysis);