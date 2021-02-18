classdef WatchDog < DataTransformer & WatchDogInterface
    %INTERVENTOR 
    
    properties
        
    end
    
    methods
        function obj = WatchDog()
            obj.name = 'WatchDog';
        end
    end
    
    methods (Abstract)
        bark(obj);
    end
end

