%% demonstration.m
%% Startup
clear; clc;
startup_SPERRFY;  % path setting

%% Data Preparation
main_import_processed_data;  % import processed data (.mat)
main_data_preparation; % make basic objects for analysis

%%
% Figure 3a
f3a = imageConnectionMatrix_MRColorLabels(connectomeMatrix,crossInfo);
% Figure 3b
f3b = imageGeneExpressionMatrix(geneExprLevels,brainInfo);

%% Parameter Setting
main_parameter_setting;

%% Mouse connectome data analysis (Figure 3~5)
rng(1);
% --perform CCA and reconstruction--
mouseConnectomeDataAnalysis = ConnectomeAnalysisRunner(connectomeMatrix, geneExprLevels,crossInfo, ...
    pairDataGenerationOptions,reconstructionParameters,holdoutParameters_main,"FactoryDescription","Main Data Analysis");
mouseConnectomeDataAnalysis = mouseConnectomeDataAnalysis.runAnalysis(ReconstructionStoreTag=true);
% --perform gene analysis--
KTopGene = 30;
relatedGeneAnalysisResults = mouseConnectomeDataAnalysis.performRelatedGeneAnalysis(KTopGene);

%%
% Figure 3c
f3c = plotCorrCoeffs(mouseConnectomeDataAnalysis);
% Figure 3d
f3d = scatterCorrelations(mouseConnectomeDataAnalysis);
% Figure 3e
f3e = imageWiringPIs(mouseConnectomeDataAnalysis,brainSpace,brainInfo);
%% 
% Figure 4a
f4a = histogramsGeneDistributionSimilarity(relatedGeneAnalysisResults);
% Figure 4b
f4b = image3DSimilarGeneDistributions(relatedGeneAnalysisResults,brainSpace,brainInfo);
%% 
% Figure 5a
f5a = imageWiringPIDiffForReconstruction(mouseConnectomeDataAnalysis); % need colorbar: 
% Figure 5b
thresholdList = [0.14,0.18,0.22];
f5b = imageReconstructedMatrixSamples(mouseConnectomeDataAnalysis,"ThreshList",thresholdList);
% Figure 5c
f5c = plotReconstructionROC(mouseConnectomeDataAnalysis,"ThreshList",thresholdList);
% Figure 5d
f5d = swarmHoldoutAUC(mouseConnectomeDataAnalysis);
%% Perform null connectome analysis (Figure 6)
% --make null connectome model--
nullGenerator_global = NullConnectomeGeneratorModel(connectomeMatrix,crossInfo,"RandomGeneration",0, ...
    "Description","RandomGeneration, Golobally");
nullGenerator_local = NullConnectomeGeneratorModel(connectomeMatrix,crossInfo,"RandomGeneration",1, ...
    "Description","RandomGeneration, Locally");

% --make sample matrix--
rng(2)
randomConnectomeSample_global = nullGenerator_global.generate;
randomConnectomeSample_local = nullGenerator_local.generate;

% !!!For Demonstration: Small Number of Test Times!!!
numRandomConnectome = 25; % number of random connectome data per each null model
                  % original analysis: numNullTest = 1000
% --run test--
nullBatchRunner_global = NullModelAnalysisBatchRunner(nullGenerator_global,numRandomConnectome,holdoutParameters_nulls);
nullBatchRunner_global = nullBatchRunner_global.run(mouseConnectomeDataAnalysis);
nullBatchRunner_local = NullModelAnalysisBatchRunner(nullGenerator_local,numRandomConnectome,holdoutParameters_nulls);
nullBatchRunner_local = nullBatchRunner_local.run(mouseConnectomeDataAnalysis);

%%
% figure 6a
f6a(1) = imageConnectionMatrix_MRColorLabels(ConnectionMatrix(randomConnectomeSample_global),crossInfo);
f6a(2) = imageConnectionMatrix_MRColorLabels(ConnectionMatrix(randomConnectomeSample_local),crossInfo);

% figure 6b
f6b = plotRandomTestCorrCoef(mouseConnectomeDataAnalysis,nullBatchRunner_global,nullBatchRunner_local);

% figure 6c
f6c = swarmRandomTestCorrCoef(mouseConnectomeDataAnalysis,nullBatchRunner_global,nullBatchRunner_local);

