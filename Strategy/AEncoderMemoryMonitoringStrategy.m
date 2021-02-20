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
                memory
                %disp(['CMSystem required memory [bytes]: ' num2str(w.bytes)])
            end
        end
    end
end

