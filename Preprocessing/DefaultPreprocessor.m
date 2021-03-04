
classdef DefaultPreprocessor < Preprocessor
    %DEFAULTPREPROCESSOR 
    properties
        applyMovingAverage = true;
        averagingWindowSize = 10;
    end
    
    methods
        function obj = DefaultPreprocessor()
            obj@Preprocessor(['DefaultPreprocessor [' char(java.util.UUID.randomUUID().toString()) ']'], []);
            %DEFAULTPREPROCESSOR
            %obj.name = ['DefaultPreprocessor [' char(java.util.UUID.randomUUID().toString()) ']'];
            obj.initFilterTransformations();
        end
        
        function initFilterTransformations(obj)
            %INITFILTERTRANSFORMATIONS
            
            % delete all previous transformations
            obj.transformations = [];
            if obj.applyMovingAverage
                transformation = PreprocessingTransformation(['MovingAverageFilter [ws=' num2str(obj.averagingWindowSize) ']'], @(x)SignalAnalysis.movingAverage(x, obj.averagingWindowSize));
                obj.addTransformation(transformation);
            end            
        end
    end
end

