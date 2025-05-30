% main_makeAllFigures.m
set(groot, 'DefaultAxesFontName', 'Arial');
set(groot, 'DefaultTextFontName', 'Arial');
colorList = orderedcolors("gem");
%% Directory
cd(strcat(projectRoot,"/results/figures"));
dt = datetime('now','Format','yyyyMMdd_HHmmss');
dtstr = string(dt);
mkdir(dtstr)
cd(dtstr)
%% Figure 3
% figure 3a
f3a = imageConnectionMatrix_MRColorLabels(connectomeMatrix,crossInfo);
% figure 3b
f3b = imageGeneExpressionMatrix(geneExprLevels,brainInfo);
% figure 3c
f3c = plotCorrCoeffs(mouseConnectomeDataAnalysis);
% figure 3d
f3d = scatterCorrelations(mouseConnectomeDataAnalysis);
% figure 3e
f3e = imageWiringPIs(mouseConnectomeDataAnalysis,brainSpace,brainInfo);

%%
exportgraphics(f3a,'Figure3a.tiff');
exportgraphics(f3b,'Figure3b.tiff');
exportgraphics(f3c,'Figure3c.pdf');
exportgraphics(f3d,'Figure3d.pdf');
exportgraphics(f3e,'Figure3e.pdf');

%% Figure 4
% figure 4a
f4a = histogramsGeneDistributionSimilarity(relatedGeneAnalysisResults);
% figure 4b
f4b = image3DSimilarGeneDistributions(relatedGeneAnalysisResults,brainSpace,brainInfo);
%%
exportgraphics(f4a,'Figure4a.pdf');
exportgraphics(f4b,'Figure4b.pdf');
%% Figure 5
% figure 5a
f5a = imageWiringPIDiffForReconstruction(mouseConnectomeDataAnalysis); % need colorbar: 
% figure 5b
thresholdList = [0.14,0.18,0.22];
f5b = imageReconstructedMatrixSamples(mouseConnectomeDataAnalysis,"ThreshList",thresholdList);
% figure 5c
f5c = plotReconstructionROC(mouseConnectomeDataAnalysis,"ThreshList",thresholdList);
% figure 5d
f5d = swarmHoldoutAUC(mouseConnectomeDataAnalysis);
%%
exportgraphics(f5a,'Figure5a.tiff');
for i = 1:length(thresholdList)
    fName = strcat("Figure5b_",num2str(i),"_",compose('%.2f',thresholdList(i)));
    exportgraphics(f5b(i),strcat(fName,".tiff"));
end
exportgraphics(f5c,'Figure5c.pdf');
exportgraphics(f5d,'Figure5d.pdf');

%% Figure 6
% figure 6a
f6a(1) = imageConnectionMatrix_MRColorLabels(ConnectionMatrix(randomConnectomeSample_global),crossInfo);
f6a(2) = imageConnectionMatrix_MRColorLabels(ConnectionMatrix(randomConnectomeSample_local),crossInfo);
% figure 6b
f6b = plotRandomTestCorrCoef(mouseConnectomeDataAnalysis,nullBatchRunner_1,nullBatchRunner_2);
% figure 6c
f6c = swarmRandomTestCorrCoef(mouseConnectomeDataAnalysis,nullBatchRunner_1,nullBatchRunner_2);
% figure 6d
f6d = swarmRandomTestAUC(mouseConnectomeDataAnalysis,nullBatchRunner_1,nullBatchRunner_2);
% figure 6e
f6e(1) = swarmRandomTestSimilarity(nullBatchRunner_1,"Color",colorList(2,:));
f6e(2) = swarmRandomTestSimilarity(nullBatchRunner_2,"Color",colorList(3,:));
%%
exportgraphics(f6a(1),"Figure6a_1.tiff",'BackgroundColor','none');
exportgraphics(f6a(2),"Figure6a_2.tiff",'BackgroundColor','none');
exportgraphics(f6b,'Figure6b.pdf');
exportgraphics(f6c,'Figure6c.pdf');
exportgraphics(f6d,'Figure6d.pdf');
exportgraphics(f6e(1),'Figure6e_1.pdf');
exportgraphics(f6e(2),'Figure6e_2.pdf');

