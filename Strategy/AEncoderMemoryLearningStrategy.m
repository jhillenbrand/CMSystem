classdef AEncoderMemoryLearningStrategy < CMStrategy
    %AENCODERMEMORYLEARNINGSTRATEGY learning strategy for Autoencoder
    %   Memory, consisting of peakfinding and iterative training of
    %   Autoencoder
    
    properties
        minPeakLearnIterations = 25;
        maxPeakLearnIterations = 100;
        meanPeakConvergeThreshold = 0.1;
        consecutiveNoChanges = 5;
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
            
            % incremental peakfinding
            meanPeaks = 0;
            for i = 1 : obj.minPeakLearnIterations
                data = obj.getPreprocessorData(cmSystem);               
                peaks = cmSystem.aeEncoderExtractor.getPeaks(data);
                if meanPeaks == 0
                    meanPeaks = peaks.mean;
                else
                    meanPeaks = (meanPeaks * (i - 1) + peaks.mean) / i;
                end
            end
            meanChange = obj.meanPeakConvergeThreshold;
            r = 0;
            while i < obj.maxPeakLearnIterations && r > obj.consecutiveNoChanges
                i = i + 1;
                lastMeanPeak = meanPeaks;
                data = obj.getPreprocessorData(cmSystem);
                peaks = peakFinder.apply(data);
                if meanPeaks == 0
                    meanPeaks = peaks.mean;
                else
                    meanPeaks = (meanPeaks * (i - 1) + peaks.mean) / i;
                end
                meanChange = abs(1 - lastMeanPeak / meanPeaks);
                if meanChange < obj.meanPeakConvergeThreshold 
                    r = r + 1;
                else
                    r = 0;
                end
            end
            disp(['found meanPeak = ' num2str(meanPeaks)])
            
            % fourier idea for hidden neurons
            cmSystem.aeEncoderExtractor.autoencoder.setHiddenWidth(ceil(3 * meanPeaks + 1));
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
            cmSystem.preprocessor.setDataPersistent(false);
            out = true;
        end
    end
    
    %% Private Methods
    methods (Access = private)
        function data = getPreprocessorData(obj, cmSystem)
            cmSystem.aeDataAcquisitor.update([]);
            data = cmSystem.preprocessor.dataBuffer;
            if isempty(data)
                error('could not retrieve data from Preprocessor, make sure it is set to dataPersistent')
            end     
        end
    end
end

