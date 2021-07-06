% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 06.07.2021
% DEPENDENCY FeatureExtractor.m
classdef MeanExtractor < FeatureExtractor
    %MeanExtractor 
    
    properties        
    end
    
    methods 
        function obj = MeanExtractor(name)
            if nargin < 1
                name = [class(MeanExtractor.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@FeatureExtractor(name);
        end
    end
    
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            
            newData = mean(data, 1);
        end
    end   
end