%% Close Figures
close all
%cd(projectRoot)

%% Tables
[sourceSimGeneTableList,targetSimGeneTableList] =relatedGeneAnalysisResults.makeTopGeneInformationTables(dimPI);
% make xlsx files
for d = 1:dimPI
    simGeneTableSource = sourceSimGeneTableList{d,1};
    simGeneTableTarget = targetSimGeneTableList{d,1};
    fileNameSource = strcat("similarGeneListSource_",num2str(d),".xlsx");
    fileNameTarget = strcat("similarGeneListTarget_",num2str(d),".xlsx");
    writetable(simGeneTableSource, fileNameSource);
    writetable(simGeneTableTarget, fileNameTarget);
end
% memo: Table 1 is the concatenation of these tables


%% Supplementary Figures

%% Supplementary Figure 1
% S.Fig 1a
fs1a = plotPCACumContribution(geneExprLevels);
% S.Fig.1b
fs1b = imagePCMatrix(geneExprLevels,brainInfo);
%%
exportgraphics(fs1a,'SupFigure1a.pdf');
exportgraphics(fs1b,'SupFigure1b.tiff');


%% Supplementary Figure 2
% data preparations
holdoutExample = mouseConnectomeDataAnalysis.OverallModelAndResults.HoldoutUnits(1);
crossInfoExample_train = CrossRegionInformation(brainInfo,brainInfo);
crossInfoExample_train.setDomainDefineMatrix(holdoutExample.SplitInfo.TrainMask);
crossInfoExample_test = CrossRegionInformation(brainInfo,brainInfo);
crossInfoExample_test.setDomainDefineMatrix(holdoutExample.SplitInfo.TestMask);
% S.Fig 2
fs2(1) = imageConnectionMatrix_MRColorLabels(connectomeMatrix,crossInfoExample_train,"DataType","DomainDefine");
fs2(2) = imageConnectionMatrix_MRColorLabels(connectomeMatrix,crossInfoExample_test,"DataType","DomainDefine");
fs2(3) = imageConnectionMatrix_MRColorLabels(connectomeMatrix,crossInfoExample_train);
fs2(4) = imageConnectionMatrix_MRColorLabels(connectomeMatrix,crossInfoExample_test);
%%
exportgraphics(fs2(1),"SupFigure2_1.tiff");
exportgraphics(fs2(2),"SupFigure2_2.tiff");
exportgraphics(fs2(3),"SupFigure2_3.tiff");
exportgraphics(fs2(4),"SupFigure2_4.tiff");

%% Supplementary Figure 3
% S.Fig.3a
fs3a = image3DMajorRegions(brainSpace,brainInfo);
% S.Fig.3b
fs3b = imageConnectomeProperties(connectomeMatrix,crossInfo);
% S.Fig.3c
fs3c = swarmPIValuesByMR(mouseConnectomeDataAnalysis);
%%
exportgraphics(fs3a,'SupFigure3a.pdf');
exportgraphics(fs3b,'SupFigure3b.pdf');
exportgraphics(fs3c,'SupFigure3c.pdf');

