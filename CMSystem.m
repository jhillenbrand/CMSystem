% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DEPENDENCY
classdef CMSystem < handle
    %CMSystem
    
    %% Logger
    properties
        L = JLog();
    end
    
    %% Process Step Objects
    properties        
        dataAcquisitionObj = []; % Step 1 - Data Acquisition
        preprocessingObj = [];  % Step 2 - Preprocessing
        segmentationObj = [];   % Step 3 - Segmentation
        featureExtractionObj = [];  % Step 4 - FeatureExtraction        
        modellingObj = []; % Step 5 - Modelling
    end
    
    %% Strategy Object
    properties
        learningStrategyObj = [];
        monitoringStrategyObj = [];
    end
    
    %% State Properties
    properties
        mode = 0;   % [0-1]; 0 --> Learning, 1 --> Monitoring (Live)
        status = 0; % [0-5]; see Process Steps
        statusMsg = '';
        isRunning = false;
    end
    
    %% Constructor Method
    methods
        %% - ClusterAnomalyDetection
        function obj = CMSystem()
            %CLUSTERANOMALYDETECTION
            
            obj.status = 0;
            obj.statusMsg = 'STEP 0: Instantion';
        end
    end
    
    %% Setup Methods
    methods
        
    end
    
    %% PROCESS METHODS
    methods
        %% - run
        function run(obj)
            %RUN(obj)
            if obj.check()
                obj.isRunning = true;
                while (obj.isRunning)
                    obj.isRunning = obj.nextIteration();
                end
            else
                error('Method check() failed. Application will not start.')
            end
        end
        
        function bool = nextIteration(obj)
            switch (obj.mode)
                case 0
                    obj.nextLearningIteration();
                    
                case 1
                    obj.nextIterationMonitoring();
            end                
        end
        
        function bool = nextLearningIteration(obj)
            obj.status = 1;
            obj.statusMsg = 'STEP 1: Data Acquisition';
            acquiredData = obj.acquireData();
            
            obj.status = 2;
            obj.statusMsg = 'STEP 2: Preprocessing';            
            preprocessedData = obj.preprocessData(acquiredData);
            
            obj.status = 3;
            obj.statusMsg = 'STEP 3: Segmentation';            
            segmentedData = obj.segmentData(preprocessedData);
            
            obj.status = 4;
            obj.statusMsg = 'STEP 4: Feature Extraction';
            extractedFeatures = obj.extractFeatures(segmentedData);
            
            
        end
            
        function bool = nextIterationMonitoring(obj)
            %
            obj.status = 1;
            obj.statusMsg = 'STEP 1: Data Acquisition';
            acquiredData = obj.acquireData();
            
            obj.status = 2;
            obj.statusMsg = 'STEP 2: Preprocessing';            
            preprocessedData = obj.preprocessData(acquiredData);
            
            obj.status = 3;
            obj.statusMsg = 'STEP 3: Segmentation';            
            segmentedData = obj.segmentData(preprocessedData);
            
            obj.status = 4;
            obj.statusMsg = 'STEP 4: Feature Extraction';
            extractedFeatures = obj.extractFeatures(segmentedData);
            
            obj.status = 5;
            obj.statusMsg = 'STEP 5: Clustering';
            clusters = obj.clusterFeatures(extractedFeatures);
            
            obj.status = 6;
            obj.statusMsg = 'STEP 6: Cluster Tracking';
            trackedClusters = obj.trackClusters(clusters);
            
            bool = true;
        end
        
        %% - switchMode
        function switchMode(obj, mode)
            %SWITCHMODE(obj, mode) changes between Learning and Monitoring Mode
            obj.mode = mode;
        end
        
        %% - acquireData
        function acquiredData = acquireData(obj)
            %ACQUIREDATA(obj)
            
            acquiredData = obj.dataAcquisitionObj.requestAvailableData();
        end
        
        %% - preprocessData
        function preprocessedData = preprocessData(obj, acquiredData)
            %PREPROCESSDATA(obj, acquiredData)
            
            
        end
        
        %% - segmentData
        function segmentedData = segmentData(obj, preprocessedData)
            %SEGMENTDATA(obj, preprocessData)
        end
        
        %% - extractFeatures
        function extractedFeatures = extractFeatures(obj, segmentedData)
            %EXTRACTFEATURES(obj, segmentedData)
        end
        
        %% - clusterFeatures
        function clusters = clusterFeatures(obj, extractedFeatures)
            %CLUSTERFEATURES(obj, extractedFeatures)
        end
        
        %% - trackClusters
        function trackedClusters = trackClusters(obj, clusters)
            %TRACKCLUSTERS(obj, clusters)
        end
    end
    
    %% Private Methods
    methods (Access = private)
        %% - check
        function bool = check(obj)
            %CHECK(obj) checks if the required process objects are non
            %   empty
            if isempty(obj.dataAcquisitionObj)
                bool = false;
                return;
            end
            if isempty(obj.featureExtractionObj)
                bool = false;
                return;
            end
            if isempty(obj.clusteringObj)
                bool = false;
                return;
            end
            bool = true;
        end
    end
    
    %% UTILITY Methods
    methods (Static)
        %% - showArchitecture
        function showArchitecture()
            %SHOWARCHITECTURE
            img = imread(['res' filesep 'ClusterAnomalyDetection1.png']);
            imshow(img)
        end
    end
end