% figure 6d
f6d = swarmRandomTestAUC(mouseConnectomeDataAnalysis,nullBatchRunner_global,nullBatchRunner_local,"SwarmSize",12);

% figure 6e
f6e(1) = swarmRandomTestSimilarity(nullBatchRunner_global,"Color",colorList(2,:),"SwarmSize",12);
f6e(2) = swarmRandomTestSimilarity(nullBatchRunner_local,"Color",colorList(3,:),"SwarmSize",12);















%% Figure Functions

%% figPosition
function posiVec = figPosition(fwidth,fdepth)
xleft = 55;
ybottom = 5;
posiVec = [xleft ybottom xleft+fwidth ybottom+fdepth];
end
%% Connection Matrix
% Fig3a,5b,6ab,SFig2
function f = imageConnectionMatrix_MRColorLabels(connMat,crossInfo)
arguments(Input)
    connMat ConnectionMatrix
    crossInfo CrossRegionInformation
end
fwidth = 390;
fdepth = 440;
f = figure('Position',figPosition(fwidth,fdepth));
ConnectomeVisualizer.plotConnectomeMatrix_withMRColorLabels(connMat,crossInfo,"DataType","Connections");
set(f,'Color','w')
end

%% Gene Expression
% Fig3b
function f = imageGeneExpressionMatrix(geneExprLevels,brainInfo)
arguments(Input)
    geneExprLevels GeneExpressionLevels
    brainInfo BrainRegionInformation
end
fwidth = 415;
fdepth = 400;
f = figure('Position',figPosition(fwidth,fdepth));
%geneExpressionMatrix = expressionMatrixDefiner(brainRegionalExpressionData,"ExpressionData","Gene");
geneExpressionMatrix = geneExprLevels.ClusteringResults.SortedGeneExpression;
mainAx = axes('Position',[0.1 0.1 0.8 0.8],'OuterPosition',[0 0 1 1]);
hIm = imagesc(geneExpressionMatrix);
mainAx.PlotBoxAspectRatio = [1 1 1];
% colorbar setting
cb = colorbar;
expStd = mean(std(geneExpressionMatrix,1,1));
cLimVec = [-2*expStd,2*expStd];
clim(cLimVec);
cb.Ticks = cb.Limits;
cb.TickLabels = {'Low','High'};
% label setting
[~,MRInitialIndexList,~] = getMajorRegionInfo(brainInfo);
yticks(MRInitialIndexList - 0.5);
yticklabels([])
NGenes = width(geneExpressionMatrix);
xlabelString = strcat(num2str(NGenes)," genes");
xlabel(xlabelString)
xticks([])
% MR color setting
gapWidth = 0.01;
barWidth = 0.01;
hold on
leftAx = setMRColorLabel(brainInfo);
leftAx.Position = [mainAx.Position(1) - gapWidth, ...
                       mainAx.Position(2), ...
                       barWidth, ...
                       mainAx.Position(4)];
linkaxes([mainAx,leftAx],'y');
set(f,'Color','w')
end

%% CCA Correlation
% Fig3c
function f = plotCorrCoeffs(connAnalysisRunner)
arguments(Input)
    connAnalysisRunner ConnectomeAnalysisRunner
end
fwidth = 450;
fdepth = 300;
f = figure('Position',figPosition(fwidth,fdepth));
h = connAnalysisRunner.OverallModelAndResults.plotAllCorrelations("Legend","off");
trainRatio = connAnalysisRunner.HoldoutOptions.TrainRatio;
legendLabels = ["Whole Data",strcat("Hold-out (Train,",num2str(trainRatio*100),"%)"),strcat("Hold-out (Test,",num2str((1-trainRatio)*100),"%)")];
legend(h,legendLabels);
set(f,'Color','w')
end
% Fig3d
function f = scatterCorrelations(connAnalysisRunner,options)
arguments(Input)
    connAnalysisRunner ConnectomeAnalysisRunner
    options.DimShow = 5;
