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
            if isempty(obj.dataBuffer)
                obj.dataBuffer = [obj.dataBuffer; data];
            elseif size(obj.dataBuffer, 2) == size(data, 2)
                obj.dataBuffer = [obj.dataBuffer; data];
            else
                error('oops');
            end
        end
    end
end

