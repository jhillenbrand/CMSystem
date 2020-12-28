classdef Reporter < ReporterInterface
    %REPORTER 
    
    properties
        name = 'Reporter1';
    end
    
    methods (Abstract)
        report();
    end
end

