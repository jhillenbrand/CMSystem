classdef ClusterBoundaryStateModeler < Modeler
    %ClusterBoundaryStateModeler
    
    properties
        clusterTracker = ClusterBoundaryTracking2.empty;                    
    end
       
    methods
        function obj = ClusterBoundaryStateModeler(featureNames)
            %ClusterBoundaryStateModeler(featureNames)
            if nargin < 1
                featureNames =  {};
            end
            obj@Modeler([class(ClusterBoundaryStateModeler.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']']);
            obj.clusterTracker = ClusterBoundaryTracking2();
            obj.clusterTracker.featureNames = featureNames;
            obj.clusterTracker.minDataPoints = 25;
            obj.clusterTracker.keepDataPoints = false;
            obj.clusterTracker.displayClustering = false;
            obj.clusterTracker.displayTransitions = false;
            obj.clusterTracker.clusterEachIteration = false;
            obj.clusterTracker.verbose = false;
        end
    end
    
    %% Interface Methods
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            newData = [];
            if ~isempty(data)
                if isnumeric(data)
                    obj.clusterTracker.processNewData(data);
                    newData = obj.clusterTracker;
                else
                    error([class(ClusterBoundaryStateModeler.empty) ' --> data passed to transform step must be numeric']);
                end
            else
                warning([class(ClusterBoundaryStateModeler.empty) ' --> no data was passed to transform step']);
            end
        end
    end
end