%% Supplementary Figure 4
% S.Fig.4a
fs4a(1) = plotRandomTestCorrCoef(mouseConnectomeDataAnalysis,nullBatchRunner_3,nullBatchRunner_4);
fs4a(2) = swarmRandomTestCorrCoef(mouseConnectomeDataAnalysis,nullBatchRunner_3,nullBatchRunner_4);
fs4a(3) = swarmRandomTestAUC(mouseConnectomeDataAnalysis,nullBatchRunner_3,nullBatchRunner_4);
fs4a(4) = swarmRandomTestSimilarity(nullBatchRunner_3,"Color",colorList(2,:));
fs4a(5) = swarmRandomTestSimilarity(nullBatchRunner_4,"Color",colorList(3,:));
% S.Fig.4b
fs4b(1) = plotRandomTestCorrCoef(mouseConnectomeDataAnalysis,nullBatchRunner_5,nullBatchRunner_6);
fs4b(2) = swarmRandomTestCorrCoef(mouseConnectomeDataAnalysis,nullBatchRunner_5,nullBatchRunner_6);
fs4b(3) = swarmRandomTestAUC(mouseConnectomeDataAnalysis,nullBatchRunner_5,nullBatchRunner_6);
fs4b(4) = swarmRandomTestSimilarity(nullBatchRunner_5,"Color",colorList(2,:));
fs4b(5) = swarmRandomTestSimilarity(nullBatchRunner_6,"Color",colorList(3,:));
%%
exportgraphics(fs4a(1),'SupFigure4a_1.pdf');
exportgraphics(fs4a(2),'SupFigure4a_2.pdf');
exportgraphics(fs4a(3),'SupFigure4a_3.pdf');
exportgraphics(fs4a(4),'SupFigure4a_4.pdf');
exportgraphics(fs4a(5),'SupFigure4a_5.pdf');
exportgraphics(fs4b(1),'SupFigure4b_1.pdf');
exportgraphics(fs4b(2),'SupFigure4b_2.pdf');
exportgraphics(fs4b(3),'SupFigure4b_3.pdf');
exportgraphics(fs4b(4),'SupFigure4b_4.pdf');
exportgraphics(fs4b(5),'SupFigure4b_5.pdf');

%% Supplementary Figure 5
fs5(1) = plotCorrVariousPC(variousPCTestResults);
fs5(2) = barAUCVariousPC(variousPCTestResults);
%%
exportgraphics(fs5(1),'SupFigure5_1.pdf');
exportgraphics(fs5(2),'SupFigure5_2.pdf');

%% Legends
f_lg_MR = makeLegendMRs(brainInfo);
f_lg_con = makeLegendConnectome();
f_lg_rand = makeLegendRandomTest();
%%
exportgraphics(f_lg_MR,['legend_MRs.pdf']);
exportgraphics(f_lg_con,['legend_connection.pdf']);
exportgraphics(f_lg_rand,['legend_randomTest.pdf']);

%% 
close all
cd(projectRoot)




















%% Figure Functions

%% figPosition
function posiVec = figPosition(fwidth,fdepth)
xleft = 55;
ybottom = 5;
posiVec = [xleft ybottom xleft+fwidth ybottom+fdepth];
end
%% Connection Matrix
% Fig3a,5b,6ab,SFig2
function f = imageConnectionMatrix_MRColorLabels(connMat,crossInfo,options)
arguments(Input)
    connMat ConnectionMatrix
    crossInfo CrossRegionInformation
    options.DataType = "Connections";
end
fwidth = 390;
fdepth = 440;
f = figure('Position',figPosition(fwidth,fdepth));
ConnectomeVisualizer.plotConnectomeMatrix_withMRColorLabels(connMat,crossInfo,"DataType",options.DataType);
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








%% Supplementary Figures

%% PCA Cumulative Contribution Rate
% S.Fig.1a
function f = plotPCACumContribution(geneExprLevels,options)
arguments
    geneExprLevels GeneExpressionLevels
    options.DimPCA = 50;
end
fwidth = 450;
fdepth = 300;
f = figure('Position',figPosition(fwidth,fdepth));
geneExprLevels.PCAInfo.plotCumulativeContribution("PlotDim",options.DimPCA);
set(f,'Color','w')

end

%% PC Matrix
% S.Fig.1b
function f = imagePCMatrix(geneExprLevels,brainInfo,DimPC)
arguments(Input)
    geneExprLevels GeneExpressionLevels
    brainInfo BrainRegionInformation
    DimPC {mustBeInteger} = 50;
