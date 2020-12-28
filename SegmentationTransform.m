
classdef SegmentationTransform < Transform
    %SEGMENTATIONTRANSFORM 
    
    methods
        function obj = SegmentationTransform(funcHandle, name)
            obj@Transform(funcHandle, name);
        end
    end
end

