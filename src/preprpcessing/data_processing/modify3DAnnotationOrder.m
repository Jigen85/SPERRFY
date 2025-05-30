% modify 3D annotation order

load('ANO100_ConMatIndOh_subCompManually_onlyRight.mat') %[DV,AP,LR]
load('gaussianCenterCoordList_subCompManually.mat') %[DV,AP,LR]
load('ANO100_majorRegion_onlyRight.mat')


[DVSize,APSize,LRSize] = size(ANO100_ConMatIndOh_subCompManually_onlyRight);

ANO100_onlyRight_LRAPDV_flipped = permute(ANO100_ConMatIndOh_subCompManually_onlyRight,[3,2,1]);
ANO100_onlyRight_LRAPDV_flipped = flip(ANO100_onlyRight_LRAPDV_flipped,1);
ANO100_onlyRight_LRAPDV_flipped = flip(ANO100_onlyRight_LRAPDV_flipped,3);

CDVs = gaussianCenterCoordList_subCompManually(:,1);
CDVs = -(CDVs - DVSize/2 - 0.5) + DVSize/2 + 0.5;
CAPs = gaussianCenterCoordList_subCompManually(:,2);
CLRs = gaussianCenterCoordList_subCompManually(:,3);
CLRs = -(CLRs - LRSize/2 - 0.5) + LRSize/2 + 0.5;

ANO100RegionCenterCoordList_LRAPDV_flipped = [CLRs,CAPs,CDVs];


ANO100_majorRegion_LRAPDV_flipped = permute(ANO100_majorRegion_onlyRight,[3,2,1]);
ANO100_majorRegion_LRAPDV_flipped = flip(ANO100_majorRegion_LRAPDV_flipped,1);
ANO100_majorRegion_LRAPDV_flipped = flip(ANO100_majorRegion_LRAPDV_flipped,3);

%% cd /SPERRFY/data/processed
save("ANO100_onlyRight_LRAPDV_flipped.mat","ANO100_onlyRight_LRAPDV_flipped");
save("ANO100RegionCenterCoordList_LRAPDV_flipped.mat","ANO100RegionCenterCoordList_LRAPDV_flipped");
save("ANO100_majorRegion_LRAPDV_flipped.mat","ANO100_majorRegion_LRAPDV_flipped");