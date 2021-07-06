classdef Reporter < DataTransformer & ReporterInterface
    %REPORTER 
    
    properties
        
    end
    
    methods
        function obj = Reporter(name)
            if nargin < 1
                name = ['Reporter [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@DataTransformer(name);
        end
    end
end

