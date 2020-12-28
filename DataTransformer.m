% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION v1.0 
% @DEPENDENCY DataTransformationInterface.m
classdef DataTransformer < DataTransformationInterface
    %DATATRANSFORMOBJECT 
    
    properties
        L = JLog();
        name = 'DataTransformer1';
        observers = [];
        transforms = [];
        active = false;
    end
    
    methods
        %% - update
        function update(obj, data)
            %UPDATE(obj, data)
            obj.active = true;
            newData = obj.transform(data);
            obj.transfer(newData);
            obj.active = false;
        end
        
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            newData = [];
            for t = 1 : length(obj.transforms)
                transform = obj.transforms(t);
                newData = [newData, transform.apply(data)];
            end
        end
        
        %% - transfer
        function transfer(obj, data)
            %TRANSFER(obj, data)
            for o = 1 : length(obj.observers)
                observer = obj.observers(o);
                observer.update(data);
            end
        end
        
        %% - getNumberOfObservers
        function count = getNumberOfObservers(obj)
            %GETNUMBEROFOBSERVERS(obj)
            count = length(obj.observers);
        end
        
        %% - addTransform
        function addTransform(obj, transform)
            %ADDTRANSFORM(obj, transform)
            obj.transformers = [obj.transformers; transform];
        end
    end
end

