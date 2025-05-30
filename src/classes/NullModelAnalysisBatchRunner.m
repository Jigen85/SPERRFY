classdef NullModelAnalysisBatchRunner
    % Manages batch execution of null model analyses using NullModelAnalysisUnit

    properties
        GeneratorModel NullConnectomeGeneratorModel        
        NumUnits (1,1) {mustBeInteger}
        HoldoutOptions HoldoutParameters
        % results holder
        FullDataCorrs (:,:) % [#numUnits,dimCCA]
        FullDataAUCs (:,1) % [#numUnits,1]
        HoldoutTrainCorrMeans (:,:)
        HoldoutTrainAUCMeans (:,1) 
        HoldoutTestCorrMeans (:,:)
        HoldoutTestAUCMeans (:,1)
        WirigPISimilarities (:,:)
        Description
    end

    methods
        function obj = NullModelAnalysisBatchRunner(generator, numUnits, holdoutOptions,options)
            arguments
                generator NullConnectomeGeneratorModel
                numUnits (1,1) {mustBeInteger}
                holdoutOptions HoldoutParameters
                options.Description = [];
            end
            obj.GeneratorModel = generator;
            obj.NumUnits = numUnits;
            obj.HoldoutOptions = holdoutOptions;
            obj.Description = options.Description;
            if isempty(options.Description)
                obj.Description = generator.Description;
            end
        end

        function obj = run(obj,originalRunner)
            arguments
                obj NullModelAnalysisBatchRunner
                originalRunner ConnectomeAnalysisRunner
            end
            numUnit = obj.NumUnits;
            originalWiringPIPairs = originalRunner.OverallModelAndResults.FullAnalysisModel.WiringPIPairsData;
            DimPI = width(originalWiringPIPairs.WiringPISource);
            % make results holder
            fullDataCorrs = zeros(numUnit,DimPI);
            fullDataAUCs = zeros(numUnit,1);
            holdoutTrainCorrMeans = zeros(numUnit,DimPI);
            holdoutTrainAUCMeans = zeros(numUnit,1);
            holdoutTestCorrMeans = zeros(numUnit,DimPI);
            holdoutTestAUCMeans = zeros(numUnit,1);
            wiringPISimilarities = zeros(numUnit,DimPI);
            dispStr = strcat("=== Start running '",inputname(1),"' ===");
            disp(dispStr)
            for i = 1:obj.NumUnits
                if mod(i,100) == 0
                    dispStr = strcat("i = ",num2str(i));
                    disp(dispStr)
                end
                [nullConnMat,nullDomDef] = obj.GeneratorModel.generate();
                nullAnalysisUnit = NullModelAnalysisUnit(nullConnMat, nullDomDef, obj.HoldoutOptions,originalRunner);
                nullAnalysisUnit = nullAnalysisUnit.run();
                nullAnalysisUnit = nullAnalysisUnit.calculatePISimilarityScore(originalWiringPIPairs);
                fullDataCorrs(i,:) = nullAnalysisUnit.getFullDataCorrs();
                fullDataAUCs(i,1) = nullAnalysisUnit.getFullDataAUC();
                holdoutTrainCorrMeans(i,:) = nullAnalysisUnit.getHoldoutTrainMeanCorrs();
                holdoutTrainAUCMeans(i,1) = nullAnalysisUnit.getHoldoutTrainMeanAUC();
                holdoutTestCorrMeans(i,:) = nullAnalysisUnit.getHoldoutTestMeanCorrs();
                holdoutTestAUCMeans(i,1) = nullAnalysisUnit.getHoldoutTestMeanAUC();
                wiringPISimilarities(i,:) = nullAnalysisUnit.WiringPISimilarity;
            end
            obj.FullDataCorrs = fullDataCorrs;
            obj.FullDataAUCs = fullDataAUCs;
            obj.HoldoutTrainCorrMeans = holdoutTrainCorrMeans;
            obj.HoldoutTrainAUCMeans = holdoutTrainAUCMeans;
            obj.HoldoutTestCorrMeans = holdoutTestCorrMeans;
            obj.HoldoutTestAUCMeans = holdoutTestAUCMeans;
            obj.WirigPISimilarities = wiringPISimilarities;
            dispStr = strcat("=== Finish running '",inputname(1),"' ===");;
            disp(dispStr)
        end

        function T = summarizeAll(obj)
            % Return a summary table of all units
            summaries = arrayfun(@(u) u.summarize(), obj.Units);
            T = struct2table(summaries);
        end
    end
end
