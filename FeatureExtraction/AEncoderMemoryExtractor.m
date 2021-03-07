classdef AEncoderMemoryExtractor < AutoencoderExtractor
    %AENCODEREXTRACTOR 
    
    properties
        lastAutoencoders = [];
        firstAutoencoderTrained = false;
        
        minPeakFindIterations = 10;
        maxPeakFindIterations = 100;
        thisPeakFindIterations = 0;
        peakFindConvergeThreshold = 0.1;
        lastMeanPeak = -1;
    end
    
    methods
        function obj = AEncoderMemoryExtractor(f_sr, f_res)
            %AENCODEREXTRACTOR
            obj@AutoencoderExtractor(f_sr, f_res);
            obj.peakFinder = PeakFinder.defaultHighfrequencyFinder(f_sr, f_res);
            obj.setDefaultAutoencoder();
            obj.setDefaultLearnOptions();
        end
    end
    
    %% Interface Methods
    methods
        %% - learn
        function learn(obj, data)
            obj.defaultLearn(data);
        end
    end
    
    %% - getPeaks
    methods
        function peaks = getPeaks(obj, data)
            peaks = obj.peakFinder.apply(data);
        end
        
        function bool = isIterativeTrainingComplete(obj)
            bool = obj.autoencoder.iterativeTrainingOptions.TrainingState.Completed;
        end
    end
    
    methods (Access = private)
        function setDefaultAutoencoder(obj)
            %obj.autoencoder = MyDeepAutoencoder(7,1);
            obj.autoencoder = MyShallowAutoencoder(7);
            obj.setDefaultLearnOptions();
        end
        
        function setDefaultLearnOptions(obj)
            if isa(obj.autoencoder, class(MyShallowAutoencoder.empty))
                obj.autoencoder.setTrainingOptions('MaxEpochs',1000);
                obj.autoencoder.setValidationOptions('EarlyStopping', true);
                obj.autoencoder.setNormalizationOptions('NormalizationMethod', 'MapZscoreDataset');
            else                
                obj.autoencoder.setTrainingOptions('MaxEpochs',1000);
                obj.autoencoder.setIterativeTrainingOptions(...
                    'ConvergencePatience',3,...
                    'ScoreFactor',0.9);
                obj.autoencoder.setValidationOptions('EarlyStopping', true,...
                    'ValidationPatience',10,'Shuffle','once');
                obj.autoencoder.setNormalizationOptions('NormalizationMethod', 'MapZscoreDataset');
                obj.autoencoder.setIterativeTrainingOptions('UseIterativeTraining',true);  
            end
        end
        
        function defaultLearn(obj, data)
            if obj.firstAutoencoderTrained
                obj.lastAutoencoders = [obj.lastAutoencoders; obj.autoencoder];
                obj.setDefaultAutoencoder();
                obj.setDefaultLearnOptions();
                obj.firstAutoencoderTrained = false;
            end
            obj.autoencoder.retrainIterative(data);
        end
    end
end

