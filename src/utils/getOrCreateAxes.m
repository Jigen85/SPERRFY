function hAx = getOrCreateAxes(parentArg)
% getOrCreateAxes: Return axes handle based on provided Parent argument.
%
% Usage:
%   hAx = getOrCreateAxes(opts.Parent);
%
% If parentArg is provided (non-empty), it is returned as hAx.
% If parentArg is empty, a new axes is created in the current figure.
% (Figure is NOT created automatically; assumes a figure already exists.)

    if ~isempty(parentArg)
        % If Parent is specified, use it
        hAx = parentArg;
    else
        % If no Parent is provided, create axes in the current figure
        hAx = axes;
    end
end
