classdef Historian < Reporter
    %HISTORIAN 
    
    properties
    end
    
    methods
        function obj = Historian()
            %HISTORIAN Construct an instance of this class
            
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            obj.report(data);
            newData = obj.dataBuffer;
        end
        
        function report(obj, data)
            obj.dataBuffer = [obj.dataBuffer; data];
        end
    end
end

