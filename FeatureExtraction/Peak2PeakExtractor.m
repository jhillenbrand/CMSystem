% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 06.07.2021
% DEPENDENCY FeatureExtractor.m
classdef Peak2PeakExtractor < FeatureExtractor
    %Peak2PeakExtractor 
    
    properties        
    end
    
    methods 
        function obj = Peak2PeakExtractor(name)
            if nargin < 1
                name = [class(Peak2PeakExtractor.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@FeatureExtractor(name);
        end
    end
    
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            
            newData = SignalAnalysis.peakToPeak(data);
        end
    end   
end

