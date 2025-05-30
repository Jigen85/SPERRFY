classdef BrainSpace3D < handle
    % BrainSpace3D
    % Handles 3D spatial structure of brain regions independently of their attributes.

    properties
        VoxelSize (1,3) {mustBeInteger}    % [LR, AP, DV] dimensions
        DomainDefineTags3D (:,:,:) logical % Logical mask for defined voxels
        RegionIndex3D (:,:,:) {mustBeInteger} % 3D array of region IDs
        RegionCenterCoord (:,3) {mustBeNumeric} % Optional: Center coordinates for each region
        MajorRegionIndex3D (:,:,:) {mustBeInteger} % Optional: Major Region Index per voxel
    end

    methods
        function obj = BrainSpace3D(regionAnnotation3DMatrix)
            arguments
                regionAnnotation3DMatrix (:,:,:) {mustBeInteger}
            end
            obj.VoxelSize = size(regionAnnotation3DMatrix);
            obj.DomainDefineTags3D = (regionAnnotation3DMatrix > 0);
            obj.RegionIndex3D = regionAnnotation3DMatrix;
        end

        function setRegionCenterCoord(obj, centerCoord)
            arguments
                obj BrainSpace3D
                centerCoord (:,3) {mustBeNumeric}
            end
            obj.RegionCenterCoord = centerCoord;
        end
        
        function setMajorRegionIndex3D(obj, majorIndex3D)
            arguments
                obj BrainSpace3D
                majorIndex3D (:,:,:) {mustBeInteger}
            end
            obj.MajorRegionIndex3D = majorIndex3D;
        end

        function [LRSize,APSize,DVSize] = getVoxelSize(obj)
            arguments 
                obj BrainSpace3D
            end
            LRSize = obj.VoxelSize(1);
            APSize = obj.VoxelSize(2);
            DVSize = obj.VoxelSize(3);
        end

        function [CLRs,CAPs,CDVs] = getCenterCoordinates(obj)
            CLRs = obj.RegionCenterCoord(:,1);
            CAPs = obj.RegionCenterCoord(:,2);
            CDVs = obj.RegionCenterCoord(:,3);
        end




    end
end
