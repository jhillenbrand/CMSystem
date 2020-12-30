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
                obj.outputDim = size(funcHandle(r));
            end
        end
        
        function newData = apply(obj, data)
            newData = obj.funcHandle(data);
        end
    end    
end

