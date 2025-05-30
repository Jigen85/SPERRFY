classdef CCAResults
    properties
        A
        B
        r
        U
        V
        stats
    end

    methods
        function obj = CCAResults(XMatrix,YMatrix)
            [A,B,r,U,V,stats] = canoncorr(XMatrix,YMatrix);
            obj.A = A;
            obj.B = B;
            obj.r = r;
            obj.U = U;
            obj.V = V;
            obj.stats = stats;
        end
    end

end