end
fwidth = 415;
fdepth = 400;
f = figure('Position',figPosition(fwidth,fdepth));
expressionMatrix = geneExprLevels.PCAMatrix;
expressionMatrix = expressionMatrix(:,1:DimPC);
mainAx = axes('Position',[0.1 0.1 0.8 0.8],'OuterPosition',[0 0 1 1]);
im = imagesc(expressionMatrix);
mainAx.PlotBoxAspectRatio = [1 1 1];
% colorbar setting
cb = colorbar;
expStd = mean(std(expressionMatrix,1,1));
cLimVec = [-2*expStd,2*expStd];
clim(cLimVec);
cb.Ticks = cb.Limits;
cb.TickLabels = {'Low','High'};
% label setting
[~,MRInitialIndexList,~] = getMajorRegionInfo(brainInfo);
yticks(MRInitialIndexList - 0.5);
yticklabels([])
NGenes = width(expressionMatrix);
xlabelString = strcat("#PC");
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

%% Major Regions in 3D
% S.Fig.3a
function f = image3DMajorRegions(brainSpace,brainInfo)
arguments(Input)
    brainSpace BrainSpace3D
    brainInfo BrainRegionInformation
end
fwidth = 500;
fdepth = 400;
f = figure('Position',figPosition(fwidth,fdepth));
Brain3DStructureVisualizer.image3DBrainMajorRegion(brainSpace,brainInfo);
set(f,'Color','w')
end

%% Heatmap Connectome Properties between MRs
% S.Fig.3b
function f = imageConnectomeProperties(connMat,crossInfo)
arguments(Input)
    connMat ConnectionMatrix
    crossInfo CrossRegionInformation
end
fwidth = 950;
fdepth = 450;
f = figure('Position',figPosition(fwidth,fdepth));
t = tiledlayout(1,2);
ax = nexttile;
ConnectomeVisualizer.heatmapProjectionFeaturesBetweenMRs(connMat,crossInfo,"Feature","counts","ParentAxes",ax);
colorbar off
ax = nexttile;
ConnectomeVisualizer.heatmapProjectionFeaturesBetweenMRs(connMat,crossInfo,"Feature","density","ParentAxes",ax);
colorbar
h.FontName = 'Arial';
set(f,'Color','w')
end

%% Swarmchart Wiring PI Values per Major Region
% S.Fig.3c
function f = swarmPIValuesByMR(connAnalysisRunner,options)
arguments
    connAnalysisRunner ConnectomeAnalysisRunner
    options.DimShow = 5;
end
DimShow = options.DimShow;
fwidth = 300*DimShow;
fdepth = 250*2;
f = figure('Position',figPosition(fwidth,fdepth));
wiringPIPairs = connAnalysisRunner.OverallModelAndResults.FullAnalysisModel.WiringPIPairsData;
crossInfo = connAnalysisRunner.Factory.CrossRegionInformation;
PairDataCCAResultsVisualizer.tiledSwarmPIValuesByMR(wiringPIPairs,crossInfo,DimShow);
set(f,'Color','w')
end

%% Various PC Test
% S.Fig.5_1
function f = plotCorrVariousPC(variousPCTestResults,options)
arguments(Input)
    variousPCTestResults (1,:) OverallAnalysisGroup
    options.LineWidth = 2;
    options.MarkerSize = 12;
    options.PlotDim = 10;
end
fwidth = 800;
fdepth = 300;
f = figure('Position',figPosition(fwidth,fdepth));
t = tiledlayout(1,3);
lineWidth = options.LineWidth;
mkSz = options.MarkerSize;
pltDim = options.PlotDim;
nexttile
for l = 1:length(variousPCTestResults)
    l_model = variousPCTestResults(l);
    rList  = l_model.FullAnalysisModel.CCAResultsData.r(1,1:pltDim);
    h = plot(rList,'.-','LineWidth',lineWidth,'MarkerSize',mkSz);
    ylim([-0.1,1.0001])
    xlim([1,10])
    hold on
end
axis square
box off
xlabel("Correlaton Component (Rank)")
ylabel("Correlation coefficient")
nexttile
for l = 1:length(variousPCTestResults)
    l_model = variousPCTestResults(l);
    rList  = l_model.HoldoutSummary.TrainMeanCorrelation(1,1:pltDim);
    h = plot(rList,'.-','LineWidth',lineWidth,'MarkerSize',mkSz);
    ylim([-0.1,1.0001])
    xlim([1,10])
    hold on
