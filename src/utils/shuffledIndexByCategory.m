function idx_shuffled = shuffledIndexByCategory(catArray)
% shuffledIndexByCategory 
%   X = categorical({'A','A','B','B','B','C','C'});
%   idx = shuffledIndexByCategory(X);
%   X_shuffled = X(idx);

    arguments
        catArray (:,1) categorical  %vertical
    end

    % 1. get unique category order
    [~, firstIdx] = unique(catArray, 'stable');
    uniqueCats = catArray(sort(firstIdx));  

    idx_shuffled = [];

    % 2. permute index by each category
    for i = 1:numel(uniqueCats)
        currentCat = uniqueCats(i);
        groupIdx = find(catArray == currentCat);
        shuffledGroup = groupIdx(randperm(numel(groupIdx)));
        idx_shuffled = [idx_shuffled; shuffledGroup];  
    end
end