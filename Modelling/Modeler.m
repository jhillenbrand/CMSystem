classdef Modeler < DataTransformer
    %MODELER 
    
    properties
        
    end
    
    methods
        function obj = Modeler(name)
            if nargin < 1
                name = [class(Modeler.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@DataTransformer(name);
        end
    end
end

