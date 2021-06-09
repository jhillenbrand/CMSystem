classdef DefaultFeatureExtractor < FeatureExtractor
    %DEFAULTFEATUREEXTRACTOR 
    
    %% properties
    properties
        sampleRate = 0;
        windowSize = 0;
        
        % activate features
        transformToRMS = false;
        transformToMin = false;
        transformToMax = false;
        transformToMaxAbs = false;
        transformToMean = false;
        transformToPeakFactor = false;
        transformToStd = false;
        transformToPeak2Peak = false;
        transformToImpulseFactor = false;
        transformToCrestFactor = false;
        transformToKurtosisFactor = false;
        transformToFormFactor = false;
        transformToMarginFactor = false;
        transformToEnergy = false;
        transformToEnvelopeEnergy = false;
        transformToBinnedEntropy = false;
        transformToSkewness = false;
        transformToMeanFrequency = false;
        transformToCenterFrequency = false;
        transformToCountZeroCrossings = false;
    end
    
    %% Class Methods
    methods
        %% - DefaultFeatureExtractor
        function obj = DefaultFeatureExtractor(sampleRate, windowSize)
            %DEFAULTFEATUREEXTRACTOR(sampleRate)
            obj@FeatureExtractor([class(DefaultFeatureExtractor.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'], []);
            %obj.name = [class(DefaultFeatureExtractor.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            if nargin < 2
                windowSize = 0;
            end
            if nargin < 1
                sampleRate = 0;
            end
            obj.sampleRate = sampleRate;
            obj.windowSize = windowSize;
            obj.initFeatureTransformations();
        end
        
        %% - initFeatureTransformations
        function initFeatureTransformations(obj)
            %INITFEATURETRANSFORMS(obj)
            
            % delete all previous transformations
            obj.transformations = [];
            if obj.transformToRMS
                transformation = FeatureTransformation('RMS', @rms);
                obj.addTransformation(transformation);
            end
            if obj.transformToMin
                transformation = FeatureTransformation('MIN', @min);
                obj.addTransformation(transformation);
            end
            if obj.transformToMax
                transformation = FeatureTransformation('MAX', @max);
                obj.addTransformation(transformation);
            end
            if obj.transformToMaxAbs
                transformation = FeatureTransformation('MAX-ABS', @(x)max(abs(x)));
                obj.addTransformation(transformation);
            end
            if obj.transformToMean
                transformation = FeatureTransformation('MEAN', @mean);
                obj.addTransformation(transformation);
            end
            if obj.transformToPeakFactor
                transformation = FeatureTransformation('PEAKFACTOR', @SignalAnalysis.peakFactor);
                obj.addTransformation(transformation);
            end
            if obj.transformToStd
                transformation = FeatureTransformation('STD', @std);
                obj.addTransformation(transformation);
            end                        
            if obj.transformToPeak2Peak
                transformation = FeatureTransformation('PEAK2PEAK', @SignalAnalysis.peakToPeak);
                obj.addTransformation(transformation);
            end 
            if obj.transformToImpulseFactor
                transformation = FeatureTransformation('IMPULSEFACTOR', @SignalAnalysis.impulseFactor);
                obj.addTransformation(transformation);
            end
            if obj.transformToCrestFactor
                transformation = FeatureTransformation('CRESTFACTOR', @SignalAnalysis.crestFactor);
                obj.addTransformation(transformation);
            end
            if obj.transformToKurtosisFactor
                transformation = FeatureTransformation('KURTOSISFACTOR', @SignalAnalysis.kurtosis);
                obj.addTransformation(transformation);
            end
            if obj.transformToFormFactor
                transformation = FeatureTransformation('FORMFACTOR', @SignalAnalysis.formFactor);
                obj.addTransformation(transformation);
            end
            if obj.transformToMarginFactor
                transformation = FeatureTransformation('MARGINFACTOR', @SignalAnalysis.marginFactor);
                obj.addTransformation(transformation);
            end
            if obj.transformToEnergy
                transformation = FeatureTransformation('ENERGY', @SignalAnalysis.getEnergy);
                obj.addTransformation(transformation);
            end
            if obj.transformToEnvelopeEnergy
                transformation = FeatureTransformation('ENV-ENERGY', @(x)SignalAnalysis.getEnvelopeEnergy(x, obj.windowSize, true));
                obj.addTransformation(transformation);
            end
            if obj.transformToBinnedEntropy
                transformation = FeatureTransformation('BINNEDENTROPY', @SignalAnalysis.getEntropy);
                obj.addTransformation(transformation);                
            end
            if obj.transformToSkewness
                transformation = FeatureTransformation('SKEWNESS', @skewness);
                obj.addTransformation(transformation);                
            end
            if obj.transformToMeanFrequency
                transformation = FeatureTransformation('MEANFREQUENCY', @(x)meanfreq(x, obj.sampleRate));
                obj.addTransformation(transformation);                
            end
            if obj.transformToCenterFrequency
                transformation = FeatureTransformation('CENTERFREQUENCY', @(x)SignalAnalysis.centroidFrequency(x, obj.sampleRate));
                obj.addTransformation(transformation);                
            end
            if obj.transformToCountZeroCrossings
                transformation = FeatureTransformation('COUNTZEROCROSSINGS', @SignalAnalysis.countZeroCrossings);
                obj.addTransformation(transformation);  
            end
        end
    end
end

