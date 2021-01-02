% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY TransformationInterface.m
classdef Transformation < TransformationInterface
    %TRANSFORMATION 
    
    properties
        name = '';
        outputDim = [];
        funcHandle = [];
    end
    
    methods
        function obj = Transformation(funcHandle, name)
            %TRANSFORMATION(name, funcHandle)
            if nargin < 2
                name = ['Transformation [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            if nargin < 1
                funcHandle = [];
            end
            obj.name = name;
            obj.funcHandle = funcHandle;
            if ~isempty(funcHandle)
                % attempt to get outputsize for n x 1 vector            
                r = rand(100, 1);
                try 
                    obj.outputDim = size(funcHandle(r));
                catch e
                    warning(e.message)
                    warning(['could not execute Transformation with function handle [' func2str(funcHandle) ']'])
                end
            end
        end
        
        function newData = apply(obj, data)
            newData = obj.funcHandle(data);
        end
    end    
end

