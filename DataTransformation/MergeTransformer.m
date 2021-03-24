classdef MergeTransformer < DataTransformer
    %MERGETRANSFORMER merges the inputs from multiple datatransformers to
    %   one single output before transferring
    
    properties
        transformCount = 0; % current count of received inputs
        forks = []; % number of different inputs that shall be merged
    end
    
    methods
        function obj = MergeTransformer(name, forks)
            %MERGETRANSFORMER
            obj.name = name;
            obj.forks = forks;
        end
    end
    
    %% Interface Methods
    methods
        %% - update
        function update(obj, data)
            %UPDATE(obj, data)
            obj.isActive = true;
            transformedData = data;
            if obj.isEnabled
                transformedData = obj.transform(transformedData);
                obj.dataBuffer = [obj.dataBuffer, transformedData];
            end
            obj.transfer(obj.dataBuffer);
            obj.isActive = false;
        end
        
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            newData = data;
            obj.transformCount = obj.transformCount + 1;
        end
        
        function transfer(obj, data)
            %TRANSFER(obj, data)
            if obj.transformCount == obj.forks
                for o = 1 : length(obj.observers)
                    observer = obj.observers(o);
                    observer.update(data);
                end
                obj.transformCount = 0;
                obj.dataBuffer = [];
            end
        end
    end
end

