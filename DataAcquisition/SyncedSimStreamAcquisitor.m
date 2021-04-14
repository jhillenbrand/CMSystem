% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DATE 01.12.2020
% @DEPENDENCY DataAcquisitor.m, DataParser.m
classdef SyncedSimStreamAcquisitor < DataAcquisitor
    %SyncedSimStreamAcquisitor
    
    properties
        dataParser = [];
        linkedAcquisitor = [];       
    end
        
    methods
        function obj = SyncedSimStreamAcquisitor(dataParser, folderPath)
            obj@DataAcquisitor(0, true);
            if nargin > 0
                obj.dataParser = dataParser;
                obj.folderPath = folderPath;
            end
        end
    end
    
    %% Interface Methods
    methods
        function newData = requestAvailableData(obj)
            
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            warning(['method requestData is not implemented for ' class(SyncedSimStreamAcquisitor.empty) ', method requestAvailableData is used instead'])
            newData = obj.requestAvailableData();
        end
        
    end
end

