classdef AEPreprocessor < Preprocessor
    %AEPREPROCESSOR 
    
    properties
        sampleRate = 2e6;
        lowPassFrequency = 200e3;
        downsampleFactor = 4;
        bitPrecision = 12;
        removeStillstand = false;
        stillstandLowerLimit = -10;
        stillstandUpperLimit = 10;
        trimStart = 0;
        trimEnd = 0;
    end
    
    methods
        function obj = AEPreprocessor(name, sampleRate, lowPassFrequency, downsampleFactor, bitPrecision)
            %AEPREPROCESSOR 
            obj@Preprocessor(name, []);
            if nargin > 1
                obj.sampleRate = sampleRate;
            end
            if nargin > 2
                obj.lowPassFrequency = lowPassFrequency;
            end
            if nargin > 3
                obj.downsampleFactor = downsampleFactor;
            end
            if nargin > 4
                obj.bitPrecision = bitPrecision;
            end
            funcHandle = @(x) AEPreprocessor.aePreprocFunc(x, obj.sampleRate, obj.lowPassFrequency, obj.downsampleFactor, obj.bitPrecision, obj.removeStillstand, obj.stillstandLowerLimit, obj.stillstandUpperLimit, obj.trimStart, obj.trimEnd);
            trafo = Transformation('AE_PREPROCESS', funcHandle);
            obj.addTransformation(trafo);
        end
        
        function reinit(obj)
            obj.transformations = [];
            funcHandle = @(x) AEPreprocessor.aePreprocFunc(x, obj.sampleRate, obj.lowPassFrequency, obj.downsampleFactor, obj.bitPrecision, obj.removeStillstand, obj.stillstandLowerLimit, obj.stillstandUpperLimit, obj.trimStart, obj.trimEnd);
            trafo = Transformation('AE_PREPROCESS', funcHandle);
            obj.addTransformation(trafo);
        end
        
    end
    
    methods (Static)
        function newData = aePreprocFunc(data, sampleRate, lowPassFrequency, downsampleFactor, bitPrecision, removeStillstand, stillstandLowerLimit, stillstandUpperLimit, trimStart, trimEnd)
            %AEPREPROC(data, sampleRate, lowPassFrequency, downsampleFactor, bitPrecision)
            % Preprocessing Setup
            newData = data;
            if trimStart > 0
                newData = newData(trimStart : end, :);
            end
            if trimEnd > 0
                newData = newData(1 : end - trimEnd, :);
            end
            if bitPrecision > 0
                newData = SignalAnalysis.correctBitHickup(newData, bitPrecision, true, false);
            end
            if lowPassFrequency > 0
                newData = SignalAnalysis.lowpass2(newData, sampleRate, lowPassFrequency, 0.95);
            end
            if downsampleFactor > 1
                newData = downsample(newData, downsampleFactor);
            end
            if removeStillstand
                % remove stillstand sections if present defined by noise
                % lower and upper limit
                newData = SignalAnalysis.removeWindowsInRange(newData, stillstandLowerLimit, stillstandUpperLimit, ceil(sampleRate * 0.1), false, 5);
            end
            if isempty(newData)
                newData = [NaN; NaN];
            end
        end
    end
end

