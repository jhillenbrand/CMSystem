% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY TransformationInterface.m
classdef FeatureExtractor < DataTransformer
    %FEATUREEXTRACTOR 
    
    properties
        
    end
    
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
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
end

