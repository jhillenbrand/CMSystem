classdef ClusterTrackingModeler < Modeler
    %CLUSTERTRACKINGMODELER
    
    properties
        clusterTracker = ClusterTracking.empty;
    end
    
    properties
        reduceMemory = true;
    end
    
    methods
        function obj = ClusterTrackingModeler()
            %CLUSTERTRACKINGMODELER
            obj.clusterTracker = ClusterTracking();
        end
    end
    
    %% Interface Methods
    methods
        %% - transform
        function newData = transform(obj, data)
            %TRANSFORM(obj, data)
            newData = [];
            if ~isempty(data)
                if isa(data, class(SimpleBoundaryClusterer.empty))
                    % get last two clusterStates
                    if length(data.clusterStates) > 1
                        cs_i = data.clusterStates(end - 1);
                        cs_j = data.clusterStates(end);
                        transitions = obj.clusterTracker.track(cs_i, cs_j);
                        cs_i.reduceMemory();
                        newData = transitions;
                    else
                        warning([class(ClusterTrackingModeler.empty) ' --> waiting for second clusterState']);
                    end
                else
                    error([class(ClusterTrackingModeler.empty) ' --> data passed to transform step must be of class ' class(ClusterTrackingModeler.empty)]);
                end
            else
                warning([class(ClusterTrackingModeler.empty) ' --> no data was passed to transform step']);
            end
        end
    end
end

