classdef ConnectionMatrix < handle
    % ConnectionMatrix
    % Handles pure connection matrix (source x target) without any metadata.

    properties
        Matrix double            % [N_source x N_target] connection matrix (binary or weighted)
        IndexPairList double     % [#connections x 2] (optional) source-target index pairs
    end

    methods
        function obj = ConnectionMatrix(M)
            arguments
                M double
            end
            obj.Matrix = M;
            obj.IndexPairList = obj.matrix2indPair();
        end

        function I = matrix2indPair(obj)
            % Convert connection matrix to index pair list (nonzero elements)
            [s, t] = find(obj.Matrix);
            I = [s, t];
        end

        function M = indPair2matrix(obj)
            % Convert index pair list back to binary connection matrix
            nSrc = max(obj.IndexPairList(:,1));
            nTgt = max(obj.IndexPairList(:,2));
            M = zeros(nSrc, nTgt);
            for k = 1:size(obj.IndexPairList,1)
                M(obj.IndexPairList(k,1), obj.IndexPairList(k,2)) = 1;
            end
        end

        function n = getNumSources(obj)
            n = size(obj.Matrix,1);
        end

        function n = getNumTargets(obj)
            n = size(obj.Matrix,2);
        end

        function plotRawConnectionMatrix(obj)
            % plotRawMatrix: Plots the raw connection matrix without labels.
            imagesc(obj.Matrix);
            axis square
            title('Raw Connection Matrix');
            xlabel('Target Regions');
            ylabel('Source Regions');
        end
    end
end
