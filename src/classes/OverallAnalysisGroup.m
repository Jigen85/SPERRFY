classdef OverallAnalysisGroup
    % OverallAnalysisGroup
    % Manages the main full-data analysis and associated holdout analyses.

    properties
        FullAnalysisModel (1,1) PairDataCCAAnalysisModel            % PairDataCCAAnalysisModel or equivalent
        HoldoutUnits (:,1) HoldoutAnalysisUnit           % Array of HoldoutAnalysisUnit
        HoldoutSummary HoldoutResultsSummary                %class for aggregated stats
    end

    methods
        function obj = OverallAnalysisGroup(fullModel)
            arguments
                fullModel PairDataCCAAnalysisModel
            end
            obj.FullAnalysisModel = fullModel;
            obj.HoldoutUnits = HoldoutAnalysisUnit.empty;
        end

        function obj = addHoldoutUnitArray(obj, unitArray)
            arguments
                obj OverallAnalysisGroup
                unitArray (:,1) HoldoutAnalysisUnit
            end
            obj.HoldoutUnits = [obj.HoldoutUnits, unitArray];
        end

        function obj = addHoldoutUnit(obj, unit)
            arguments
                obj OverallAnalysisGroup
                unit (1,1) HoldoutAnalysisUnit
            end
            obj.HoldoutUnits(end+1) = unit;
        end

        
        function obj = computeHoldoutSummary(obj)
            obj.HoldoutSummary = HoldoutResultsSummary(obj.HoldoutUnits);
        end

        function [hAx] = plotAllCorrelations(obj,options)
            arguments(Input)
                obj OverallAnalysisGroup
                options.PlotDim = width(obj.FullAnalysisModel.CCAResultsData.r);
                options.ParentAxes = []; % must be 'matlab.graphics.axis.Axes' or empty
                options.LineWidth = 1;
                options.MarkerSize = 6;
                options.Legend = "on";
            end
            % Get axes
            hAx = getOrCreateAxes(options.ParentAxes);
            % make figure
            rFullData = obj.FullAnalysisModel.CCAResultsData.r;
            rHoldoutTrainMean = obj.HoldoutSummary.TrainMeanCorrelation;
            rHoldoutTestMean = obj.HoldoutSummary.TestMeanCorrelation;
            h(1) = plot(rFullData,'.-','LineWidth',options.LineWidth*2,'MarkerSize',options.MarkerSize*2);
            hold on
            h(2) = plot(rHoldoutTrainMean,'.-','LineWidth',options.LineWidth,'MarkerSize',options.MarkerSize);
            hold on
            h(3) = plot(rHoldoutTestMean,'.-','LineWidth',options.LineWidth,'MarkerSize',options.MarkerSize);
            ylim([-0.1,1.0001])
            xlim([0,50])
            ylabel("Correlation Coefficient")
            xlabel("Correlation Component (Rank)")
            box off
            if options.Legend == "on"
                legendLabels = ["Whole Data","Hold-out (Train)","Hold-out (Test)"];
                legend(h,legendLabels);
            end
        end
        
        function [hAx] = swarmAUCs(obj,options)
            arguments
                obj OverallAnalysisGroup
                options.ParentAxes = []; % must be 'matlab.graphics.axis.Axes' or empty
                options.SzWholePlot = 36;
                options.SzSwarm = 8;
            end
            % Get axes
            hAx = getOrCreateAxes(options.ParentAxes);
            fullAUC = obj.FullAnalysisModel.ReconstructionResultsData.AUC_ROC;
            trainAUCs = obj.HoldoutSummary.TrainAllAUCs_ROC;
            testAUCs = obj.HoldoutSummary.TestAllAUCs_ROC;
            x1 = 1;
            x2 = ones(size(trainAUCs)) *2;
            x3 = ones(size(testAUCs)) *3;
            swarmchart(x1,fullAUC,options.SzWholePlot,'filled');
            hold on
            swarmchart(x2,trainAUCs,options.SzSwarm,'filled');
            hold on
            swarmchart(x3,testAUCs,options.SzSwarm,'filled');
            hold on
            plot([0.5,3.5],[fullAUC,fullAUC],'k')
            xticks(1:3)
            xticklabels(["Whole","Train","Test"])
            ylim([0.45,1])
            yticks(0.5:0.1:1)
            axis square
        end
    end
end