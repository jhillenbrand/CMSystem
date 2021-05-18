% AUTHOR jonas.hillenbrand@kit.edu
% VERSION V0.1
% DATE 17.05.2021
% DEPENDENCY Preprocessor.m
classdef NonContinuousDownsampler < Preprocessor
    %NonContinuousDownsampler 
    
    properties
        epsilon = 0.01;
    end
    
    methods
        function obj = NonContinuousDownsampler(epsilon)
            obj@Preprocessor('NonContinuousDownsampler', [])
            obj.epsilon = epsilon;            
        end
    end
    
    methods
        function newData = transform(obj, data)
            
            [xd, yd] = Mapping.doGradientBasedNonUniformDownsampling(data(:, 1), data(:, 2), obj.epsilon, false);
            newData = [xd, yd];
            
        end
    end
end