end
axis square
box off
xlabel("Correlaton Component (Rank)")
ylabel("Correlation coefficient")
nexttile
for l = 1:length(variousPCTestResults)
    l_model = variousPCTestResults(l);
    rList  = l_model.HoldoutSummary.TestMeanCorrelation(1,1:pltDim);
    rList = rList(1:10);
    h = plot(rList,'.-','LineWidth',lineWidth,'MarkerSize',mkSz);
    ylim([-0.1,1.0001])
    xlim([1,10])
    hold on
end
axis square
box off
xlabel("Correlaton Component (Rank)")
ylabel("Correlation coefficient")
% legend
legendlabel = ["10","25","50","75","100"];
legend(legendlabel)
set(f,'Color','w')
end

%%
% S.Fig.5_2
function f = barAUCVariousPC(variousPCTestResults)
arguments(Input)
    variousPCTestResults (1,:) OverallAnalysisGroup
end
fwidth = 800;
fdepth = 300;
f = figure('Position',figPosition(fwidth,fdepth));
t = tiledlayout(1,3);
colorList = orderedcolors("gem");
NVariousPC = length(variousPCTestResults);
AUCListWhole = zeros(NVariousPC,1);
AUCListTrain = zeros(NVariousPC,1);
AUCListTest = zeros(NVariousPC,1);
for l = 1:length(variousPCTestResults)
    AUCListWhole(l,1) = variousPCTestResults(l).FullAnalysisModel.ReconstructionResultsData.AUC_ROC;
    AUCListTrain(l,:) = variousPCTestResults(l).HoldoutSummary.TrainMeanAUC_ROC;
    AUCListTest(l,:) = variousPCTestResults(l).HoldoutSummary.TestMeanAUC_ROC;
end
nexttile
b = bar(AUCListWhole);
b.FaceColor = 'flat';
b.CData = colorList(1:NVariousPC,:);
axis square
box off
ylim([0.5 1])
xticklabels([10 25 50 75 100])
xlabel("Number of PC")
ylabel("AUC")
nexttile
b = bar(mean(AUCListTrain,2));
b.FaceColor = 'flat';
b.CData = colorList(1:NVariousPC,:);
ylim([0.5 1])
xticklabels([10 25 50 75 100])
axis square
box off
xlabel("Number of PC")
ylabel("AUC")
nexttile
b = bar(mean(AUCListTest,2));
b.FaceColor = 'flat';
b.CData = colorList(1:NVariousPC,:);
ylim([0.5 1])
xticklabels([10 25 50 75 100])
axis square
box off
xlabel("Number of PC")
ylabel("AUC")
set(f,'Color','w')
end




%% Legends only
function f = makeLegendMRs(brainInfo)
arguments
    brainInfo BrainRegionInformation
end
MRNameList = brainInfo.getMajorRegionInfo;
load('colorList13.mat')
fwidth = 200;
fdepth = 250;
f = figure('Position',figPosition(fwidth,fdepth));
makeLegendsByDummyPlot(MRNameList,colorList13,'Marker','square');
set(f,'Color','w')
end

function f = makeLegendConnectome()
labelNameList = ["Connected","Not connected","Excluded from analysis"];
colorList = zeros(3,3);
cmap = parula;
colorList(1,:) = cmap(256,:);
colorList(2,:) = cmap(1,:);
colorList(3,:) = [0 0 0];
fwidth = 200;
fdepth = 100;
f = figure('Position',figPosition(fwidth,fdepth));
makeLegendsByDummyPlot(labelNameList,colorList,'Marker','square');
set(f,'Color','w')
end


function f = makeLegendRandomTest()
labelNameList = ["Original connectome data","Golobally randomized model","Locally randomized model"];
load('colorList13.mat')
colorList = colorList13(7:9,:);
fwidth = 200;
fdepth = 100;
f = figure('Position',figPosition(fwidth,fdepth));
makeLegendsByDummyPlot(labelNameList,colorList,'Marker','o');
set(f,'Color','w')
end