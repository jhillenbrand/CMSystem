% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION V0.1
% @DATE 01.12.2020
% @DEPENDENCY JavaDux.m
classdef AEAcquisitor < DataAcquisitor
    %AEDATAACQUISITOR
    
    properties
        javaDux = JavaDUX.empty;
    end
    
    methods        
        function newData = requestAvailableData(obj)
            %REQUESTAVAILABLEDATA(obj)
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            newData = obj.javaDux.getMeasurement(nSamples);
        end
        
        function setJavaDux(obj, javaDux)
            obj.javaDux = javaDux;
        end
        
        function setDefaultJavaDux(obj)
            obj.javaDux = JavaDux(1, 2e6, '192.168.1.150', 2020, 'ae_mini_pc3', 'aeversuch', '/home/ae_mini_pc3/ae/duxToTCPServer', 650e3, '', 'ae_dux_int16', 20e6, 200);
        end
    end
end

