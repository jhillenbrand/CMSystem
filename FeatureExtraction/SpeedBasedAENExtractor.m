% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 09.06.2021
% DEPENDENCY FeatureExtractor.m, LearnableInterface.m, Deep Learning Toolbox (trainautoencoder), Signal Processing Toolbox (findpeaks), MyAutoencoder.m, PeakFinder.m
classdef SpeedBasedAENExtractor < FeatureExtractor & LearnableInterface
    %SpeedBasedAENExtractor 
    
    properties
        spindleSpeeds = [];
        segmentationFreqs = [2; 4; 5];
        learningData = [];
        aens = [];
        activeAEN = []; % matrix [n x m], where n are the number of speeds detected so far and m the number of scenarios / time windows for segmentation
        peakFinder = [];
        sampleRate = 2e6;   % sample rate of data to be processed [Hz]
        f_res = 100;
        minLearningWindows = 10;   % minimum number of data windows required for learning of new autoencoder
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
        function newData = predictMSE(obj, aen, aeData)
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
            
            data_Pred = aen.predict(aeData);
            newData = mean(SignalAnalysis.getMSE(aeData, data_Pred, 2));
        end
    end
    
    %% Interface Methods
    methods       
        %% - learn
        function learn(obj, data)
            %LEARN implements the LearnableInterface Method
            
            freqs = data(1); % frequencies
            spindleSpeed = freqs(1);
            aeData = data(2);            
           
            obj.spindleSpeeds = [obj.spindleSpeeds; spindleSpeed]; 
            speedInd = (obj.spindleSpeeds == spindleSpeed);
            
            % store learning data
            obj.learningData{speedInd, 1} = [obj.learningData{speedInd, 1}; aeData];
            
            % check if dataBuffer contains enough data for learning for specific segmentation window                
            sf = freqs(obj.segmentationFreqs);    % segmentation frequencies
            enoughForTraining = false;
            for s = 1 : length(sf)
                segT = 1 / sf(s);
                learnN = obj.sampleRate * segT * obj.minLearningWindows;
                if length(obj.learningData{speedInd, 1}) <= learnN
                    enoughForTraining = true;
                else
                    enoughForTraining = false;
                    break;
                end                
            end
            
            if enoughForTraining
                for s = 1 : length(sf)
                    segT = floor(1 / sf(s) * obj.sampleRate);
                    ld = obj.learningData{speedInd, 1};
                    % determine hidden layer 
                    dw = SignalAnalysis.separateDataIntoWindows(ld, segT, true);
                    [f, p, t] = SignalAnalysis.fftPowerSpectrum(dw, obj.sampleRate);
                    pMean = mean(p, 2);
                    [locs, peaks, numOfPeaks] = PeakFinder.peaksByKneePointSearch(f, pMean, obj.f_res, false, 2);
                    % init autoencoder
                    aen = obj.createDefaultAEN();
                    aen.setHiddenWidth(numOfPeaks);
                    % train autoencoder
                    aen.train(dw);
                    obj.aens(speedInd, s) = aen;
                end
            end
        end
        
        %% - transform
        function newData = transform(obj, data)
            if iscell(data)
                
                freqs = data{1};
                spindleSpeed = freqs(1);
                aeData = data{2};
                
                % check if autoencoder for speed exists already!
                isTrained = (obj.spindleSpeeds == spindleSpeed);
                if length(isTrained) > size(obj.aens, 1)
                    trainedAENs = obj.aens(isTrained, :);
                    if isempty(trainedAENs)
                        disp(['INFO: start training autoencoders for spindle speed = ' num2str(spindleSpeed)])
                        obj.learn([freqs, aeData])
                    else
                        if length(sf) ~= length(trainedAENs)
                            error('frequencies for segmenting does not match number of autoencoders')
                        end
                        % iterate through all trainedAENs for this spindleSpeed
                        sf = freqs(obj.segmentationFreqs);
                        for a = 1 : length(trainedAENs)
                            % separate raw data into windows for each frequency scenario
                            segT = floor(sf(a) * obj.sampleRate);
                            dw = SignalAnalysis.separateDataIntoWindows(aeData, segT, true);
                            % predict mse                            
                            newData = [newData, obj.predictMSE(trainedAENs(a), dw)];
                        end
                    end
                else
                    disp(['INFO: not enough data for training new autoencoder at spindle speed = ' num2str(spindleSpeed)])
                end
            else
                newData = [];
                warning(['data [' class(data) '] was not of type cell'])
            end
        end
    end
    
    %% Private Helper Methods
    methods (Access = private)
        function aen = createDefaultAEN(obj)
            aen = MyDeepAutoencoder(7, 1);
            defaultTrainingOptions = {'MaxEpochs', 100};
            defaultValidationOptions = {'EarlyStopping', true,...
                    'UseValidation',true,...
                    'ValidationFrequency', 10, ...
                    'ValidationPatience', 10, ...
                    'Shuffle','once'};
            defaultNormalizationOptions = {'NormalizationMethod', 'MapZscore'};
            aen.setTrainingOptions(defaultTrainingOptions);
            aen.setValidationOptions(defaultValidationOptions);
            aen.setNormalizationOptions(defaultNormalizationOptions);
        end
    end
end

