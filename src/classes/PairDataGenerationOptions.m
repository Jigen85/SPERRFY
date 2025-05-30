classdef PairDataGenerationOptions
    properties
        NoiseLevel double {mustBeNonnegative}
        DataType string  % "PC" or "gene"
        DataDimension double {mustBePositive}
        RngSeed {mustBeInteger}
    end

    methods
        function obj = PairDataGenerationOptions(noiseLevel,dataType,dataDimension,rngSeed)
            arguments
                noiseLevel 
                dataType 
                dataDimension 
                rngSeed = [];
            end
            obj.NoiseLevel = noiseLevel;
            obj.DataType = dataType;
            obj.DataDimension = dataDimension;
            if obj.DataType == "gene"
                obj.DataDimension = "all";
            end
            if ~isempty(rngSeed)
                obj.RngSeed = rngSeed;
            end
        end
    end
end