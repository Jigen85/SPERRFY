classdef PairDataCCAAnalysisModel
    % PairDataCCAAnalysisModel
    % Performs CCA analysis and computes Wiring PI in a single workflow.

    properties
        CCAResultsData CCAResults               % Stores CCAResults object
        WiringPIPairsData WiringPIPairs         % Stores WiringPIResults object
        ReconstructionResultsData ReconstructionResults % Store ReconstructionResults object
    end

    methods
        function obj = PairDataCCAAnalysisModel()
            % Constructor (default)
        end

        function obj = runCCAAnalysis(obj, genePairData, geneExpressionLevels, pairGenerationOptions)
            % runAnalysis - Runs CCA and Wiring PI calculation in one step
            arguments
                obj PairDataCCAAnalysisModel
                genePairData ConnectomeGenePairDataSet
                geneExpressionLevels GeneExpressionLevels
                pairGenerationOptions PairDataGenerationOptions
            end

            % 1. Extract source & target gene expression matrices
            X = genePairData.SourceExpressions;
            Y = genePairData.TargetExpressions;
            valueType = pairGenerationOptions.DataType;
            valueDim = pairGenerationOptions.DataDimension;
            if valueDim ~= width(X)
                error("pair data dimension is not consistent to pair data generation options")
            end            

            % 2. Run CCA and store CCA Results
            ccaResults = CCAResults(X,Y);

            % 3. Compute Wiring PI
            % PI = gene expression * canonical weight vectors
            switch valueType
                case "PC"
                    expressionMatrix = geneExpressionLevels.PCAMatrix(:,1:valueDim);
                case "gene"
                    expressionMatrix = geneExpressionLevels.ExpressionMatrix;
            end
            X_mean = mean(X,1);
            Y_mean = mean(Y,1);
            correctedExprSource = expressionMatrix - repmat(X_mean,[height(expressionMatrix),1]);
            correctedExprTarget = expressionMatrix - repmat(Y_mean,[height(expressionMatrix),1]);

            PISource = correctedExprSource * ccaResults.A;
            PITarget = correctedExprTarget * ccaResults.B;

            piPairs = WiringPIPairs(PISource,PITarget);
            
            obj.CCAResultsData = ccaResults;
            obj.WiringPIPairsData = piPairs;
        end

        function obj = runReconstructionAnalysis(obj,reconstParams,trueConnMat,domainMask,options)
            arguments
                obj PairDataCCAAnalysisModel
                reconstParams ReconstructionParameters
                trueConnMat (:,:)
                domainMask (:,:) logical
                options.StoreMatrixTag (1,1) logical = 0;
                options.ArbitralPIDistanceMatrix = [];
            end
            reconstResults = ReconstructionResults(reconstParams);
            reconstResults = reconstResults.compute(obj.WiringPIPairsData,trueConnMat,domainMask, ...
                "ArbitralPIDistanceMatrix",options.ArbitralPIDistanceMatrix,"StoreMatrixTag",options.StoreMatrixTag);
            obj.ReconstructionResultsData = reconstResults;
        end

        

    end
end