function p = createFigureParser(extraParams)
    % Create an inputParser with a standard 'Parent' parameter.
    p = inputParser;
    addParameter(p, 'Parent', []);  % Always include Parent

    if nargin > 0 && ~isempty(extraParams)
        for i = 1:2:length(extraParams)
            name = extraParams{i};
            defaultVal = extraParams{i+1};
            addParameter(p, name, defaultVal);
        end
    end
end