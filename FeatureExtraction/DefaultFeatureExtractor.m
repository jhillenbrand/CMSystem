classdef DefaultFeatureExtractor < FeatureExtractor
    %DEFAULTFEATUREEXTRACTOR 
    
    %% properties
    properties
        sampleRate = 0;
        
        % activate features
        transformToRMS = true;
        transformToMin = false;
        transformToMax = false;
        transformToMean = false;
        transformToPeakFactor = true;
        transformToStd = false;
        transformToPeak2Peak = false;
        transformToImpulseFactor = false;
        transformToCrestFactor = false;
        transformToKurtosisFactor = false;
        transformToFormFactor = false;
        transformToMarginFactor = false;
        transformToEnergy = false;
        transformToBinnedEntropy = false;
        transformToSkewness = false;
        transformToMeanFrequency = true;
        transformToCenterFrequency = false;
        transformToCountZeroCrossings = false;
    end
    
    %% Class Methods
    methods
        %% - DefaultFeatureExtractor
        function obj = DefaultFeatureExtractor(sampleRate)
            %DEFAULTFEATUREEXTRACTOR(sampleRate)
            obj.name = ['DefaultFeatureExtractor [' char(java.util.UUID.randomUUID().toString()) ']'];
            if nargin < 1
                sampleRate = 0;
            end
            obj.sampleRate = sampleRate;
            obj.initFeatureTransformations();
        end
        
        %% - initFeatureTransformations
        function initFeatureTransformations(obj)
            %INITFEATURETRANSFORMS(obj)
            
            % delete all previous transformations
            obj.transformations = [];
            if obj.transformToRMS
                transformation = FeatureTransformation(@rms, 'RMS');
                obj.addTransformation(transformation);
            end
            if obj.transformToMin
                transformation = FeatureTransformation(@min, 'MIN');
                obj.addTransformation(transformation);
            end
            if obj.transformToMax
                transformation = FeatureTransformation(@max, 'MAX');
                obj.addTransformation(transformation);
            end
            if obj.transformToMean
                transformation = FeatureTransformation(@mean, 'MEAN');
                obj.addTransformation(transformation);
            end
            if obj.transformToPeakFactor
                transformation = FeatureTransformation(@SignalAnalysis.peakFactor, 'PEAKFACTOR');
                obj.addTransformation(transformation);
            end
            if obj.transformToStd
                transformation = FeatureTransformation(@std, 'STD');
                obj.addTransformation(transformation);
            end                        
            if obj.transformToPeak2Peak
                transformation = FeatureTransformation(@SignalAnalysis.peak2Peak, 'PEAK2PEAK');
                obj.addTransformation(transformation);
            end 
            if obj.transformToImpulseFactor
                transformation = FeatureTransformation(@SignalAnalysis.impulseFactor, 'IMPULSEFACTOR');
                obj.addTransformation(transformation);
            end
            if obj.transformToCrestFactor
                transformation = FeatureTransformation(@SignalAnalysis.crestFactor, 'CRESTFACTOR');
                obj.addTransformation(transformation);
            end
            if obj.transformToKurtosisFactor
                transformation = FeatureTransformation(@SignalAnalysis.kurtosis, 'KURTOSISFACTOR');
                obj.addTransformation(transformation);
            end
            if obj.transformToFormFactor
                transformation = FeatureTransformation(@SignalAnalysis.formFactor, 'FORMFACTOR');
                obj.addTransformation(transformation);
            end
            if obj.transformToMarginFactor
                transformation = FeatureTransformation(@SignalAnalysis.marginFactor, 'MARGINFACTOR');
                obj.addTransformation(transformation);
            end
            if obj.transformToEnergy
                transformation = FeatureTransformation(@SignalAnalysis.getEnergy, 'ENERGY');
                obj.addTransformation(transformation);
            end
            if obj.transformToBinnedEntropy
                transformation = FeatureTransformation(@SignalAnalysis.getEntropy, 'BINNEDENTROPY');
                obj.addTransformation(transformation);                
            end
            if obj.transformToSkewness
                transformation = FeatureTransformation(@skewness, 'SKEWNESS');
                obj.addTransformation(transformation);                
            end
            if obj.transformToMeanFrequency
                transformation = FeatureTransformation(@(x)meanfreq(x, obj.sampleRate), 'MEANFREQUENCY');
                obj.addTransformation(transformation);                
            end
            if obj.transformToCenterFrequency
                transformation = FeatureTransformation(@(x)SignalAnalysis.centroidFrequency(x, obj.sampleRate), 'CENTERFREQUENCY');
                obj.addTransformation(transformation);                
            end
            if obj.transformToCountZeroCrossings
                transformation = FeatureTransformation(@SignalAnalysis.countZeroCrossings, 'COUNTZEROCROSSINGS');
                obj.addTransformation(transformation);  
            end
        end
    end
end

