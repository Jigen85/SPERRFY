classdef WiringPIPairs
    properties
        WiringPISource (:,:) double %[#Region, DimCCAComponents]
        WiringPITarget (:,:) double %[#Region, DimCCAComponents]
    end

    methods
        function obj = WiringPIPairs(wiringPISource,wiringPITarget)
            arguments
                wiringPISource (:,:) double
                wiringPITarget (:,:) double
            end
            obj.WiringPISource = wiringPISource;
            obj.WiringPITarget = wiringPITarget;
        end

        function simScoreList = calculatePISimilarities(obj,refWiringPIPairs)
            arguments
                obj WiringPIPairs
                refWiringPIPairs WiringPIPairs
            end
            DimPI = min(width(obj.WiringPISource),width(refWiringPIPairs.WiringPISource));
            simScoreList = zeros(1,DimPI);
            for dpi = 1:DimPI
                origPIVecSrc = obj.WiringPISource(:,dpi);
                origPIVecTgt = obj.WiringPITarget(:,dpi);
                refPIVecSrc = refWiringPIPairs.WiringPISource(:,dpi);
                refPIVecTgt = refWiringPIPairs.WiringPITarget(:,dpi);
                simScoreList(1,dpi) = WiringPIPairs.calculateSimilarityScore(origPIVecSrc,origPIVecTgt,refPIVecSrc,refPIVecTgt);
            end
        end


    end

    methods (Static)
        function simScore = calculateSimilarityScore(origPIVecSrc,origPIVecTgt,refPIVecSrc,refPIVecTgt)
            arguments
                origPIVecSrc (:,1) double
                origPIVecTgt (:,1) double
                refPIVecSrc (:,1) double
                refPIVecTgt (:,1) double
            end
            srcSim = corr(origPIVecSrc,refPIVecSrc);
            tgtSim = corr(origPIVecTgt,refPIVecTgt);
            simScore = abs((srcSim+tgtSim)/2);
        end
    end

end
                