classdef AEncoderSpectrumMSETrackingLearningStrategy_v2 < CMStrategy
    %AEncoderSpectrumMSETrackingStrategy learning strategy for Autoencoder
    %   Memory, consisting of peakfinding and iterative training of
    %   Autoencoder
    
    properties
        numOfAveragingWindows = 20;
    end
    
    methods
        function obj = AEncoderSpectrumMSETrackingLearningStrategy_v2(name)
            obj@CMStrategy(name);
        end
    end
    
    %% Interface Methods
    methods 
        function out = execute(obj, cmSystem)
            % check if monitoring system is of correct type            
            if ~strcmp(class(cmSystem), class(AEncoderSpectrumMSETrackingSystem_v2.empty))
                error('wrong CMSystem was passed');
            end
            
            % disable unneeded DataTransformers
            cmSystem.trackingModel.disable();
            cmSystem.clusteringModel.disable();            
            cmSystem.aeEncoderExtractor.disable();
            cmSystem.timeAppender.disable();
            cmSystem.clusterPlotter.disable();
            cmSystem.transitionPlotter.disable();
            cmSystem.anomalyStatePlotter.disable();
            % make preprocessor data before extractor persistent
            cmSystem.preprocessor.setDataPersistent(true);
            
            % prepare a mean f-p-spectrum
            pMean = [];
            DATA = [];
            for i = 1 : obj.numOfAveragingWindows
                cmSystem.aeDataAcquisitor.update([]);
                [f, p] = SignalAnalysis.fftPowerSpectrum(cmSystem.preprocessor.dataBuffer, cmSystem.sampleRate / cmSystem.downsampleFactor);
                DATA = [DATA, p];
                if isempty(pMean)
                    pMean = p;
                else
                    pMean = (pMean * (i - 1) + p) / i;
                end
            end
%            [locs, peaks, numOfPeaks] = PeakFinder.peaksByKneePointSearch(f, pMean, cmSystem.f_res, false);
            cmSystem.aeEncoderExtractor.peakFinder.sampleRate = cmSystem.sampleRate / cmSystem.downsampleFactor;
            [locs, peaks, numOfPeaks] = cmSystem.aeEncoderExtractor.peakFinder.peaksByKneePointSearch(f, pMean, cmSystem.f_res, false, 2);
            
            % fourier idea for hidden neurons
            cmSystem.aeEncoderExtractor.autoencoder.setHiddenWidth(numOfPeaks);
            % train MyAutoencoder for meanPeak            
            cmSystem.aeEncoderExtractor.autoencoder.train(DATA);
            cmSystem.aeEncoderExtractor.firstAutoencoderTrained = true;
            disp(['trained new autoencoder (' num2str(length(cmSystem.aeEncoderExtractor.lastAutoencoders) + 1) ')']);
            
            % enable DataTransformers back
            cmSystem.trackingModel.enable();
            cmSystem.clusteringModel.enable();
            cmSystem.aeEncoderExtractor.enable();
            cmSystem.timeAppender.enable();
            cmSystem.clusterPlotter.enable();
            cmSystem.transitionPlotter.enable();
            cmSystem.anomalyStatePlotter.enable();
            %cmSystem.lowPassProcessor.setDataPersistent(false);
            out = true;
        end
    end    
end

