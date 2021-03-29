classdef TimeAppender < DataTransformer
    %TIMEAPPENDER 
    
    properties
        
    end
    
    methods
        function obj = TimeAppender()
            %TIMEAPPENDER 
        end       
    end
    
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            newData = [T.getUTCMillis(now), data];
        end
    end
end

