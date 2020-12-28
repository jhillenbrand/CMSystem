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
        transformToMeanFrequency = false;
        transformToCenterFrequency = false;
    end
    
    %% Class Methods
    methods
        %% - DefaultFeatureExtractor
        function obj = DefaultFeatureExtractor(sampleRate)
            %DEFAULTFEATUREEXTRACTOR(sampleRate)
            obj.sampleRate = sampleRate;
            obj.initFeatureTransforms();
        end
        
        %% - initFeatureTransforms
        function initFeatureTransforms(obj)
            %INITFEATURETRANSFORMS(obj)
            if obj.transformToRMS
                transform = FeatureTransform(@rms, 'RMS');
                obj.addTransform(transform);
            end
            if obj.transformToMin
                transform = FeatureTransform(@min, 'MIN');
                obj.addTransform(transform);
            end
            if obj.transformToMax
                transform = FeatureTransform(@max, 'MAX');
                obj.addTransform(transform);
            end
            if obj.transformToMean
                transform = FeatureTransform(@mean, 'MEAN');
                obj.addTransform(transform);
            end
            if obj.transformToPeakFactor
                transform = FeatureTransform(@SignalAnalysis.peakFactor, 'PEAKFACTOR');
                obj.addTransform(transform);
            end
            if obj.transformToStd
                transform = FeatureTransform(@std, 'STD');
                obj.addTransform(transform);
            end                        
            if obj.transformToPeak2Peak
                transform = FeatureTransform(@SignalAnalysis.peak2Peak, 'PEAK2PEAK');
                obj.addTransform(transform);
            end 
            if obj.transformToImpulseFactor
                transform = FeatureTransform(@SignalAnalysis.impulseFactor, 'IMPULSEFACTOR');
                obj.addTransform(transform);
            end
            if obj.transformToCrestFactor
                transform = FeatureTransform(@SignalAnalysis.crestFactor, 'CRESTFACTOR');
                obj.addTransform(transform);
            end
            if obj.transformToKurtosisFactor
                transform = FeatureTransform(@SignalAnalysis.kurtosis, 'KURTOSISFACTOR');
                obj.addTransform(transform);
            end
            if obj.transformToFormFactor
                transform = FeatureTransform(@SignalAnalysis.formFactor, 'FORMFACTOR');
                obj.addTransform(transform);
            end
            if obj.transformToMarginFactor
                transform = FeatureTransform(@SignalAnalysis.marginFactor, 'MARGINFACTOR');
                obj.addTransform(transform);
            end
            if obj.transformToEnergy
                transform = FeatureTransform(@SignalAnalysis.getEnergy, 'ENERGY');
                obj.addTransform(transform);
            end
            if obj.transformToBinnedEntropy
                transform = FeatureTransform(@SignalAnalysis.getEntropy, 'BINNEDENTROPY');
                obj.addTransform(transform);                
            end
            if obj.transformToSkewness
                transform = FeatureTransform(@skewness, 'SKEWNESS');
                obj.addTransform(transform);                
            end
            if obj.transformToMeanFrequency
                transform = FeatureTransform(@(x)meanfreq(x, obj.sampleRate), 'MEANFREQUENCY');
                obj.addTransform(transform);                
            end
            if obj.transformToCenterFrequency
                transform = FeatureTransform(@(x)SignalAnalysis.centroidFrequency(x, obj.sampleRate), 'CENTERFREQUENCY');
                obj.addTransform(transform);                
            end
            if obj.transformToCountZeroCrossings
                transform = FeatureTransform(@SignalAnalysis.countZeroCrossings, 'COUNTZEROCROSSINGS');
                obj.addTransform(transform);  
            end
        end
    end
end

