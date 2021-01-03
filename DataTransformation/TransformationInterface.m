classdef TransformationInterface < matlab.mixin.Heterogeneous & handle
    %TRANSFORMATIONINTERFACE 
        
    methods (Abstract)
        newData = apply(obj, data)
    end
end

