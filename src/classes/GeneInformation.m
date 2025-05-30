classdef GeneInformation < handle
    % GeneInformation
    % Manages gene metadata including acronym, full name, and unique ID.

    properties
        GeneTable table   % Table must include: acronym, name, id
    end

    methods
        function obj = GeneInformation(tbl)
            arguments
                tbl table
            end

            requiredFields = {'acronym', 'name', 'id'};
            if ~all(ismember(requiredFields, tbl.Properties.VariableNames))
                error('Input table must contain acronym, name, and id.');
            end

            obj.GeneTable = tbl;
        end

        function acronyms = getGeneAcronyms(obj)
            acronyms = obj.GeneTable.acronym;
        end

        function names = getGeneNames(obj)
            names = obj.GeneTable.name;
        end

        function ids = getGeneIDs(obj)
            ids = obj.GeneTable.id;
        end

        function row = findGeneByAcronym(obj, acronymName)
            idx = strcmp(obj.GeneTable.acronym, acronymName);
            if any(idx)
                row = obj.GeneTable(idx, :);
            else
                warning('Acronym "%s" not found.', acronymName);
                row = table();
            end
        end

        function [row] = findGeneByID(obj, idValue)
            idx = obj.GeneTable.id == idValue;
            if any(idx)
                row = obj.GeneTable(idx, :);
            else
                warning('Gene ID %d not found.', idValue);
                row = table();
            end
        end
    end
end
