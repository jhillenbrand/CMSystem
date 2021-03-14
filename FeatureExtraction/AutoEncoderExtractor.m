% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.2
% DATE 29.01.2021
% DEPENDENCY Deep Learning Toolbox (trainautoencoder), Signal Processing Toolbox (findpeaks), MyAutoencoder.m, PeakFinder.m
classdef AutoEncoderExtractor < FeatureExtractor & LearnableInterface
    %AUTOENCODEREXTRACTOR 
    
    properties
        autoencoder = [];
        peakFinder = [];
        sampleRate = 2e6;   % sample rate of data to be processed [Hz]
        f_res = 100; % targeted frequency resolution [Hz]
    end
    
    methods
        function obj = AutoEncoderExtractor(sampleRate, f_res)
            if nargin < 1
                sampleRate = 2e6;
            end
            if nargin < 2
                f_res = 100;
            end
            obj.f_res = f_res;
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
            obj.autoencoder = autoencoder;
        end
                                
        %% - predictMSE
        function newData = predictMSE(obj, data)
            %PREDICTMSE predicts the reconstruction for data
            
            % data is a f x w matrix, where f is the number of features
            %   (here each raw sample is considered a feature) and w is the
            %   number of windows
            %   or
            %   data is a f x 1 vector
            data_Pred = obj.autoencoder.predict(data);
            newData = mean(SignalAnalysis.getMSE(data, data_Pred, 2));
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
            newData = obj.predictMSE(data);
        end
    end
    
    methods (Access = private)
        %% - defaultLearn
        function defaultLearn(obj, data)            
            obj.setDefaultPeakFinder();
            obj.setDefaultAutoencoder();
            obj.setDefaultLearnOptions();
            obj.autoencoder.train(data);
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
            obj.autoencoder = MyShallowAutoencoder(6);
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

