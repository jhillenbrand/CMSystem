% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 09.06.2021
% DEPENDENCY FeatureExtractor.m, LearnableInterface.m, Deep Learning Toolbox (trainautoencoder), Signal Processing Toolbox (findpeaks), MyAutoencoder.m, PeakFinder.m
classdef SpeedBasedAENExtractor < FeatureExtractor & LearnableInterface
    %SpeedBasedAENExtractor 
    
    properties
        spindleSpeeds = [];
        aens = [];
        activeAEN = []; % matrix [n x m], where n are the number of speeds detected so far and m the number of scenarios / time windows for segmentation
        peakFinder = [];
        sampleRate = 2e6;   % sample rate of data to be processed [Hz]
    end
    
    methods
        function obj = AutoEncoderExtractor(sampleRate)
            if nargin < 1
                sampleRate = 2e6;
            end
            obj.sampleRate = sampleRate;
            funcHandle = @(x)obj.predictMSE(x);
            transformation = Transformation(['Autoencoder MSE ' class(Transformation.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'], funcHandle);
            obj.addTransformation(transformation);
            
            % init autoencoder and peakfinder
            obj.setDefaultPeakFinder();
            obj.setDefaultAutoencoder();
        end
           
        function setPeakFinder(obj, peakFinder)
            obj.peakFinder = peakFinder;
        end
        
        function setAutoencoder(obj, autoencoder)
            obj.activeAEN = autoencoder;
        end
                                
        %% - predictMSE
        function newData = predictMSE(obj, aeData)
            %PREDICTMSE predicts the reconstruction for data, based on activated autoencoder
            % obj: instance of class
            % aeData: a f x w matrix, where f is the number of features
            %   (here each raw sample is considered a feature) and w is the
            %   number of windows
            %   or
            %   aeData is a f x 1 vector
            
           
            % convert aeData to spectrum windows 
            [f, p] = SignalAnalysis.fftPowerSpectrum(aeData, obj.sampleRate);
            aeData = p;
            
            
            data_Pred = obj.autoencoder.predict(aeData);
            newData = mean(SignalAnalysis.getMSE(aeData, data_Pred, 2));
        end
    end
    
    %% Interface Methods
    methods       
        %% - learn
        function learn(obj, data)
            %LEARN implements the LearnableInterface Method
            
            
            
            
            obj.defaultLearn(data);
        end
        
        %% - transform
        function newData = transform(obj, data)
            if iscell(data)
                
                freqs = data{1};
                aeData = data{2};
                
                 % check if autoencoder for speed exists already!
                isTrained = obj.spindleSpeeds == freqs(1);
                trainedAENs = obj.aens(isTrained, :);
                if isempty(trainedAENs)
                    obj.learn([speed, aeData])
                end

                sf = [freqs(2), freqs(4),  freqs(5)];
                if length(sf) ~= length(trainedAENs)
                    error('frequencies for segmenting does not match number of autoencoders')
                end
                % iterate through all trainedAENs for this spindleSpeed
                for a = 1 : length(trainedAENs)
                    obj.activeAEN = trainedAENs(a);

                    % separate raw data into windows for each frequency scenario
                    
                    % predict mse

                end

                newData = obj.predictMSE(speed, aeData);
            else
                newData = [];
                warning(['data [' class(data) '] was not of type cell'])
            end
        end
    end
    
    methods
        %% - defaultLearn
        function defaultLearn(obj, data)            
            obj.setDefaultPeakFinder();
            obj.setDefaultAutoencoder();
            obj.setDefaultLearnOptions();
            obj.activeAEN.train(data);
        end
            
        function setDefaultPeakFinder(obj)
            obj.peakFinder = PeakFinder(obj.sampleRate, obj.f_res, obj.f_res);
%             obj.peakFinder.setFourierTransformOptions('fft');
%             obj.peakFinder.setThresholdOptions('none');
            obj.peakFinder.setFourierTransformOptions('none');
            obj.peakFinder.setThresholdOptions('sumOfMeanAndStd',true,'highPowerFrequencies',1, 'sample');

        end
        
        function setDefaultAutoencoder(obj)
            %obj.autoencoder = MyDeepAutoencoder(6, 1);
            obj.activeAEN = MyShallowAutoencoder(6);
            obj.setDefaultLearnOptions();
        end
        
        function setDefaultLearnOptions(obj)
%             obj.autoencoder.setTrainingOptions(...
%                 'Verbose', false, ...
%                 'VerboseFrequency', 60, ...
%                 'InitialLearnRate', 0.01, ...
%                 'LearnRateSchedule', 'piecewise', ...
%                 'LearnRateDropPeriod', 40, ...
%                 'LearnRateDropFactor', 0.2, ...
%                 'GradientDecayFactor', 0.8, ...
%                 'SquaredGradientDecayFactor', 0.8, ...
%                 'Epsilon', 2e-8, ...
%                 'MaxEpochs', 4000, ...
%                 'Shuffle', 'every-epoch', ...
%                 'L2Regularization', 0.01, ...
%                 'ValidationPatience', 10, ...
%                 'Plots', 'training-progress');
         end             
    end
end

