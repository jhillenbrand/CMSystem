classdef Reporter < DataTransformer & ReporterInterface
    %REPORTER 
    
    properties
        
    end
    
    methods
        function report(obj)
            disp('Reported');
        end
    end
end

