% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 1.0 
% @DEPENDENCY DataTransformerInterface.m
% @DATE 30.12.2020
classdef DataTransformer < DataTransformerInterface
    %DATATRANSFORMER
    
    properties
        L = JLog();
        name = [class(DataTransformer.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
        observers = DataTransformer.empty();
        transformations = Transformation.empty();
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
            for t = 1 : length(obj.transformations)
                trafo = obj.transformations(t);
                newData = [newData, trafo.apply(data)];
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
        
        %% - addTransformation
        function addTransformation(obj, trafo)
            %ADDTRANSFORMATION(obj, transform) adds the passed
            %   transformation to existing transformations
            if (contains(superclasses(trafo), class(Transformation.empty)) | isa(trafo, class(Transformation.empty)))
                obj.transformations = [obj.transformations; trafo];
            else
                error(['trafo was not of type ' class(Transformation.empty)])
            end
        end
        
        %% - addObserver
        function addObserver(obj, observer)
            %ADDOBSERVER(obj, observer) adds the passed observer to existing observer
            %   collection
            obj.observers = [obj.observers; observer];
        end
    end
end

