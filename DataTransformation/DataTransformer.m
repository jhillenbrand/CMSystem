% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 1.0 
% @DEPENDENCY DataTransformerInterface.m
% @DATE 30.12.2020
classdef DataTransformer < DataTransformerInterface
    %DATATRANSFORMER
    
    properties
        name = '';
        observers = DataTransformer.empty();
        transformations = Transformation.empty();
        isActive = false;
        isEnabled = true;
        dataPersistent = false;
        dataBuffer = [];
    end
    
    methods
        function obj = DataTransformer(name, transformation)
            if nargin < 1
                name = [class(DataTransformer.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            if nargin > 1
                if ~isempty(transformation)
                    obj.addTransformation(transformation);
                end
            end
            obj.name = name;
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
            if iscell(data)
                newData = cell(1, length(data));
                if length(obj.transformations) == 1                    
                    for c = 1 : length(data)
                        trafo = obj.transformations(1);
                        newData{c} = trafo.apply(data{c});
                    end
                else
                    error('not implemented for cell input and more than one transformation')
                end
            elseif isvector(data)
                for t = 1 : length(obj.transformations)
                    %plot(data)
                    trafo = obj.transformations(t);
                    newData = [newData, trafo.apply(data)];
                end
            elseif ismatrix(data)
                for t = 1 : length(obj.transformations)
                    %plot(data)
                    trafo = obj.transformations(t);
                    newData = [newData, trafo.apply(data)];
                end    
            end
        end
        
        %% - transfer
        function transfer(obj, data)
            %TRANSFER(obj, data)
            if ~isempty(data)
                for o = 1 : length(obj.observers)
                    observer = obj.observers(o);
                    observer.update(data);
                end
            else
                warning(['no data for transfer from ' obj.name])
            end
        end
    end
    
    %% Visualization
    methods
        function showObservers(obj)
            
        end
        
        function TM = getObserverMatrix(obj)
            
        end
        
        function observerNames = getObserverNamesRecursively(obj, startNames)
            numOfObservers = length(obj.observers);
            observerNames = startNames;
            observerNames{end + 1, 1} = obj.name;
            for o = 1 : numOfObservers
                observerNames = obj.observers(o).getObserverNamesRecursively(observerNames);
            end
            observerNames = unique(observerNames);
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

