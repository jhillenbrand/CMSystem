% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION V0.1
% @DATE 01.12.2020
% @DEPENDENCY JavaDux.m
classdef RandSineAcquisitor < DataAcquisitor
    %RANDSINEACQUISITOR
    
    properties
        minSamples = 1e3;
        maxSamples = 100e3;
        sampleRate = 50e3;
        maxWaves = 10;   
        maxFreq = 10e3;    
        maxAmpl = 10; % 
        maxNoise = 0.5; % white noise level as percentage of amplitude
    end
    
    methods
        function obj = RandSineAcquisitor(sampleRate)
            obj@DataAcquisitor(10e6, true);
            if nargin > 0
                obj.sampleRate = sampleRate;
            end
        end
        
        function newData = requestAvailableData(obj)
            %REQUESTAVAILABLEDATA(obj)
            newData = obj.createRandSines();
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            newData = obj.createRandSines(nSamples);
        end
        
        function newData = createRandSines(obj, nSamples)
            if nargin < 2
                newData = SignalAnalysis.createRandSines(obj.sampleRate, obj.maxSamples, obj.minSamples, obj.maxWaves, obj.maxAmpl, obj.maxNoise, obj.maxFreq);
            else
                newData = SignalAnalysis.createRandSines(obj.sampleRate, nSamples, nSamples, obj.maxWaves, obj.maxAmpl, obj.maxNoise, obj.maxFreq);
            end
        end
    end
end

