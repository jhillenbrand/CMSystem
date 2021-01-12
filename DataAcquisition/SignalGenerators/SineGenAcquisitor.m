% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DATE 01.12.2020
% @DEPENDENCY DataAcquisitor.m
classdef SineGenAcquisitor < DataAcquisitor
    %RANDSINEACQUISITOR
    
    properties
        a1 = 1;
        a2 = 0.5;
        f1 = 1;
        f2 = 3;
        no1 = 0.1;
        no2 = 0.15;
        f_sr = 1e3;
        t_0 = 0;
    end
    
    methods
        function obj = SineGenAcquisitor(n, f_sr)
            obj@DataAcquisitor(n, true);
            if nargin < 2
                obj.f_sr = 1e3;
            end
            obj.f_sr = f_sr;
        end
        
        function newData = requestAvailableData(obj)
            %REQUESTAVAILABLEDATA(obj)
            [newData1, t] = SignalAnalysis.noisySine(obj.f_sr, obj.requestSamples, obj.a1, obj.f1, obj.no1, 0, obj.t_0);
            [newData2, t] = SignalAnalysis.noisySine(obj.f_sr, obj.requestSamples, obj.a2, obj.f2, obj.no2, 0, obj.t_0);
            newData = newData1 + newData2;
            obj.t_0 = t(end);
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            newData = obj.requestAvailableData();
        end        
    end
end

