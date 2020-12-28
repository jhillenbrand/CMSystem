classdef TransformInterface < handle
    %TRANSFORMINTERFACE 
        
    methods (Abstract)
        newData = apply(obj, data)
    end
end

