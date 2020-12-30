% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION V0.1
% @DATE 01.12.2020
% @DEPENDENCY
classdef DataAcquisitorInterface < DataTransformerInterface
    %DATAACQUISITORINTERFACE
        
    methods (Abstract)
        % returns the available newData, e.g. in a buffer that was stored in the background at the time of execution
        newData = requestAvailableData(obj)
        
        % returns newData containing newData that is captured for nSamples after method execution
        newData = requestData(obj, nSamples)   
    end
end

