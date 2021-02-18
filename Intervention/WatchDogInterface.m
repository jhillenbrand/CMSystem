classdef WatchDogInterface < matlab.mixin.Heterogeneous & handle
    %WATCHDOGINTERFACE
    
    methods (Abstract)
        bark(obj);
    end
end

