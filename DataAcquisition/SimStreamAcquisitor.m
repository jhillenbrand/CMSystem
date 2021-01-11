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
        DataStream
    end
    
    methods
        function obj = SimStreamAcquisitor(files,bufferSize,stepSize)
            obj@DataAcquisitor(0, true);
            if nargin > 0
                obj.files = files;
                obj.bufferSize = bufferSize;
                obj.stepSize = stepSize;
            end
            DataParserObj = DataParser();
            obj.DataStream = SimulateDataStream_v2(DataParserObj,obj.files,obj.bufferSize,obj.stepSize);
        end
        
        function newData = requestAvailableData(obj)
            %REQUESTAVAILABLEDATA(obj)
            newData = obj.DataStream.getNextTimeStep();
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
        end
        
    end
end

