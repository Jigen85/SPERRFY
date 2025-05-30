% extractDevAdlNmGenes.m
% Extract genes intersecting Developing mouse brain atlas & Mouse brain
% atlas which have no missing values

%% import data

load("geneInfoNonmissing.mat")
load('structureInfoTableOh2014Sorted.mat')
load('expEnergyMatrixOh_nonMissing_sorted_logEps2_zscore.mat')
load('connectionMatrixOhP005_sorted.mat')
load('connectionIndexPairListOhP005_sorted.mat')
load('sortIndex.mat')
load("regionDistanceMatrixOh_sorted.mat")

% data for using specific genes (from Developing Mouse Brain)
load('geneInfoListTable_intersectP28E115.mat')

%%
% for devAtlas gene extraction
% make intersect id list & gene expression matrix
geneIdList_developing = table2array(geneInfoListTable_intersectP28E115(:,'id'));
geneIdList_adultNonmissing = table2array(geneInfoNonmissing(:,'id'));
[geneIdList_intersectDevAdlNm,ia_Dev,ib_Adl] = intersect(geneIdList_developing,geneIdList_adultNonmissing);
geneInfo_intersectDevAdlNm = geneInfoNonmissing(ib_Adl,:);
geneExpEnergyMatrixOh_intersectDevAdlNm_logEps2_zscore = expEnergyMatrixOh_nonMissing_sorted_logEps2_zscore(:,ib_Adl);

%%
% /SPERRFY/data/processed
save("geneExpEnergyMatrixOh_intersectDevAdlNm_logEps2_zscore.mat","geneExpEnergyMatrixOh_intersectDevAdlNm_logEps2_zscore");
save("geneInfo_intersectDevAdlNm.mat","geneInfo_intersectDevAdlNm")