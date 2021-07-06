classdef Segmenter < DataTransformer & SegmentationInterface
    %SEGMENTER 
    
    properties
        
    end
    
    %%
    methods
        function obj = Segmenter(name)
            if nargin < 1
                name = [class(Segmenter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@DataTransformer(name);
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            newData = obj.segment(data);
        end
    end
end

