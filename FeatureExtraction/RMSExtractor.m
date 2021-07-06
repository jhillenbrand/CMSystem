% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 06.07.2021
% DEPENDENCY FeatureExtractor.m
classdef RMSExtractor < FeatureExtractor
    %RMSExtractor 
    
    properties        
    end
    
    methods 
        function obj = RMSExtractor(name)
            if nargin < 1
                name = [class(RMSExtractor.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@FeatureExtractor(name);
        end
    end
    
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            
            newData = rms(data, 2);
        end
    end   
end

