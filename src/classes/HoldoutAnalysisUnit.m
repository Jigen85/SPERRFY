classdef HoldoutAnalysisUnit
    % HoldoutAnalysisUnit
    % A class that represents one round of holdout analysis, including
    % the train model and the evaluation metrics on the test data.

    properties
        TrainModel    PairDataCCAAnalysisModel
        TestMetrics   HoldoutTestMetrics
        SplitInfo     HoldoutSplit % (train/test mask etc.)
    end

    methods
        function obj = HoldoutAnalysisUnit(trainModel, splitInfo)
            % Constructor
            arguments
                trainModel PairDataCCAAnalysisModel
                splitInfo HoldoutSplit
            end
            obj.TrainModel = trainModel;
            obj.SplitInfo = splitInfo;
            obj.TestMetrics = HoldoutTestMetrics.empty;  % Initialized as empty, filled after evaluation
        end

        function obj = runTestMetrics(obj, testPairDataSet, refConnMat)
            % Evaluate the model on the test dataset.
            % This method computes correlation and other metrics on the test data
            % using the trained model's parameters (no re-training).
            arguments
                obj HoldoutAnalysisUnit
                testPairDataSet ConnectomeGenePairDataSet
                refConnMat (:,:)  % connection matrix (not necessary masked) 
            end
            testMetrics = HoldoutTestMetrics(testPairDataSet);
            trainCCAResuls = obj.TrainModel.CCAResultsData;
            trainWiringPIPairs = obj.TrainModel.WiringPIPairsData;
            trainReconstructionResults = obj.TrainModel.ReconstructionResultsData;
            testMetrics = testMetrics.computeTestCorrelation(trainCCAResuls,trainWiringPIPairs);
            testMetrics = testMetrics.computeTestReconstruction(trainReconstructionResults,refConnMat);
            obj.TestMetrics = testMetrics;
        end

%{
        function summary = getSummary(obj)
            % Returns a summary struct of key results.
            if isempty(obj.TestMetrics)
                summary = struct( ...
                    'Correlation', NaN, ...
                    'ReconstructionAUC', NaN, ...
                    'NumTestSamples', 0 ...
                );
            else
                summary = struct( ...
                    'Correlation', obj.TestMetrics.Correlation, ...
                    'ReconstructionAUC', obj.TestMetrics.ReconstructionAUC ...
                );
            end
        end
%}
    end
end