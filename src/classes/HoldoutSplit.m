classdef HoldoutSplit
    properties
        TrainMask (:,:) logical     % [#Region,#Region] 
        TestMask (:,:) logical      % [#Region,#Region] 
        Description string       % explanation for split（e.g. 'RandomSplit_Seed42'）
    end

    methods
        function obj = HoldoutSplit(trainMask, testMask, description)
            arguments
                trainMask (:,:) logical
                testMask (:,:) logical
                description string = ""
            end
            % set data
            obj.TrainMask = trainMask;
            obj.TestMask = testMask;
            obj.Description = description;
            % validation (simple)
            obj = obj.validateMasks();
        end

        function obj = validateMasks(obj)
            % check size of train/test mask
            szTrain = size(obj.TrainMask);
            szTest = size(obj.TestMask);
            if ~isequal(szTrain, szTest)
                error('TrainMask and TestMask must have the same size.');
            end
        end

        function summary(obj)
            % display information
            nTrain = nnz(obj.TrainMask);
            nTest = nnz(obj.TestMask);
            fprintf('HoldoutSplit: %s\n', obj.Description);
            fprintf('  Train region pairs: %d\n', nTrain);
            fprintf('  Test region pairs: %d\n', nTest);
        end
    end
end