classdef Transform < TransformInterface
    %TRANSFORM 
    
    properties
        name = '';
        outputDim = [];
        funcHandle = [];
    end
    
    methods
        function obj = Transform(funcHandle, name)
            %TRANSFORM(name, funcHandle)
            if nargin < 2
                name = ['Transform [' char(UUID.randomUUID().toString()) ']'];
            end
            if nargin < 1
                funcHandle = [];
            end
            obj.name = name;
            obj.funcHandle = funcHandle;
            % attempt to get outputsize for n x 1 vector
            r = rand(100, 1);
            obj.outputDim = size(obj.funcHandle(r));
        end
        
        function newData = apply(obj, data)
            newData = obj.funcHandle(data);
        end
    end    
end

