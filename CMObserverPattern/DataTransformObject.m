% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: v1.0
% DEPENDENCY:
classdef DataTransformObject < handle
    %DATATRANSFORMOBJECT 
    
    properties
        observers = [];
        state = 0;
    end
    
    properties (Access = private)
        subscriberCount = 0;
    end
    
    methods (Abstract)
        
    end
    
    methods
        function count = getNumberOfSubscribers(obj)
            count = obj.subscriberCount;
        end
    end
end

