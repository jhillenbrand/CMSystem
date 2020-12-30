classdef DefaultPreprocessor < Preprocessor
    %DEFAULTPREPROCESSOR 
    properties
        applyMovingAverage = true;
        averagingWindowSize = 10;
    end
    
    methods
        function obj = DefaultPreprocessor()
            %DEFAULTPREPROCESSOR
            obj.name = ['DefaultPreprocessor [' char(java.util.UUID.randomUUID().toString()) ']'];
            obj.initFilterTransformations();
        end
        
        function initFilterTransformations(obj)
            %INITFILTERTRANSFORMATIONS
            
            % delete all previous transformations
            obj.transformations = [];
            if obj.applyMovingAverage
                transformation = PreprocessingTransformation(@(x)SignalAnalysis.movingAverage(x, obj.averagingWindowSize), ['MovingAverageFilter [ws=' num2str(obj.averagingWindowSize) ']']);
                obj.addTransformation(transformation);
            end            
        end
    end
end

