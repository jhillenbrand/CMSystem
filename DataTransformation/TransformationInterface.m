classdef TransformationInterface < handle
    %TRANSFORMATIONINTERFACE 
        
    methods (Abstract)
        newData = apply(obj, data)
    end
end

