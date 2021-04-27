classdef AEncoderSpectrumLearningStrategy_v2 < CMStrategy
    %AEncoderSpectrumLearningStrategy_v2 learning strategy for Autoencoder
    %   Memory, consisting of peakfinding and iterative training of
    %   Autoencoder
    
    properties
        numOfAveragingWindows = 10;
    end
    
    methods
        function obj = AEncoderSpectrumLearningStrategy_v2(name)
            obj@CMStrategy(name);
        end
    end
    
    %% Interface Methods
    methods 
        function out = execute(obj, cmSystem)
            % check if monitoring system is of correct type            
            if ~strcmp(class(cmSystem), class(AEncoderSpectrumMonitoringSystem_v2.empty))&&...
                ~strcmp(class(cmSystem), class(AEncoderAxialBearingSpectrumMonitoringSystem_v2.empty))
                error('wrong CMSystem was passed');
            end
            
            % disable unneeded DataTransformers
            cmSystem.clusteringModel.disable();
            cmSystem.aeEncoderExtractor.disable();
            cmSystem.timeAppender.disable();
            cmSystem.clusterPlotter.disable();
            % make segmenter data before extractor persistent
            cmSystem.segmenter.setDataPersistent(true);
                       
            cmSystem.aeDataAcquisitor.learningMode();
            
            % prepare a mean f-p-spectrum
            cmSystem.aeDataAcquisitor.update([]);
            
            [f, DATA] = SignalAnalysis.fftPowerSpectrum(cmSystem.segmenter.dataBuffer, cmSystem.sampleRate / cmSystem.downsampleFactor);
%            pMean = mean(DATA(:,1:obj.numOfAveragingWindows),2);  

%            [locs, peaks, numOfPeaks] = PeakFinder.peaksByKneePointSearch(f, pMean, cmSystem.f_res, false);
%            cmSystem.aeEncoderExtractor.peakFinder.sampleRate = cmSystem.sampleRate / cmSystem.downsampleFactor;
%            [~, ~, numOfPeaks] = cmSystem.aeEncoderExtractor.peakFinder.peaksByKneePointSearch(f(:,1), pMean, cmSystem.f_res, false, 2);
            
            peaks = cmSystem.aeEncoderExtractor.peakFinder.apply(double(cmSystem.segmenter.dataBuffer)');
            numOfPeaks = ceil(peaks.mean);
            
            % fourier idea for hidden neurons
            cmSystem.aeEncoderExtractor.autoencoder.setHiddenWidth(numOfPeaks);
            % train MyAutoencoder for meanPeak   
            
            cmSystem.aeEncoderExtractor.autoencoder.train(DATA);
            
            while ~cmSystem.aeEncoderExtractor.autoencoder.iterativeTrainingOptions.TrainingState.Completed
                cmSystem.aeDataAcquisitor.update([]);
                [f, DATA] = SignalAnalysis.fftPowerSpectrum(cmSystem.segmenter.dataBuffer, cmSystem.sampleRate / cmSystem.downsampleFactor);
                cmSystem.aeEncoderExtractor.autoencoder.retrainIterative(DATA);
            end

            cmSystem.aeEncoderExtractor.firstAutoencoderTrained = true;
            disp(['trained new autoencoder (' num2str(length(cmSystem.aeEncoderExtractor.lastAutoencoders) + 1) ')']);
            
            % prepare data acquisitor for monitoring
            cmSystem.aeDataAcquisitor.monitoringMode();
            
            % enable DataTransformers back
            cmSystem.clusteringModel.enable();
            cmSystem.aeEncoderExtractor.enable();
            cmSystem.timeAppender.enable();
            cmSystem.clusterPlotter.enable();
            cmSystem.segmenter.setDataPersistent(false);
            out = true;
        end
    end    
end

