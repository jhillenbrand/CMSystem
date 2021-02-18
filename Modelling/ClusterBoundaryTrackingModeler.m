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
           obj.clusterBoundaryTrackingObj = clusterBoundaryTrackingObj; 
        end
        
        function setDefault(obj)
            cbt = ClusterBoundaryTracking();
            
            cbt.hyperparameters.KeepDataPoints = true;
            cbt.hyperparameters.DisplayClusterState = false;
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
            obj.clusterBoundaryTrackingObj.processNewData(data);
            % return the whole clusterBoundaryTrackingObj for connected
            %   observers, logic is contained in connected observers
            newData = obj.clusterBoundaryTrackingObj;
        end
    end
    
    %% Public Helper Methods
    methods
        function clusterTransitions = getLatestTransitions(obj)
            clusterTransitions = obj.clusterBoundaryTrackingObj.clusterTransitions;
        end
    end
end

