classdef AEncoderAxialBearingMonitoringSystem < CMSystem 
    %AEMONITORINGSYSTEM 
    
    %% DataTransformers
    properties
        aeDataAcquisitor = DataAcquisitor.empty;
        preprocessor = Preprocessor.empty;
        aeEncoderExtractor = AEncoderExtractor.empty;
        rmsExtractor = FeatureExtractor.empty;
        merger = MergeTransformer.empty;
        clusteringModel = SimpleClusterBoundaryModeler.empty;
        rawAEPlotter = MovingWindowPlotter.empty;
        clusterPlotter = SimpleClusterPlotter.empty;
        segmenter = Segmenter.empty;
        %clusterTransitionPlotter = ClusterTransitionPlotter.empty;
    end
        
    %% config settings
    properties
        AE_MAT_FOLDER = 'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\5-Achser-KGT-Measurements\20201026_mess_ae_only\20201202_baseline3\AE\';
                        %'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\5-Achser-KGT-Measurements\20201026_mess_ae_only\20201214_particle_OL\AE\';
        AE_FILE_NAME_ID = [];
        AE_FILE_TYPE = 'mat';
        sampleRate = 2e6;
        windowSize = 100e3;
        f_res = 100;
        bitPrecision = 12;
        lowPassFrequency = 250e3;
        downsampleFactor = 4;
    end
    
    methods
        function obj = AEncoderAxialBearingMonitoringSystem()
            %AEncoderAxialBearingMonitoringSystem
            obj.name = 'AEncoderAxialBearingMonitoringSystem';
            obj.addStrategy(AEncoderMemoryLearningStrategy('LearningStrategy'));
            obj.addStrategy(AEncoderMemoryMonitoringStrategy('MonitoringStrategy'));            
        end
        
        function initTransformers(obj)
            % Step 1 - Data Acquisition Setup
            aeFiles = DataParser.getFilePaths(obj.AE_MAT_FOLDER, obj.AE_FILE_TYPE, obj.AE_FILE_NAME_ID, true);
            dp = DataParser('FileType', obj.AE_FILE_TYPE);
            skipWindows = 10; 
            obj.aeDataAcquisitor = AEAcquisitor(dp, aeFiles, obj.windowSize, skipWindows * obj.windowSize);
            obj.aeDataAcquisitor.plotFileFieldInds = [4, 5];
            
            % Step 2 - Preprocessing Setup
            obj.preprocessor = AEPreprocessor('AE_PREPROCESSOR', obj.sampleRate, obj.lowPassFrequency, obj.downsampleFactor, obj.bitPrecision);
                       
            obj.aeDataAcquisitor.addObserver(obj.preprocessor);
                        
            % Step 3 - Segmenting Setup
            obj.segmenter = FixedWindowSegmenter(obj.windowSize);
            obj.preprocessor.addObserver(obj.segmenter);
            
            % Step 4 - Feature Extraction
            obj.aeEncoderExtractor = AEncoderMemoryExtractor(obj.sampleRate, obj.f_res);
            obj.aeEncoderExtractor.defaultTrainingOptions = {'MaxEpochs', 100};
            obj.aeEncoderExtractor.defaultValidationOptions = {'EarlyStopping', true,...
                    'UseValidation',true,...
                    'ValidationFrequency', 10, ...
                    'ValidationPatience', 10, ...
                    'Shuffle','once'};
            
            obj.segmenter.addObserver(obj.aeEncoderExtractor);
            
            extractor = DefaultFeatureExtractor(obj.sampleRate);
            extractor.name = 'RMS_Extractor';
            extractor.transformToPeakFactor = false;
            extractor.transformToMeanFrequency = false;
            extractor.initFeatureTransformations();
            obj.rmsExtractor = extractor;
            
            obj.preprocessor.addObserver(obj.rmsExtractor);
            
            obj.merger = MergeTransformer('Merger', 2);
            
            obj.aeEncoderExtractor.addObserver(obj.merger);
            obj.rmsExtractor.addObserver(obj.merger);
            
            
            % Step 5 - Modeling
            %obj.clusteringModel = ClusterBoundaryTrackingModeler();
            obj.clusteringModel = SimpleClusterBoundaryModeler();
            
            obj.merger.addObserver(obj.clusteringModel);
            
            % Step 6 - Reporting
            obj.rawAEPlotter = MovingWindowPlotter(false, 5 * obj.sampleRate);
            obj.clusterPlotter = SimpleClusterPlotter();
            %obj.clusterTransitionPlotter = ClusterTransitionPlotter();
            
            obj.preprocessor.addObserver(obj.rawAEPlotter);
            obj.clusteringModel.addObserver(obj.clusterPlotter);
            %obj.clusteringModel.addObserver(obj.clusterTransitionPlotter);
        end        
    end
    
    %% Interface Methods
    methods
        function start(obj)
            if isempty(obj.activeStrategy)
                obj.switchStrategy('LearningStrategy');
                obj.activeStrategy.execute(obj); 
                obj.saveToFile();
            end
            while true
                if strcmp(obj.activeStrategy.name, 'LearningStrategy')
                    obj.switchStrategy('MonitoringStrategy');
                    obj.activeStrategy.execute(obj);
                    obj.saveToFile();
                else
                    obj.switchStrategy('LearningStrategy');
                    obj.activeStrategy.execute(obj); 
                    obj.saveToFile();
                end
            end
        end
    end
end

