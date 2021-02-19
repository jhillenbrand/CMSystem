classdef AEncoderMonitoringSystem < CMSystem 
    %AEMONITORINGSYSTEM 
    
    %% DataTransformers
    properties
        aeDataAcquisitor = DataAcquisitor.empty;
        preprocessor = Preprocessor.empty;
        aeEncoderExtractor = AEncoderExtractor.empty;
        rmsExtractor = FeatureExtractor.empty;
        merger = MergeTransformer.empty;
        clusteringModel = ClusterBoundaryTrackingModeler.empty;
        rawAEPlotter = MovingWindowPlotter.empty;
        clusterPlotter = SimpleClusterPlotter.empty;
        %clusterTransitionPlotter = ClusterTransitionPlotter.empty;
    end
        
    %% config settings
    properties
        AE_MAT_FOLDER = 'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\5-Achser-KGT-Measurements\20210118_mess_ae_kgt_cam\Verschleissfahrt3\';
        sampleRate = 2e6;
        f_res = 100;
        bitPrecision = 12;
    end
    
    methods
        function obj = AEncoderMonitoringSystem()
            %AENCODERMONITORINGSYSTEM
            obj.name = 'AEncoderMonitoringSystem';
            obj.addStrategy(AEncoderMemoryLearningStrategy('LearningStrategy'));
            obj.addStrategy(AEncoderMemoryMonitoringStrategy('MonitoringStrategy'));
            
            obj.initTransformers();
        end
        
        function initTransformers(obj)
            % Step 1 - Data Acquisition Setup
            aeFiles = DataParser.getFilePaths(obj.AE_MAT_FOLDER, 'mat', 'ORFL', true);
            dp = DataParser('FileType', 'mat');
            n = obj.sampleRate / 4;
            obj.aeDataAcquisitor = SimStreamAcquisitor(dp, aeFiles, n, n);
            
            % Step 2 - Preprocessing Setup
            obj.preprocessor = Preprocessor();
            funcHandle = @(x) SignalAnalysis.correctBitHickup(x, obj.bitPrecision, true, false);
            preprocTrafo = PreprocessingTransformation('BitHickUpTrafo', funcHandle);
            obj.preprocessor.addTransformation(preprocTrafo);

            obj.aeDataAcquisitor.addObserver(obj.preprocessor);
            
            % Step 3 - Segmenting Setup
            
            % Step 4 - Feature Extraction
            obj.aeEncoderExtractor = AEncoderMemoryExtractor(obj.sampleRate, obj.f_res);
            
            obj.preprocessor.addObserver(obj.aeEncoderExtractor);
            
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

