% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 11.09.2022
% DEPENDENCY FeatureExtractor.m
classdef FeatureSimulator < FeatureExtractor
    %FeatureSimulator 
    
    properties
        dataAvailable = false;
        featureMatrix = [];
        i = 0;
    end
    
    methods 
        function obj = FeatureSimulator(name, featureMatrix)
            if nargin < 1
                name = [class(FeatureSimulator.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@FeatureExtractor(name);
            if ~isempty(featureMatrix)
                obj.featureMatrix = featureMatrix;
                obj.dataAvailable = true;
            end
        end
    end
    
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data) 
            obj.i = obj.i + 1;
            if (obj.i > size(obj.featureMatrix, 1))
                obj.dataAvailable = false;
                error("No more data in featureMatrix")
            elseif (obj.i == size(obj.featureMatrix, 1))
                obj.dataAvailable = false;
                warning("No more data for next transform in featureMatrix")
                newData = obj.featureMatrix(obj.i, :);
            else 
                newData = obj.featureMatrix(obj.i, :);
            end
        end

        function reset(obj)
            if ~isempty(obj.featureMatrix)
                obj.dataAvailable = true;
                obj.i = 0;
            else
                error(['cannot reset '  class(FeatureSimulator.empty) ' with empty featureMatrix'])
            end
        end
    end   
end

