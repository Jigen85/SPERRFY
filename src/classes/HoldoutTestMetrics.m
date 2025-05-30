classdef HoldoutTestMetrics
    properties
        TestPairData ConnectomeGenePairDataSet
        TestPseudeCCAResults CCAResults
        TestPseudeReconstructionResults ReconstructionResults
    end

    methods
        function obj = HoldoutTestMetrics(testPairData)
            arguments
                testPairData ConnectomeGenePairDataSet
            end
            obj.TestPairData = testPairData;
        end

        function obj = computeTestCorrelation(obj,trainCCARResults,trainWiringPIPairs)
            % Apply train CCA transform to test data
            arguments
                obj HoldoutTestMetrics
                trainCCARResults CCAResults
                trainWiringPIPairs WiringPIPairs
            end
            sourceIdx = obj.TestPairData.SourceIDs;
            targetIdx = obj.TestPairData.TargetIDs;
            pseudeCCAResults = trainCCARResults;
            pseudeCCAResults.U = trainWiringPIPairs.WiringPISource(sourceIdx,:);
            pseudeCCAResults.V = trainWiringPIPairs.WiringPITarget(targetIdx,:);
            corrVals = diag(corr(pseudeCCAResults.U , pseudeCCAResults.V))';
            pseudeCCAResults.r = corrVals;
            obj.TestPseudeCCAResults = pseudeCCAResults;
        end

        function obj = computeTestReconstruction(obj,testReconstrucionResults,refConnMat)
            % Use PI difference matrix from train and apply test mask
            arguments
                obj HoldoutTestMetrics
                testReconstrucionResults ReconstructionResults
                refConnMat (:,:) % connection matrix (not necessary masked) 
            end
            pseudeReconstructionResults = ReconstructionResults(testReconstrucionResults.Parameters);
            testMask = obj.TestPairData.DomainDefineMask;
            trueConnMat = refConnMat .* testMask;
            dummyWiringPI = WiringPIPairs(1,1); % to avoid input error
            piDistanceMatrix = testReconstrucionResults.PIDistanceMatrix;
            pseudeReconstructionResults = pseudeReconstructionResults.compute( ...
                dummyWiringPI,trueConnMat,testMask, ...
                "ArbitralPIDistanceMatrix",piDistanceMatrix);
            obj.TestPseudeReconstructionResults = pseudeReconstructionResults;
        end
    end
end