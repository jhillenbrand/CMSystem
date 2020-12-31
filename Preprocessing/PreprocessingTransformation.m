classdef PreprocessingTransformation < Transformation
    %PREPROCESSINGTRANSFORMATION
    
    properties
        
    end
    
    methods
        function obj = PreprocessingTransformation(funcHandle, name)
            obj@Transformation(funcHandle, name);
        end
    end
end

