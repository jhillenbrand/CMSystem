
classdef SegmentationTransformation < Transformation
    %SEGMENTATIONTRANSFORMATION
    
    methods
        function obj = SegmentationTransformation(funcHandle, name)
            obj@Transformation(funcHandle, name);
        end
    end
end

