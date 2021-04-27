classdef AEncoderExtractor < AutoEncoderExtractor
    %AENCODEREXTRACTOR 
    
    properties
        
    end
    
    methods
        function obj = AEncoderExtractor(f_sr, f_res)
            %AENCODEREXTRACTOR
            obj@AutoEncoderExtractor(f_sr, f_res);
            %obj.peakFinder = PeakFinder.defaultHighfrequencyFinder(f_sr,f_res);
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
            peaks = obj.peakFinder.applyPeakFinder(data);
        end
    end
    
    methods
        function setDefaultAutoencoder(obj)
            obj.autoencoder = MyDeepAutoencoder(10,3);            
        end
        
        function setDefaultLearnOptions(obj)
            obj.autoencoder.setTrainingOptions('MaxEpochs',1000);
            obj.autoencoder.setIterativeTrainingOptions(...
                'ConvergencePatience',3,...
                'ScoreFactor',0.9);
            obj.autoencoder.setValidationOptions('EarlyStopping', true,...
                'ValidationPatience',10,'Shuffle','once');
            obj.autoencoder.setNormalizationOptions('NormalizationMethod', 'MapZscoreDataset');
            obj.autoencoder.setIterativeTrainingOptions('UseIterativeTraining',true);            
        end
        
        function defaultLearn(obj, data)            
            peaks = obj.peakFinder.applyPeakFinder(data);            
            % fourier idea for hidden neurons
            obj.autoencoder.setHiddenWidth(ceil(3 * peaks.mean + 1));
            obj.autoencoder.retrainIterative(data);
        end
    end
end