end
DimShow = options.DimShow;
mkSz = 8;
fwidth = 200*DimShow;
fdepth = 200;
f = figure('Position',figPosition(fwidth,fdepth));
ccaResults = connAnalysisRunner.OverallModelAndResults.FullAnalysisModel.CCAResultsData;
t = PairDataCCAResultsVisualizer.tiledScatterCorrelation(ccaResults,DimShow,"MarkerSize",mkSz);
set(f,'Color','w')
end

%% Wiring PI Gradients
% Fig3e
function f = imageWiringPIs(connAnalysisRunner,brainSpace,brainInfo,options)
arguments(Input)
    connAnalysisRunner ConnectomeAnalysisRunner
    brainSpace BrainSpace3D
    brainInfo BrainRegionInformation
    options.DimShow = 5;
end
climVec = [-2.5,2.5];
DimShow = options.DimShow;
fwidth = 250*DimShow;
fdepth = 225*2;
f = figure('Position',figPosition(fwidth,fdepth));
wiringPIPairs = connAnalysisRunner.OverallModelAndResults.FullAnalysisModel.WiringPIPairsData;
PairDataCCAResultsVisualizer.tiledPlotWiringPIs3D(wiringPIPairs,DimShow,brainSpace,brainInfo, ...
    "Clim",climVec);
set(f,'Color','w')
end

%% Gene Distribution Similarity Histograms
% Fig4a
function f = histogramsGeneDistributionSimilarity(relatedGeneAnalysisResults,options)
arguments
    relatedGeneAnalysisResults RelatedGeneAnalysisResults
    options.IsAbs = 0;
    options.DimShow = 5;
end
DimShow = options.DimShow;
fwidth = 225*DimShow;
fdepth = 225*2;
f = figure('Position',figPosition(fwidth,fdepth));
t = relatedGeneAnalysisResults.tiledHistogramsGeneCorrCoef(DimShow,"IsAbs",options.IsAbs);
set(f,'Color','w')
end

%% Gene Spatial Distribution (Most Similar)
% Fig4b
function f = image3DSimilarGeneDistributions(relatedGeneAnalysisResults,brainSpace,brainInfo,options)
arguments
    relatedGeneAnalysisResults RelatedGeneAnalysisResults
    brainSpace BrainSpace3D
    brainInfo BrainRegionInformation
    options.DimShow = 5;
end
DimShow = options.DimShow;
fwidth = 250*DimShow;
fdepth = 225*2;
f = figure('Position',figPosition(fwidth,fdepth));
t = relatedGeneAnalysisResults.tiledImage3DMostCorrelatedGenes(brainSpace,brainInfo,DimShow);
set(f,'Color','w')
end

%% WiringPI Diff Matrix for Reconstruction
% Fig5a
function f = imageWiringPIDiffForReconstruction(connAnalysisRunner)
arguments
    connAnalysisRunner ConnectomeAnalysisRunner
end
fwidth = 390;
fdepth = 440;
f = figure('Position',figPosition(fwidth,fdepth));
piDiffMat = connAnalysisRunner.OverallModelAndResults.FullAnalysisModel.ReconstructionResultsData.PIDistanceMatrix;
connMat = connAnalysisRunner.Factory.ConnectionMatrix;
crossInfo = connAnalysisRunner.Factory.CrossRegionInformation;
ConnectomeVisualizer.plotConnectomeMatrix_withMRColorLabels(connMat,crossInfo,"AnyMatrix",piDiffMat);
set(f,'Color','w')
end

%% Reconstructed Matrix Samples
% Fig 5b
function f = imageReconstructedMatrixSamples(connAnalysisRunner,options)
arguments
    connAnalysisRunner ConnectomeAnalysisRunner
    options.ThreshList = [0.14,0.18,0.22];
end
fwidth = 390;
fdepth = 440;
reconstResults = connAnalysisRunner.OverallModelAndResults.FullAnalysisModel.ReconstructionResultsData;
threshIndices = reconstResults.getThresholdIndices(options.ThreshList);
crossInfo = connAnalysisRunner.Factory.CrossRegionInformation;
for i = 1:numel(options.ThreshList)
    f(i) = figure('Position',figPosition(fwidth,fdepth));
    predMat = cell2mat(reconstResults.PredictedMatrices(threshIndices(i)));
    reconstMat = ConnectionMatrix(predMat);
    ConnectomeVisualizer.plotConnectomeMatrix_withMRColorLabels(reconstMat,crossInfo,"DataType","Connections");
    set(f,'Color','w')
