% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 19.04.2020
% DEPENDENCY Deep Learning Toolbox (trainautoencoder), Signal Processing Toolbox (findpeaks), MyAutoencoder.m, SignalAnalysis.m
classdef AutoencoderExtractor < FeatureExtractor & LearnableInterface
    %AUTOENCODEREXTRACTOR 
    
    properties
        autoencoder = [];
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
        end
        
        function setAutoencoder(obj, autoencoder)
            obj.autoencoder = autoencoder;
        end
                
        %% - defaultLearn
        function defaultLearn(obj, data)
            n_Hidden = MyAutoencoder.estimateHiddenNeuronsWithFrequencyDomain(data, obj.sampleRate, [], [], 'autoThresholdMethod', 'bins', 'ShowPlot', 'progress', 'transform', 'autoAveragedLinear', 'verbose', true, 'NewFigure', true);
            epochs = 1000;
            lambda = 0.001;
            beta = 0;
            decTransFcn = 'purelin';
            normalizeInput = 'mapminmaxAll';
            obj.autoencoder = MyAutoencoder.train(X_Train',[], n_Hidden, 'MaxEpochs', epochs, 'L2WeightRegularization', lambda, 'SparsityRegularization', beta, 'DecoderTransferFunction', decTransFcn, 'normalizeInput', normalizeInput);                        
        end
                         
        %% - predictMSE
        function newData = predictMSE(obj, data)
            data_Pred = predict(obj.autoencoder, data);
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
    end
end

