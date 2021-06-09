% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY TransformationInterface.m
classdef FeatureExtractor < DataTransformer
    %FEATUREEXTRACTOR 
    
    properties
        removeNaN = false;
    end
    
    methods 
        function obj = FeatureExtractor(name, transformation)
            obj@DataTransformer(name, transformation);
        end
    end
    
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            
            containedOnlyNaN = false;
            % check for NaN values
            if obj.containsNaN(data)
                if obj.removeNaN 
                    inds = isnan(data);
                    data(inds) = [];
                else
                    if obj.containsOnlyNaN(data)
                        % create a random matrix to test the transformations on output size for valid input
                        containedOnlyNaN = true;
                        data = rand(size(data));
                    end
                end
            end
            
            newData = [];
            if isvector(data)
                newData = newData(:);
                for t = 1 : length(obj.transformations)
                    trafo = obj.transformations(t);
                    trafoData = trafo.apply(data);
                    newData = [newData, trafoData];
                end
            elseif ismatrix(data)
                if length(obj.transformations) == 1
                    trafo = obj.transformations(1);
                    trafoData = trafo.apply(data);
                    newData = [newData, trafoData];
                else
                    for t = 1 : length(obj.transformations)
                        trafo = obj.transformations(t);
                        trafoData = trafo.apply(data);
                        newData = [newData, trafoData(:)];
                    end
                end                
            else
                error(['unsupported input type ' class(data)])
            end
            if containedOnlyNaN
                newData = NaN(size(newData));
            end
%             if ismatrix(data)                
%                 for t = 1 : length(obj.transformations)
%                     trafo = obj.transformations(t);
%                     trafoData = trafo.apply(data);
%                     if DataTransformer.is1D(trafoData)
%                         newData = [newData, trafoData(:)];
%                     else
%                         newData = [newData, trafoData];
%                     end
%                 end
%             elseif isvector(data)
%                 error('oops')
%             end
        end
    end   
    
    %% Helper methods
    methods (Access = protected)
        function bool = containsNaN(obj, data)
            bool = false;
            if sum(isnan(data)) > 1
                bool = true;
            end
        end
        
        function bool = containsOnlyNaN(obj, data)
            bool = false;
            if sum(isnan(data) == true) == length(data)
                bool = true;
            end            
        end
    end
end

