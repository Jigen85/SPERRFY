function [upstreamID] = extractUpstreamID(structureIdPath)

idListStr = strrep(structureIdPath,'/',',');
idListStr = strip(idListStr);
idList = str2num(idListStr).';

upstreamID = idList(length(idList) - 1);

end