% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DATE 01.12.2020
% @DEPENDENCY
classdef SimStreamAcquisitor < DataAcquisitor
    %RANDSINEACQUISITOR
    
    properties
        files
        bufferSize
        stepSize
        dataStream
    end
    
    methods
        function obj = SimStreamAcquisitor(dataParserObj, files, bufferSize, stepSize)
            obj@DataAcquisitor(0, true);
            if nargin > 0
                obj.files = files;
                obj.bufferSize = bufferSize;
                obj.stepSize = stepSize;
            end
            obj.dataStream = SimulateDataStream_v2(dataParserObj, obj.files, obj.bufferSize, obj.stepSize);
        end
        
        function newData = requestAvailableData(obj)
            %REQUESTAVAILABLEDATA(obj)
            newData = obj.dataStream.getNextTimeStep();
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            warning(['method requestData is not implemented for ' class(SimStreamAcquisitor.Empty) ', method requestAvailableData is used instead'])
            newData = obj.requestAvailableData();
        end
        
    end
end

