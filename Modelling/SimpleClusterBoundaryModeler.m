classdef SimpleClusterBoundaryModeler < Modeler
    %CLUSTERBOUNDARYTRACKINGMODELER2
        
    properties
        boundaryClusterer = [];
    end
    
    methods
        function obj = SimpleClusterBoundaryModeler()
            obj.setDefault();
        end
        
        function setBoundaryClusterer(obj, boundaryClusterer)
           obj.boundaryClusterer = boundaryClusterer; 
        end
        
        function setDefault(obj)
            clusterer = SimpleBoundaryClusterer();
            
            clusterer.hyperparameters.MinSizeDataPoints = 25;
            clusterer.hyperparameters.NormalizeDataPoints = true; 
                        
            obj.boundaryClusterer = clusterer;
        end
    end
    
    %% Interface Methods
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            obj.boundaryClusterer.processNewData(data);
            % return the whole clusterBoundaryTrackingObj for connected
            %   observers, logic is contained in connected observers
            if isempty(obj.boundaryClusterer.clusterStates)
                newData = [];
            else
                newData = obj.boundaryClusterer.clusterStates(end);
                newData.dataPoints = obj.boundaryClusterer.dataPoints;
            end
        end
    end
    
    %% Public Helper Methods
    methods
        
    end
end

