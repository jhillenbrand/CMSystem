classdef Segmenter < DataTransformer & SegmentationInterface
    %SEGMENTER 
    
    properties
        
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            newData = obj.segment(data);
        end
    end
end

