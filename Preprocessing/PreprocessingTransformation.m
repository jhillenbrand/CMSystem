% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY Transformation.m
classdef PreprocessingTransformation < Transformation
    %PREPROCESSINGTRANSFORMATION
    
    properties
        
    end
    
    methods
        function obj = PreprocessingTransformation(name, funcHandle)
            obj@Transformation(name, funcHandle);
        end
    end
end

