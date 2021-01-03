% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION v1.0 
% @DEPENDENCY Transformation.m
classdef SegmentationTransformation < Transformation
    %SEGMENTATIONTRANSFORMATION
    
    methods
        function obj = SegmentationTransformation(funcHandle, name)
            obj@Transformation(funcHandle, name);
        end
    end
end

