classdef ForkTransformer < DataTransformer
    %FORKTRANSFORMER forks the inputs from a datatransformer into
    %   sub content
    
    properties
        dataColumns = []; % indices of columns, where that data shall include after transform
    end
    
    methods
        function obj = ForkTransformer(name, dataColumns)
            %FORKTRANSFORMER
            obj.name = name;
            obj.dataColumns = dataColumns;
            funcName = [name '-handle'];
            funcHandle = @(x) ForkTransformer.fork(x, obj.dataColumns);
            trafo = Transformation(funcName, funcHandle);
            obj.addTransformation(trafo);
        end
    end
    
    %% Interface Methods
    methods
        
    end
    
    %% Static Methods
    methods (Static)
        function newData = fork(data, dataColumns)
            if iscell(data)
                disp('cell implementation missing')
            elseif ismatrix(data)
                newData = data(:, dataColumns);
            else
                if sum(dataColumns > size(data, 2)) > 0
                    error('not enough data columns')
                else
                    newData = data(:, dataColumns);
                end
            end
        end
    end
end

