classdef AEncoderMemoryMonitoringStrategy < CMStrategy
    %AENCODERMEMORYMONITORINGSTRATEGY 
    
    properties
        
    end
    
    methods
        function obj = AEncoderMemoryMonitoringStrategy(name)
            %AEMONITORINGSTRATEGY
            obj@CMStrategy(name);
        end
    end
    
    methods 
        function out = execute(obj, cmSystem)
            while true
                cmSystem.aeDataAcquisitor.update([]);                
            end
        end
    end
end

