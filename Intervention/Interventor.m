classdef Interventor < InterventorInterface
    %INTERVENTOR 
    
    properties
        
    end
    
    methods
        function obj = Interventor()
            obj.name = 'Interventor1';
        end
    end
    
    methods (Abstract)
        intervene(obj);
    end
end

