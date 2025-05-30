classdef HoldoutResultsSummary
    % HoldoutResultsSummary
    % Aggregates summary statistics across multiple HoldoutAnalysisUnit objects.

    properties
        TrainAllCorrelations    % [numSplits x numComponents] matrix
        TrainMeanCorrelation    % [1 x numComponents] vector
        TrainAllAUCs_ROC            % [1 x numSplits] vector
        TrainMeanAUC_ROC            % scalar

        TestAllCorrelations     % [numSplits x numComponents] matrix
        TestMeanCorrelation     % [1 x numComponents] vector
        TestAllAUCs_ROC             % [1 x numSplits] vector
        TestMeanAUC_ROC             % scalar
    end

    methods
        function obj = HoldoutResultsSummary(holdoutUnits)
            arguments
                holdoutUnits (1,:) HoldoutAnalysisUnit
            end

            numSplits = numel(holdoutUnits);
            numComponents = length(holdoutUnits(1).TrainModel.CCAResultsData.r);

            trainCorr = zeros(numSplits, numComponents);
            trainAUC = zeros(1, numSplits);
            testCorr = zeros(numSplits, numComponents);
            testAUC = zeros(1, numSplits);

            for i = 1:numSplits
                unit = holdoutUnits(i);

                trainCorr(i, :) = unit.TrainModel.CCAResultsData.r;
                trainAUC(i) = unit.TrainModel.ReconstructionResultsData.AUC_ROC;

                testCorr(i, :) = unit.TestMetrics.TestPseudeCCAResults.r;
                testAUC(i) = unit.TestMetrics.TestPseudeReconstructionResults.AUC_ROC;
            end

            obj.TrainAllCorrelations = trainCorr;
            obj.TrainMeanCorrelation = mean(trainCorr, 1);
            obj.TrainAllAUCs_ROC = trainAUC;
            obj.TrainMeanAUC_ROC = mean(trainAUC);

            obj.TestAllCorrelations = testCorr;
            obj.TestMeanCorrelation = mean(testCorr, 1);
            obj.TestAllAUCs_ROC = testAUC;
            obj.TestMeanAUC_ROC = mean(testAUC);
        end
    end
end
