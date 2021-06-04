% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DATE 04.06.2021
% @DEPENDENCY
classdef ConstantSegmenter < Segmenter
    %ConstantSegmenter 
    
    properties
        threshold = 2;
        minWindowSize = 10;
    end
    
    methods
        function obj = ConstantSegmenter()
            
        end
    end
    
    %% interface methods
    methods
        function newData = transform(obj, data)
            dd = diff(data);
            in = dd < obj.threshold && dd > -obj.threshold;
            
        end
    end
end

