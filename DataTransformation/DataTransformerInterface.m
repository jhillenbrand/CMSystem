% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION v1.0 
% @DEPENDENCY 
classdef DataTransformerInterface < handle
    %DATATRANSFORMERINTERFACE 
    
    methods (Abstract)
        %UPDATE executes the transform and transfer method of this
        %   DataTransformer
        update(obj, data);
        
        %TRANSFORM transforms the passed data according to underlying
        %   Transformations
        newData = transform(obj, data);
        
        %TRANSFER passes the transformed data to observing
        %   DataTransformers
        transfer(obj, data);
    end
end

