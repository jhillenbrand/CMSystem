classdef AEPreprocessor < Preprocessor
    %AEPREPROCESSOR 
    
    properties
        sampleRate = 2e6;
        lowPassFrequency = 250e3;
        downsampleFactor = 4;
        bitPrecision = 12;
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
            funcHandle = @(x) AEPreprocessor.aePreprocFunc(x, obj.sampleRate, obj.lowPassFrequency, obj.downsampleFactor, obj.bitPrecision);
            trafo = Transformation('AE_PREPROCESS', funcHandle);
            obj.addTransformation(trafo);
        end
    end
    
    methods (Static)
        function newData = aePreprocFunc(data, sampleRate, lowPassFrequency, downsampleFactor, bitPrecision)
            %AEPREPROC(data, sampleRate, lowPassFrequency, downsampleFactor, bitPrecision)
            % Preprocessing Setup
            newData = SignalAnalysis.correctBitHickup(data, bitPrecision, true, false);
            if lowPassFrequency > 0
                newData = SignalAnalysis.lowpass2(newData, sampleRate, lowPassFrequency);
            end
            if downsampleFactor > 1
                newData = downsample(newData, downsampleFactor);
            end
        end
    end
end

