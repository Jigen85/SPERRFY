classdef DistanceDistributionBins
    properties
        BinWidth (1,1) {mustBeInteger}
        BinNumber (1,1) {mustBeInteger}
        Bins (:,1) DistributionBinContents
        BinQuantityList (:,1) {mustBeInteger}
        DistanceMatrixSize (1,2) {mustBeInteger}
    end

    methods
        function obj = DistanceDistributionBins(distanceMatrix,countDomainDefineMatrix,binWidth)
            arguments
                distanceMatrix (:,:) double
                countDomainDefineMatrix (:,:) logical;
                binWidth (1,1) double
            end
            maxDistance = max(distanceMatrix,[],'all');
            binNumber = ceil(maxDistance/binWidth);
            NaNMaskMatrix = ones(size(countDomainDefineMatrix));
            NaNMaskMatrix(~logical(countDomainDefineMatrix)) = NaN;
            distanceMatrixNaNMasked = distanceMatrix .* NaNMaskMatrix;
            for bn = 1:binNumber
                binLeft = (bn - 1) * binWidth;
                binContents = DistributionBinContents(distanceMatrixNaNMasked,binLeft,binWidth);
                obj.Bins(bn,1) = binContents;
                obj.BinQuantityList(bn,1) = binContents.ContentsQuantity;
            end
            obj.BinNumber = binNumber;
            obj.BinWidth = binWidth;
            obj.DistanceMatrixSize = size(distanceMatrix);
        end

        function [randomConnectionMatrix] = makeRandomIdenticalDistributionConnectionMatrix(obj,objPopulation)
            arguments
                obj DistanceDistributionBins
                objPopulation DistanceDistributionBins
            end
            if obj.BinWidth ~= objPopulation.BinWidth
                error("different bin width error")
            end
            refBinNumber = obj.BinNumber;
            randomConnectionMatrix = zeros(obj.DistanceMatrixSize);
            for nb = 1:refBinNumber
                refBinContents = obj.Bins(nb,1);
                popBinContents = objPopulation.Bins(nb,1);
                nRefBinContents = refBinContents.ContentsQuantity;
                if nRefBinContents > 0
                    nPopBinContents = popBinContents.ContentsQuantity;
                    permVec = randperm(nPopBinContents,nRefBinContents);
                    randIndPairList = popBinContents.SourceTargetIndexPairs(permVec,:);
                    for nrbc = 1:nRefBinContents
                        randomConnectionMatrix(randIndPairList(nrbc,1),randIndPairList(nrbc,2)) = 1;
                    end
                end
            end
        end
    
    end
            



end
