% AUTHOR jonas.hillenbrand@kit.edu
% VERSION V0.1
% DATE 02.01.2021
% DEPENDENCY DataTransformer.m
classdef Preprocessor < DataTransformer
    %PREPROCESSOR 
    
    properties
        
    end
    
    methods
        function obj = Preprocessor(name, transformation)
            obj@DataTransformer(name, transformation);
        end
    end
end

