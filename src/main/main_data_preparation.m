% === main_data_preparetion.m ===
%% === Prepare connectome data ===
connectomeMatrix = ConnectionMatrix(mouseBrainConnectomeMatrix);  % <-- input matrix
brainInfo = BrainRegionInformation(brainRegionInformationTable);
brainSpace = BrainSpace3D(annotation3D_right_brainRegions);
brainSpace.setRegionCenterCoord(coordinate3D_right_brainRegions);
brainSpace.setMajorRegionIndex3D(annotation3D_right_majorRegions);
crossInfo = CrossRegionInformation(brainInfo, brainInfo);
crossInfo.setDistanceMatrix(brainRegionDistanceMatrix);
domDefMat_DiffMR = crossInfo.makeDifferentMajorRegionDomainDefineMatrix();
crossInfo.setDomainDefineMatrix(domDefMat_DiffMR);
%% === Prepare gene expression data ===
geneInfo = GeneInformation(geneInformationTable);  % <-- input gene information
geneExprLevels = GeneExpressionLevels(geneExpressionMatrix, ...
    1:height(geneExpressionMatrix),geneInfo.getGeneAcronyms,geneInfo.getGeneNames);  % <-- input gene expression matrix
geneExprLevels.performPCA;
geneExprLevels.performGeneClustering;
