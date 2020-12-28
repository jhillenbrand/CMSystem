% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION v1.0 
% @DEPENDENCY DataTransformationInterface.m
classdef DataTransformationInterface < handle
    %DATATRANSFORMATIONINTERFACE 
    
    methods (Abstract)
        update(obj, data);
        newData = transform(obj, data);
        transfer(obj, data);
        addTransform(obj, transform);
    end
end

