classdef SimpleClusterTrackingModeler < Modeler
    %SimpleClusterTrackingModeler
    
    properties
        clusterTracker = SimpleClusterStateTracker.empty;
        transitionHistory = [];                    
    end
    
    properties
        reduceMemory = true;
    end
    
    methods
        function obj = SimpleClusterTrackingModeler()
            %SimpleClusterTrackingModeler
            obj.clusterTracker = SimpleClusterStateTracker();
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
                    obj.transitionHistory = [obj.transitionHistory; data];                    
                    % get last two clusterStates
                    if length(data.clusterStates) > 2
                        cs_i = data.clusterStates(end - 1);
                        cs_j = data.clusterStates(end);
                        transitions = obj.clusterTracker.track(data.clusterStates);
                        cs_i.reduceMemory();
                        newData = transitions;
                    else
                        warning([class(SimpleClusterTrackingModeler.empty) ' --> waiting for second complete clusterState']);
                    end
                else
                    error([class(SimpleClusterTrackingModeler.empty) ' --> data passed to transform step must be of class ' class(ClusterTrackingModeler.empty)]);
                end
            else
                warning([class(SimpleClusterTrackingModeler.empty) ' --> no data was passed to transform step']);
            end
        end
    end
end

