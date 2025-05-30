classdef DistributionBinContents
    properties
        ContentsQuantity (1,1) {mustBeInteger}
        BinDomain (1,2) double
        DistanceList (:,1) double
        SourceTargetIndexPairs (:,2) {mustBeInteger}
    end

    methods
        function obj = DistributionBinContents(distanceMatrixNaNMasked,binLeft,binWidth)
            detectionMatrix = (distanceMatrixNaNMasked >= binLeft) & (distanceMatrixNaNMasked < (binLeft + binWidth));
            [row,col,v] = find(detectionMatrix);
            contentsQuantity = height(v);
            obj.ContentsQuantity = contentsQuantity;
            obj.BinDomain = [binLeft,binLeft+binWidth];
            if contentsQuantity ~= 0
                indexPairs = zeros(contentsQuantity,2);
                indexPairs(:,1) = row;
                indexPairs(:,2) = col;
                obj.SourceTargetIndexPairs = indexPairs;
                obj.DistanceList = v;
            end
        end
    end
end