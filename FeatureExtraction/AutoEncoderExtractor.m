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
            funcHandle = @(data) x;
            transformation = Transformation(funcHandle, ['Autoencoder MSE Transformation [' char(java.util.UUID.randomUUID().toString()) ']']);
        end
        
        function setAutoencoder(obj, autoencoder)
            obj.autoencoder = autoencoder;
        end
        
        %% - learn
        function learn(obj, data)
            %LEARN implements the LearnableInterface Method
            obj.defaultLearn(data);
           end
        
        %% - defaultLearn
        function defaultLearn(obj, data)
            n_Hidden = myAutoencoder.estimateHiddenNeuronsWithFrequencyDomain(data, obj.sampleRate, [], [], 'autoThresholdMethod', 'bins', 'ShowPlot', 'progress', 'transform', 'autoAveragedLinear', 'verbose', true, 'NewFigure', true);
            epochs =1000;
            lambda = 0.001;
            beta = 0;
            decTransFcn = 'purelin';
            normalizeInput = 'mapminmaxAll';
            obj.autoencoder = MyAutoencoder.train(X_Train',[], n_Hidden, 'MaxEpochs', epochs, 'L2WeightRegularization', lambda, 'SparsityRegularization', beta, 'DecoderTransferFunction', decTransFcn, 'normalizeInput', normalizeInput);                        
        end
        
        %% - predict
        function predict(obj, data)
            
        end
    end
end

