% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: 0.1
% DATE: 25.05.2021
% DEPENDENCY: Plotter.m, ClusterTransition.m
classdef ClusterTrackingTimeline < Plotter
    %ClusterTrackingTimeline 
    
    properties
        secsInWindow = 120;
        levels = 1;
        lastLevel = [];
        lastTime = [];
    end
    
    methods
        function obj = ClusterTrackingTimeline()
            %ClusterTrackingTimeline
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
        function [eventTime, eventText] = processTransitions(obj, transitions)            
            eventText = '';
            uniqueTransitions = ClusterTransition.getUniqueTransitions(transitions);
            for t = 1 : length(uniqueTransitions) 
                % outlier creation --> +anomaly
                if uniqueTransitions(t).type == TransitionType.OutlierCreateTransition
                    obj.anomalyCount = obj.anomalyCount + 1;
                    if strcmp(eventText, '')
                        eventText = 'new anomaly detected';
                    else
                        eventText = [eventText ', ' 'new anomaly detected'];
                    end
                    eventTime = uniqueTransitions(t).timestamp;
                end
                
                % cluster creation --> +state
                if uniqueTransitions(t).type == TransitionType.CreateTransition
                    obj.stateCount = obj.stateCount + 1;
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(eventText, '')
                        eventText = 'new state detected';
                    else
                        eventText = [eventText ', new state detected'];
                    end
                end
                
                % cluster merge --> -state
                if uniqueTransitions(t).type == TransitionType.MergeTransition
                    obj.stateCount = obj.stateCount - 1;
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(eventText, '')
                        eventText = 'state withdrawn';
                    else
                        eventText = [eventText ', state withdrawn'];
                    end
                end
                                
                % recurrent cluster transition --> stable state
                if uniqueTransitions(t).type == TransitionType.RecurrentClusterTransition
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(eventText, '')
                        eventText = 'return within stable state';
                    else
                        eventText = [eventText ', return within stable state'];
                    end
                end
            end
        end
    end
    
end

