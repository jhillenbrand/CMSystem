% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 09.06.2021
% DEPENDENCY FeatureExtractor.m, LearnableInterface.m, Deep Learning Toolbox (trainautoencoder), Signal Processing Toolbox (findpeaks), MyAutoencoder.m, PeakFinder.m
classdef SpeedBasedAENExtractor < FeatureExtractor & LearnableInterface
    %SpeedBasedAENExtractor 
    
    properties
        spindleSpeeds = [];
        speedTol = 2;   % [1/min] new spindle speed must fall within +/- speedTol, to be considered same speed
        segmentationFreqs = [2; 4; 5];
        segmentationSamples = [];   % variable to store the segmentation windows, also used for autoencoder feature input layer size
        learningData = {};
        aens = {};
        peakFinder = [];
        sampleRate = 2e6;   % sample rate of data to be processed [Hz]
        f_res = 100;
        minLearningWindows = 10;   % minimum number of data windows required for learning of new autoencoder
        mseMean = true;
    end
    
    methods
        function obj = SpeedBasedAENExtractor(sampleRate, f_res, minLearningWindows)
            obj@FeatureExtractor('Speed_AEN_Ex1', []);
            if nargin < 1
                sampleRate = 2e6;
            end
            if nargin < 2
                f_res = 100;
            end
            if nargin < 3
                minLearningWindows = 10;
            end
            obj.sampleRate = sampleRate;
            obj.f_res = f_res;
            obj.minLearningWindows = minLearningWindows;
            funcHandle = @(x)obj.predictMSE(x);
            transformation = Transformation(['Autoencoder MSE ' class(Transformation.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'], funcHandle);
            obj.addTransformation(transformation);   
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
            if isempty(aeData)
                newData = [];
            else                
                [f, p] = SignalAnalysis.fftPowerSpectrum(aeData, obj.sampleRate);
                data_Pred = aen.predict(p);
                if obj.mseMean
                    mse = mean(SignalAnalysis.getMSE(p, data_Pred, 1));
                else                    
                    mse = SignalAnalysis.getMSE(p, data_Pred, 1);
                end
                newData = mse(:);
            end
        end
    end
    
    %% Interface Methods
    methods
        %% - transform
        function newData = transform(obj, data)
            if iscell(data)
                if size(data{1}, 1) > 1
                    allFreqs = data{1};
                    allAEData = data{2};
                else
                    allFreqs = data{1};
                    allAEData = {data{2}};
                end
                dim = size(allFreqs, 1);
                %newData = cell(dim, size(obj.aens, 2)); 
                %newData = cell(dim, size(obj.segmentationFreqs, 1));
                for d = 1 : dim
                    freqs = allFreqs(d, :);
                    freqs = freqs(:);
                    spindleSpeed = freqs(1) * 60; % [1/min]
                    aeData = allAEData{d};

                    % check if autoencoder for speed exists already!
                    if isempty(obj.aens)
                        obj.learn({freqs, aeData})
                        newData = {};
                        return;
                    end
                    % check if spindle speeds already exists
                    speedInd = obj.checkIfSpindleSpeedExists(spindleSpeed);
                    if ~isempty(speedInd)                
                        if speedInd > size(obj.aens, 1)
                            warning('mismatch speedInd and number of trained AEN')
                            disp(['INFO: start training autoencoders for spindle speed = ' num2str(spindleSpeed)])
                            obj.learn([allFreqs, allAEData])
                            newData = {};
                            return;
                        else
                            trainedAENs = obj.aens(speedInd, :);
                            if isempty(trainedAENs)
                                disp(['INFO: start training autoencoders for spindle speed = ' num2str(spindleSpeed)])
                                obj.learn([freqs, aeData])
                                newData = {};
                                return;
                            else
                                % iterate through all trainedAENs for this spindleSpeed
                                sf = freqs(obj.segmentationFreqs);
                                newData = cell(length(obj.spindleSpeeds), length(obj.segmentationSamples));
                                for a = 1 : length(trainedAENs)
                                    % separate raw data into windows for each frequency scenario
                                    segT = obj.segmentationSamples(speedInd, a);
                                    dw = SignalAnalysis.separateDataIntoWindows(aeData, segT, true);
                                    % predict mse
                                    if ~isempty(dw)
                                        if isempty(newData{speedInd, a})
                                            newData{speedInd, a} = obj.predictMSE(trainedAENs{a}, dw);
                                        else
                                            newData{speedInd, a} = [newData{speedInd, a}, obj.predictMSE(trainedAENs{a}, dw)];
                                        end
                                    else
                                        warning(['not enough data for segment = ' num2str(segT)])
                                        newData{d, a} = [];
                                    end
                                end
                            end
                        end
                    else
                        error(['Could not find spindle speed = ' num2str(spindleSpeed)])
                    end
                end
            else
                newData = {};
                warning(['data [' class(data) '] was not of type cell'])
            end
        end        
        
        %% - learn
        function learn(obj, data)
            %LEARN implements the LearnableInterface Method
            
            freqs = data{1}; % frequencies
            spindleSpeed = freqs(1) * 60; % [1/min]
            aeData = data{2}; % AE Data           
           
            % check if spindle speeds already exists
            speedInd = obj.checkIfSpindleSpeedExists(spindleSpeed);
            
            % store learning data
            disp(['INFO: add training data to autoencoders for spindle speed = ' num2str(spindleSpeed)])               
            if isempty(obj.learningData)
               obj.learningData{speedInd, 1} = aeData;
            else
                if size(obj.learningData, 1) < speedInd
                    obj.learningData{speedInd, 1} = aeData;
                else
                    obj.learningData{speedInd, 1} = [obj.learningData{speedInd, 1}; aeData];
                end
            end 
            
            % check if dataBuffer contains enough data for learning for specific segmentation window                
            sf = freqs(obj.segmentationFreqs);    % segmentation frequencies
            enoughForTraining = false;
            for s = 1 : length(sf)
                segN = 1 / sf(s);
                learnN = obj.sampleRate * segN * obj.minLearningWindows;
                if length(obj.learningData{speedInd, 1}) >= learnN
                    enoughForTraining = true;
                else
                    enoughForTraining = false;
                    break;
                end                
            end
            
            if enoughForTraining
                for s = 1 : length(sf)
                    segN = floor(1 / sf(s) * obj.sampleRate);
                    ld = obj.learningData{speedInd, 1};
                    % determine hidden layer 
                    dw = SignalAnalysis.separateDataIntoWindows(ld, segN, true);
                    [f, p, t] = SignalAnalysis.fftPowerSpectrum(dw, obj.sampleRate);
                    pMean = mean(p, 2);
                    [locs, peaks, numOfPeaks] = PeakFinder.peaksByKneePointSearch(f, pMean, obj.f_res, false, 2);
                    % init autoencoder
                    aen = obj.createDefaultAEN();
                    aen.setHiddenWidth(numOfPeaks);
                    % train autoencoder with spectrum
                    disp(['INFO: train autoencoder for speed = ' num2str(spindleSpeed) ', segment = ' num2str(segN)])
                    aen.train(p);
                    % remove validation data to save memory
                    aen.removeValidationData();
                    obj.aens{speedInd, s} = aen;
                    obj.segmentationSamples(speedInd, s) = segN;
                end
                % delete learningData for corresponding speed
                obj.learningData{speedInd, 1} = [];
            end
        end
        
        
    end
    
    %% Private Helper Methods
    methods (Access = private)
        function speedInd = checkIfSpindleSpeedExists(obj, spindleSpeed)
            % check if spindle speeds already exists
            speedInd = find(obj.spindleSpeeds >= spindleSpeed - obj.speedTol & obj.spindleSpeeds <= spindleSpeed + obj.speedTol);
            if isempty(speedInd)
                obj.spindleSpeeds = [obj.spindleSpeeds; floor(spindleSpeed)];
                speedInd = length(obj.spindleSpeeds);
            else
                if length(speedInd) > 1
                    speedInd = speedInd(1);
                end 
            end
        end
        
        function aen = createDefaultAEN(obj)
            aen = MyDeepAutoencoder(7, 1);
            defaultTrainingOptions = {'MaxEpochs', 100, ...
                                      'MiniBatchSize', 32, ...
                                      'ExecutionEnvironment', 'cpu'};
            defaultValidationOptions = {'EarlyStopping', true,...
                    'UseValidation',true,...
                    'ValidationFrequency', 10, ...
                    'ValidationPatience', 10, ...
                    'Shuffle','once'};
            defaultNormalizationOptions = {'NormalizationMethod', 'MapZscore'};
            aen.setTrainingOptions(defaultTrainingOptions{:});
            aen.setValidationOptions(defaultValidationOptions{:});
            aen.setNormalizationOptions(defaultNormalizationOptions{:});
        end
    end
end

