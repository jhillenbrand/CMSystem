% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DATE 01.12.2020
% @DEPENDENCY
classdef SimStreamAcquisitor < DataAcquisitor
    %RANDSINEACQUISITOR
    
    properties
        files = {};
        bufferSize = 0;
        stepSize = 0;
        dataStream = [];
        verbose = true;
    end
        
    methods
        function obj = SimStreamAcquisitor(dataParserObj, files, bufferSize, stepSize, verbose)
            obj@DataAcquisitor(0, true);
            if nargin > 0
                obj.files = files;
                obj.bufferSize = bufferSize;
                obj.stepSize = stepSize;
            end
            if nargin < 5
                verbose = true;
            end
            obj.verbose = verbose;
            obj.dataStream = SimulateDataStream_v2(dataParserObj, obj.files, obj.bufferSize, obj.stepSize);
            obj.dataStream.verbose = obj.verbose;
        end
        
        function newData = requestAvailableData(obj)
            %REQUESTAVAILABLEDATA(obj)
            if obj.dataStream.moreDataAvailable
                newData = obj.dataStream.nextData();                
            else
                newData = [];
            end
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            warning(['method requestData is not implemented for ' class(SimStreamAcquisitor.Empty) ', method requestAvailableData is used instead'])
            newData = obj.requestAvailableData();
        end
        
    end
end

