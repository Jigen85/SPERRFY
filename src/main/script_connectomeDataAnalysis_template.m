% ConnectomeDataAnalysis Script Template
% This script performs full + holdout analysis on an arbitrary connectome dataset

%% === Step 1: Load or prepare connectome data ===
connectomeMatrix = ConnectionMatrix(connectionMatrixOhP005_sorted);  % <-- input matrix
brainInfo = BrainRegionInformation(structureInfoTableOh2014Sorted);
brainSpace = BrainSpace3D(ANO100_onlyRight_LRAPDV_flipped);
brainSpace.setRegionCenterCoord(ANO100RegionCenterCoordList_LRAPDV_flipped);
brainSpace.setMajorRegionIndex3D(ANO100_majorRegion_LRAPDV_flipped);
crossInfo = CrossRegionInformation(brainInfo, brainInfo);
crossInfo.setDistanceMatrix(regionDistanceMatrixOh_sorted);
domDefMat_DiffMR = crossInfo.makeDifferentMajorRegionDomainDefineMatrix();
crossInfo.setDomainDefineMatrix(domDefMat_DiffMR);
%% === Step 2: Load or prepare gene expression data ===
geneInfo = GeneInformation(geneInfo_intersectDevAdlNm);  % <-- input gene information
geneExprLevels = GeneExpressionLevels(geneExpEnergyMatrixOh_intersectDevAdlNm_logEps2_zscore, ...
    1:height(geneExpEnergyMatrixOh_intersectDevAdlNm_logEps2_zscore),geneInfo.getGeneAcronyms,geneInfo.getGeneNames);  % <-- input gene expression matrix
geneExprLevels.performPCA;
%% === Step 3: Define pair data generation options ===
noiseLevel = 0.01;
dataType = "PC";
dataDim = 50;
rngSeed = 1;
pairDataGenerationOptions = PairDataGenerationOptions(noiseLevel,dataType,dataDim,rngSeed);

%% === Step 4: Create analysis factory ===
dataFactory = AnalysisDataFactory(connectomeMatrix,geneExprLevels,crossInfo);

%% === Step 5: Generate full data analysis ===
fullPairData = dataFactory.generatePairData([],pairDataGenerationOptions,"Description","Full data pair of original connectome (Different MR)");
fullModel = PairDataCCAAnalysisModel();
fullModel = fullModel.runCCAAnalysis(fullPairData,geneExprLevels,pairDataGenerationOptions);
dimPI = 5;
threshWidth = 0.01;
reconstructionParameters = ReconstructionParameters(dimPI,threshWidth);
fullModel = fullModel.runReconstructionAnalysis(reconstructionParameters,connectomeMatrix.Matrix,crossInfo.DomainDefineMatrix,"StoreMatrixTag",true);

%% === Step 6: Generate holdout splits and analyses ===
numSplits = 10;
trainRatio = 0.8;
holdoutUnitCells = cell(numSplits,1);
splitDescription = "Random holdout split, train:test = 8:2";
trueConnMat = connectomeMatrix.Matrix;
rng(rngSeed)

for i = 1:numSplits
    [trainMask,testMask] = generateRandomHoldoutMasks(crossInfo,trainRatio);
    holdoutSplit = HoldoutSplit(trainMask, testMask, splitDescription);
    [trainSet, testSet] = dataFactory.generateHoldoutPairData(holdoutSplit, ...
        pairDataGenerationOptions);
    trainModel = PairDataCCAAnalysisModel();
    trainModel = trainModel.runCCAAnalysis(trainSet,geneExprLevels,pairDataGenerationOptions);
    trainModel = trainModel.runReconstructionAnalysis(reconstructionParameters,trueConnMat,trainSet.DomainDefineMask,"StoreMatrixTag",true);    
    holdoutUnit = HoldoutAnalysisUnit(trainModel,holdoutSplit);
    holdoutUnit = holdoutUnit.runTestMetrics(testSet,trueConnMat);
    holdoutUnitCells{i,1} = holdoutUnit;
end
holdoutUnitList = [holdoutUnitCells{:}].';

%% === Step 7: Combine results into overall analysis group ===
overallAnalysisGroup = OverallAnalysisGroup(fullModel);
overallAnalysisGroup = overallAnalysisGroup.addHoldoutUnitArray(holdoutUnitList);
overallAnalysisGroup = overallAnalysisGroup.computeHoldoutSummary;

%% === Step 8: Save or visualize results ===
% save('dataAnalysisResults.mat', 'overallGroup');

% Optional visualization (you implement these)
% overallGroup.plotSummary();
