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
        isActive = false;
        isEnabled = true;
        dataPersistent = false;
        dataBuffer = [];
    end
    
    methods
        function obj = DataTransformer(name, transformation)
            if nargin > 1
                if ~isemtpy(transformation)
                    obj.addTransformation(transformation);
                end
                obj.name = name;
            end
        end
    end
    
    %% interface methods
    methods
        %% - update
        function update(obj, data)
            %UPDATE(obj, data)
            obj.isActive = true;
            transformedData = data;
            if obj.isEnabled
                transformedData = obj.transform(transformedData);
                if obj.dataPersistent
                    obj.dataBuffer = transformedData;
                end
            end
            obj.transfer(transformedData);
            obj.isActive = false;
        end
        
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            newData = [];
            for t = 1 : length(obj.transformations)
                %plot(data)
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
    end
    
    %% GETTER AND SETTER
    methods
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
        
        %% - setDataPersistent
        function setDataPersistent(obj, value)
            obj.dataPersistent = value;
            if ~value
                obj.dataBuffer = [];
            end
        end
        
        %% - enable
        function enable(obj)
            obj.isEnabled = true;
        end
        
        function disable(obj)
            obj.isEnabled = false;
        end
    end 
    %% UTILITY Methods (Static)
    methods (Static, Access = protected)
        function bool = is1D(data)
            if sum(size(data) == 1) == 1 || isscalar(data)
                bool = true;
            else
                bool = false;
            end
        end
        
        function bool = is2D(data)
            if length(size(data)) == 2
                bool = true;
            else
                bool = false;
            end
        end
        
        function bool = is3D(data)
            if length(size(data)) == 3
                bool = true;
            else
                bool = false;
            end
        end
    end  
end

