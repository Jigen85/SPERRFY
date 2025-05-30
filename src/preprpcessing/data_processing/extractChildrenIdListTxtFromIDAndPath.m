function [childrenIdListTxt] = extractChildrenIdListTxtFromIDAndPath(structureId,structureIdPath)


%% same process with ~~fromPath
load("MBStructureTreeData_raw.mat");

idListStr = strrep(structureIdPath,'/',',');
idListStr = strip(idListStr);
idList = str2num(idListStr).';


% i = 1
childrenCell = struct2cell(MBStructureTreeData_raw.children);
childrenIdList = cell2mat(childrenCell(1,:)).';

if length(idList) >= 2
    for i = 2:length(idList)

        id = idList(i);
        nextInd = find(childrenIdList == id);
        checkempty = cell2mat(childrenCell(11,nextInd));
        if isempty(checkempty) == 1
            childrenIdListTxt = "error2:terminal"
            break
        end
        childrenCell = struct2cell(cell2mat(childrenCell(11,nextInd)));
        childrenIdList = cell2mat(childrenCell(1,:)).';
    end
    % childrenIdListTxt = jsonencode(childrenIdList);

else
    childrenIdListTxt = "error1:root"
end

%% additional process
nextInd = find(childrenIdList == structureId);
checkempty = cell2mat(childrenCell(11,nextInd));
if isempty(checkempty) == 1
    childrenIdListTxt = "error3:inputID is terminal";
    return
end
childrenCell = struct2cell(cell2mat(childrenCell(11,nextInd)));
childrenIdList = cell2mat(childrenCell(1,:)).';
childrenIdListTxt = jsonencode(childrenIdList);




end