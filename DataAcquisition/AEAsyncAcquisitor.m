% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION V0.1
% @DATE 01.12.2020
% @DEPENDENCY JavaDux.m
classdef AEAsyncAcquisitor < DataAcquisitor
    %AEDATAACQUISITOR
    
    properties
        javaDux = JavaDUX.empty;
        dataParser = DataParser.empty;
        folderPath = [];
        fileID = [];
        async = false;
        requestSamplesLearning = [];
        requestSamplesMonitoring = [];
    end
    
    methods
        function obj = AEAsyncAcquisitor(requestSamplesLearning,requestOnlyAvailable,requestSamplesMonitoring,async,folderPath,fileID)
            obj@DataAcquisitor(requestSamplesLearning, requestOnlyAvailable);
            obj.requestSamplesMonitoring = requestSamplesMonitoring;
            obj.requestSamplesLearning = requestSamplesLearning;
            obj.folderPath = folderPath;
            obj.fileID = fileID;
            obj.async = async;
            if async
                obj.dataParser = DataParser('FileType', 'bin');            
                obj.dataParser.BitFormat = 'int16';
                obj.dataParser.bigEndian = true; 
            end           
        end
    end
    
    methods 
        
        function newData = requestAvailableData(obj)
            %REQUESTAVAILABLEDATA(obj)
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            t = T.getUTCMillis(now);
            filePath = [obj.folderPath num2str(t) '_' obj.fileID];
            if obj.async
                timeout = 0.75;

                obj.javaDux.getMeasurementAsync(nSamples, [filePath '.bin']);
                DataParser.waitForFileBeingWrittenTo(filePath, timeout)

                obj.dataParser.readFile(filePath);

                newData = obj.dataParser.Data;
            else
                data = obj.javaDux.getMeasurement(nSamples);
                save(filePath, 'data');
                newData = data;
            end
        end
        
        function setJavaDux(obj, javaDux)
            obj.javaDux = javaDux;
        end
        
        function setDefaultJavaDux(obj)
            obj.javaDux = JavaDux(1, 2e6, '192.168.1.150', 2020, 'ae_mini_pc3', 'aeversuch', '/home/ae_mini_pc3/ae/duxToTCPServer', 650e3, '', 'ae_dux_int16', 20e6, 200);
        end
        
        function learningMode(obj)
            obj.requestSamples = obj.requestSamplesLearning;
        end
        
        function monitoringMode(obj)
            obj.requestSamples = obj.requestSamplesMonitoring;
        end
        
        
    end
end

