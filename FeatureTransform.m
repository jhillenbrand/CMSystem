classdef FeatureTransform < Transform
    %FEATURETRANSFORM 
    
    properties
        
    end
    
    methods
        function obj = FeatureTransform(funcHandle)
            obj@Transform(funcHandle);
        end
    end
end

