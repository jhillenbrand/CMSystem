% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION V0.1
% @DATE 01.12.2020
% @DEPENDENCY DataAcquisitorInterface.m
classdef DataAcquisitor < DataTransformer & DataAcquisitorInterface
    %DATAACQUISITORINTERFACE
    
    properties
        requestSamples = 0;
        requestOnlyAvailable = false;
    end
    
    methods
        function obj = DataAcquisitor(requestSamples, requestOnlyAvailable)
            obj.name = 'DataAcquisitor1';
            if nargin == 1
                requestOnlyAvailable = false;                
            end
            obj.requestSamples = requestSamples;
            obj.requestOnlyAvailable = requestOnlyAvailable;
        end
    end
    
    methods (Abstract)
        % returns the available newData, e.g. in a buffer that was stored in the background at the time of execution
        newData = requestAvailableData(obj)
        
        % returns newData containing newData that is captured for nSamples after method execution
        newData = requestData(obj, nSamples)       
    end
    
    methods 
%         function newData = update(obj, data)
%             obj.active = true;
%             transformedData = obj.transform();
%             newData = obj.transfer(transformedData);
%             obj.active = false;            
%         end
        
        function newData = transform(obj, data)
            if obj.requestOnlyAvailable
                newData = obj.requestAvailableData();
            else
                newData = obj.requestData(obj.requestSamples);
            end
        end
    end
end

