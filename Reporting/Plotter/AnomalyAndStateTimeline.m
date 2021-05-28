% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: 0.1
% DATE: 25.05.2021
% DEPENDENCY: Plotter.m, ClusterTransition.m
classdef AnomalyAndStateTimeline < Plotter
    %AnomalyAndStateTimeline 
    
    properties
        secsInWindow = 120;
        levels = 2;
        currentLevel = 1;
    end
    
    methods
        function obj = AnomalyAndStateTimeline()
            %AnomalyAndStateTimeline
            obj@Plotter();
        end       
    end
    
    %% interface methods
    methods
        function newData = report(obj, data)
            newData = [];
            if ~isempty(data)
                if isa(data, class(ClusterTransition.empty))
                    
                else
                    error(['data is not of type ' class(ClusterTransition.empty)])
                end
            else 
                warning([class(AnomalyAndStateTracker.empty) ' --> no data was passed'])
            end
        end
    end
    
    %% transition methods
    methods
        function processTransitions(obj, transitions)            
            obj.currentLogEntry = '';
            uniqueTransitions = ClusterTransition.getUniqueTransitions(transitions);
            for t = 1 : length(uniqueTransitions) 
                % outlier creation --> +anomaly
                if uniqueTransitions(t).type == TransitionType.OutlierCreateTransition
                    obj.anomalyCount = obj.anomalyCount + 1;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'new anomaly detected';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ', ' 'new anomaly detected'];
                    end
                end
                
                % cluster creation --> +state
                if uniqueTransitions(t).type == TransitionType.CreateTransition
                    obj.stateCount = obj.stateCount + 1;
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'new state detected';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ', new state detected'];
                    end
                end
                
                % cluster merge --> -state
                if uniqueTransitions(t).type == TransitionType.MergeTransition
                    obj.stateCount = obj.stateCount - 1;
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'state withdrawn';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ', state withdrawn'];
                    end
                end
                                
                % recurrent cluster transition --> stable state
                if uniqueTransitions(t).type == TransitionType.RecurrentClusterTransition
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'return within stable state';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ', return within stable state'];
                    end
                end
            end
        end
    end
    
end

