% AUTHOR jonas.hillenbrand@kit.edu
% VERSION V0.1
% DATE 02.01.2021
% DEPENDENCY DataTransformer.m
classdef Normalizator < Preprocessor
    %Normalizator 
    
    properties
        normalizer = Normalizer.empty;
    end
    
    methods
        function obj = Normalizator(name, methodName)
            obj@Preprocessor(name, []);
            obj.normalizer = Normalizer(methodName);
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            if size(data, 1) < 2
                warning('At least two samples of each feature are required for Normalization');
                newData = [];
            else
                newData = obj.normalizer.normalize(data);
            end
        end
    end
end

