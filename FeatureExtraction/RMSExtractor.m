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
            if isscalar(data)
                newData = rms(data);
                warning('RMS feature applied on 1D data, is computing the absolute value')
            elseif isvector(data)
                newData = rms(data(:));
            elseif ismatrix(data)                
                newData = rms(data, 2);
            else
                error(['data input of type=' type(data) ' is not supported'])
            end
        end
    end   
end

