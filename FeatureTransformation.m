classdef FeatureTransformation < Transformation
    %FEATURETRANSFORMATION 
    
    properties
        
    end
    
    methods
        function obj = FeatureTransformation(funcHandle, name)
            obj@Transformation(funcHandle, name);
        end
    end
end

