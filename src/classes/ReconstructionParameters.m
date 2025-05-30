classdef ReconstructionParameters
    properties
        DimPI (1,1) {mustBeInteger}
        ThreshWidth (1,1) double
    end

    methods
        function obj = ReconstructionParameters(dimPI,threshWidth)
            obj.DimPI = dimPI;
            if mod(1/threshWidth,1) == 0
                obj.ThreshWidth = threshWidth;
            else
                error("threshWidth must be 1/{Integer}")
            end
        end

        function thresholds = getThresholds(obj)
            thresholds = 0:obj.ThreshWidth:1;
        end

    end

end