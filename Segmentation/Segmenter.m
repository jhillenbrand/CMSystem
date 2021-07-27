classdef Segmenter < DataTransformer & SegmentationInterface
    %SEGMENTER 
    
    properties
        
    end
    
    %%
    methods
        function obj = Segmenter(name)
            if nargin < 1
                name = [class(Segmenter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@DataTransformer(name);
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            newData = obj.segment(data);
        end
        
        %% - segment
        function newData = segment(obj, data)
            %SEGMENT(obj, data) is the same as the transform method in
            %   DataTransformer
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
    end
end