end
end

%% Reconstruction ROC
% Fig5c
function f = plotReconstructionROC(connAnalysisRunner,options)
arguments
    connAnalysisRunner ConnectomeAnalysisRunner
    options.ThreshList = [0.14,0.18,0.22];
end
fwidth = 300;
fdepth = 300;
f = figure('Position',figPosition(fwidth,fdepth));
reconstResults = connAnalysisRunner.OverallModelAndResults.FullAnalysisModel.ReconstructionResultsData;
reconstResults.plotROC("PlotThresholds",options.ThreshList);
set(f,'Color','w')
end

%% AUC of Holdout Validation
% Fig5d
function f = swarmHoldoutAUC(connAnalysisRunner)
arguments
    connAnalysisRunner ConnectomeAnalysisRunner
end
fwidth = 300;
fdepth = 300;
f = figure('Position',figPosition(fwidth,fdepth));
connAnalysisRunner.OverallModelAndResults.swarmAUCs;
set(f,'Color','w')
end

%% Random Test Correlations
% plot
% Fig 6b
function f = plotRandomTestCorrCoef(connAnalysisRunner,globalRunner,localRunner,options)
arguments
    connAnalysisRunner ConnectomeAnalysisRunner
    globalRunner NullModelAnalysisBatchRunner
    localRunner NullModelAnalysisBatchRunner
    options.DataType = "Full"; % or "Train" or "Test"
    options.StdErrorBar = "on";
    options.MarkerSize = 6;
    options.LineWidth = 1;
end
fwidth = 450;
fdepth = 300;
f = figure('Position',figPosition(fwidth,fdepth));
RandomConnectomeTestVisualizer.compareCorrPlot(connAnalysisRunner,globalRunner,localRunner,"DataType",options.DataType);
set(f,'Color','w')
end
%%
% swarm
% Fig 6c
function f = swarmRandomTestCorrCoef(connAnalysisRunner,globalRunner,localRunner,options)
arguments
    connAnalysisRunner ConnectomeAnalysisRunner
    globalRunner NullModelAnalysisBatchRunner
    localRunner NullModelAnalysisBatchRunner
    options.DimShow = 5;
    options.DataType = "Full"; % or "Train" or "Test"
    options.SwarmSize = 6;
end
DimShow = options.DimShow;
fwidth = 300;
fdepth = 300;
f = figure('Position',figPosition(fwidth,fdepth));
RandomConnectomeTestVisualizer.compareCorrSwarm(connAnalysisRunner,globalRunner,localRunner,DimShow,"SwarmSize",options.SwarmSize);
box off
set(f,'Color','w')
end

%% Random Test AUC
function f = swarmRandomTestAUC(connAnalysisRunner,globalRunner,localRunner,options)
arguments
    connAnalysisRunner ConnectomeAnalysisRunner
    globalRunner NullModelAnalysisBatchRunner
    localRunner NullModelAnalysisBatchRunner
    options.DataType = "Full"; % or "Train" or "Test"
    options.SwarmSize = 1.5;
end
fwidth = 300;
fdepth = 300;
f = figure('Position',figPosition(fwidth,fdepth));
RandomConnectomeTestVisualizer.compareAUC(connAnalysisRunner,globalRunner,localRunner,"SwarmSize",options.SwarmSize);
box off
set(f,'Color','w')
end
%% Random Test PI Similarity
function f = swarmRandomTestSimilarity(nullBatchRunner,options)
arguments
    nullBatchRunner NullModelAnalysisBatchRunner
    options.DimShow = 5;
    options.SwarmSize = 1.5;
    options.Color = [0 0.447 0.741];
end
DimShow = options.DimShow;
fwidth = 300;
fdepth = 300;
f = figure('Position',figPosition(fwidth,fdepth));
RandomConnectomeTestVisualizer.swarmRandomTestCorrelations(nullBatchRunner,DimShow,"Color",options.Color, ...
    "DataType","PISimilarity","SwarmSize",options.SwarmSize);
box off
set(f,'Color','w')
end
