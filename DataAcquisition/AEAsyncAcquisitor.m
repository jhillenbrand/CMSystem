% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION V0.1
% @DATE 01.12.2020
% @DEPENDENCY JavaDux.m
classdef AEAsyncAcquisitor < DataAcquisitor
    %AEDATAACQUISITOR
    
    properties
        javaDux = JavaDUX.empty;
        dataParser = DataParser.empty;
    end
    
    methods
        function obj = AEAsyncAcquisitor()            
            obj.dataParser = DataParser('FileType', 'bin');            
            obj.dataParser.BitFormat = 'int16';
            obj.dataParser.bigEndian = true; 
        end
    end
    methods 
        
        function newData = requestAvailableData(obj)
            %REQUESTAVAILABLEDATA(obj)
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            t = T.getUTCMillis(now);
            folderPath = 'F:\20210330_axialbearing_cmsystemTestAen\';
            filePath = [folderPath num2str(t) 'cmsystemTestAen_1.bin'];
            timeout = 0.75;
            
            obj.javaDux.getMeasurementAsync(nSamples, filePath);
            DataParser.waitForFileBeingWrittenTo(filePath, timeout)

            dp.readFile('fileName');
            
            newData = dp.Data;
        end
        
        function setJavaDux(obj, javaDux)
            obj.javaDux = javaDux;
        end
        
        function setDefaultJavaDux(obj)
            obj.javaDux = JavaDux(1, 2e6, '192.168.1.150', 2020, 'ae_mini_pc3', 'aeversuch', '/home/ae_mini_pc3/ae/duxToTCPServer', 650e3, '', 'ae_dux_int16', 20e6, 200);
        end
    end
end

