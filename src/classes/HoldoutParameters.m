classdef HoldoutParameters
    properties
        TrainRatio double % 0.0 ~ 1.0
        NumSplits {mustBeInteger}
        RngSeed = [];
    end

    methods
        function obj = HoldoutParameters(trainRatio,numSplits,options)
            arguments
                trainRatio double
                numSplits {mustBeInteger}
                options.rngSeed = [];
            end
            obj.TrainRatio = trainRatio;
            obj.NumSplits = numSplits;
            obj.RngSeed = options.rngSeed;
        end
    end
end