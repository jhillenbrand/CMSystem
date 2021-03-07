classdef AEncoderMemoryLearningStrategy < CMStrategy
    %AENCODERMEMORYLEARNINGSTRATEGY learning strategy for Autoencoder
    %   Memory, consisting of peakfinding and iterative training of
    %   Autoencoder
    
    properties
        numOfAveragingWindows = 20;
    end
    
    methods
        function obj = AEncoderMemoryLearningStrategy(name)
            obj@CMStrategy(name);
        end
    end
    
    %% Interface Methods
    methods 
        function out = execute(obj, cmSystem)
            % check if monitoring system is of correct type            
            if ~strcmp(class(cmSystem), class(AEncoderMonitoringSystem.empty))
                error('wrong CMSystem was passed');
            end
            
            % disable unneeded DataTransformers
            cmSystem.clusteringModel.disable();
            cmSystem.aeEncoderExtractor.disable();
            cmSystem.rmsExtractor.disable();
            cmSystem.merger.disable();
            
            % make preprocessor data before extractor persistent
            cmSystem.preprocessor.setDataPersistent(true);
            
            % prepare a mean f-p-spectrum
            pMean = [];
            for i = 1 : obj.numOfAveragingWindows
                cmSystem.aeDataAcquisitor.update([]);
                data = [data, cmSystem.preprocessor.dataBuffer];
                [f, p] = SignalAnalysis.fftPowerSpectrum(data, cmSystem.sampleRate / cmSystem.downsampleFactor);
                if isempty(pMean)
                    pMean = p;
                else
                    pMean = (pMean * (i - 1) + p) / i;
                end
            end
            [locs, peaks, numOfPeaks] = PeakFinder.peaksByKneePointSearch(f, pMean, cmSystem.f_res, false);
            
            % fourier idea for hidden neurons
            cmSystem.aeEncoderExtractor.autoencoder.setHiddenWidth(ceil(3 * numOfPeaks) + 1);
            % train MyAutoencoder for meanPeak            
            cmSystem.aeEncoderExtractor.autoencoder.train(data);
            while ~cmSystem.aeEncoderExtractor.isIterativeTrainingComplete()
                data = obj.getPreprocessorData(cmSystem);
                cmSystem.aeEncoderExtractor.learn(data);
            end
            cmSystem.aeEncoderExtractor.firstAutoencoderTrained = true;
            disp(['trained new autoencoder (' num2str(length(cmSystem.aeEncoderExtractor.lastAutoencoders) + 1) ')']);
            
            % enable DataTransformers back
            cmSystem.clusteringModel.enable();
            cmSystem.aeEncoderExtractor.enable();
            cmSystem.rmsExtractor.enable();
            cmSystem.merger.enable();
            cmSystem.lowPassProcessor.setDataPersistent(false);
            out = true;
        end
    end    
end

