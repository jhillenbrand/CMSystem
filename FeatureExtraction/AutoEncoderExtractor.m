% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.2
% DATE 29.01.2021
% DEPENDENCY Deep Learning Toolbox (trainautoencoder), Signal Processing Toolbox (findpeaks), MyAutoencoder.m, PeakFinder.m
classdef AutoencoderExtractor < FeatureExtractor & LearnableInterface
    %AUTOENCODEREXTRACTOR 
    
    properties
        autoencoder = [];
        peakFinder = [];
        sampleRate = 2e6;   % sample rate of data to be processed [Hz]
        fRes = 100; % targeted frequency resolution [Hz]
    end
    
    methods
        function obj = AutoencoderExtractor(sampleRate, fRes)
            if nargin < 1
                sampleRate = 2e6;
            end
            if nargin < 2
                fRes = 100;
            end
            obj.fRes = fRes;
            obj.sampleRate = sampleRate;
            funcHandle = @(x)obj.predictMSE(x);
            transformation = Transformation(funcHandle, ['Autoencoder MSE ' class(Transformation.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']']);
            obj.addTransformation(transformation);
            
            % init autoencoder and peakfinder
            obj.setDefaultPeakFinder();
            obj.setDefaultAutoencoder();
        end
           
        function setPeakFinder(obj, peakFinder)
            obj.peakFinder = peakFinder;
        end
        
        function setAutoencoder(obj, autoencoder)
            obj.autoencoder = autoencoder;
        end
                
        %% - defaultLearn
        function defaultLearn(obj, data)            
            %[numOfHiddenNeurons, maxNumOfHiddenNeurons, minNumOfHiddenNeurons] = obj.autoencoder.estimateHiddenNeuronsWithFrequencyDomain(obj.peakFinder, data);
            %obj.autoencoder.setHiddenWidth(numOfHiddenNeurons);            
            obj.autoencoder.estimateHiddenNeuronsWithFrequencyDomain(obj.peakFinder, data);
            obj.autoencoder.train(data);
        end
            
        function setDefaultPeakFinder(obj)
            obj.peakFinder = PeakFinder(obj.sampleRate, obj.fRes, obj.fRes);
            obj.peakFinder.setFourierTransformOptions('fft');
            obj.peakFinder.setThresholdOptions('std-all');
        end
        
        function setDefaultAutoencoder(obj)
            obj.autoencoder = MyDeepAutoencoder(6, 1);
            obj.setDefaultLearnOptions();
        end
        
        function setDefaultLearnOptions(obj)
            obj.autoencoder.setTrainingOptions(...
                'Verbose', false, ...
                'VerboseFrequency', 60, ...
                'InitialLearnRate', 0.01, ...
                'LearnRateSchedule', 'piecewise', ...
                'LearnRateDropPeriod', 40, ...
                'LearnRateDropFactor', 0.2, ...
                'GradientDecayFactor', 0.8, ...
                'SquaredGradientDecayFactor', 0.8, ...
                'Epsilon', 2e-8, ...
                'MaxEpochs', 4000, ...
                'Shuffle', 'every-epoch', ...
                'L2Regularization', 0.01, ...
                'ValidationPatience', 10, ...
                'Plots', 'training-progress');
        end 
                         
        %% - predictMSE
        function newData = predictMSE(obj, data)
            data_Pred = predict(obj.autoencoder, data');
            newData = mean(SignalAnalysis.getMSE(data, data_Pred', 2));
        end
    end
    
    %% Interface Methods
    methods       
        %% - learn
        function learn(obj, data)
            %LEARN implements the LearnableInterface Method
            obj.defaultLearn(data);
        end
    end
end

