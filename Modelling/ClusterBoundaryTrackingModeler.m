classdef ClusterBoundaryTrackingModeler < Modeler
    %CLUSTERBOUNDARYTRACKINGMODELER
        
    properties
        clusterBoundaryTrackingObj = [];
    end
    
    methods
        function obj = ClusterBoundaryTrackingModeler()
            obj.setDefault();
        end
        
        function setClusterBoundaryTracker(obj, clusterBoundaryTrackingObj)
           obj.clusterBoundaryTrackerObj = clusterBoundaryTrackingObj; 
        end
        
        function setDefault(obj)
            cbt = ClusterBoundaryTracking();
            
            cbt.hyperparameters.KeepDataPoints = true;
            cbt.hyperparameters.PlotClusterState = false;
            cbt.hyperparameters.ClusterEachIteration = false;
            
            %cbt.setClusterMethod();
            
            obj.clusterBoundaryTrackingObj = cbt;
        end
    end
    
    %% Interface Methods
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            obj.clusterBoundaryTrackerObj.processNewData(data);
            newData = obj.clusterBoundaryTrackingObj.clusterTransitions(end);
        end
    end
end

