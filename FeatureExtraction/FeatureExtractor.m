% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY TransformationInterface.m
classdef FeatureExtractor < DataTransformer
    %FEATUREEXTRACTOR 
    
    properties
        
    end
    
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            newData = [];
            for t = 1 : length(obj.transformations)
                trafo = obj.transformations(t);
                trafoData = trafo.apply(data);
                newData = [newData, trafoData(:)];
            end
        end
    end
end

