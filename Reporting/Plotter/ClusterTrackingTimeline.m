% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: 0.1
% DATE: 25.05.2021
% DEPENDENCY: Plotter.m, ClusterTransition.m
classdef ClusterTrackingTimeline < Plotter
    %ClusterTrackingTimeline 
    
    properties
        secsInWindow = 120;
        levels = 2;
        lastLevel = 0;
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
                    [eventTime, eventText] = obj.processTransitions(data);
                    if ~isempty(eventText) && ~isempty(eventTime)
                        P.addTimeLineEvent(obj.lastTime, eventTime, obj.nextLevel(), eventText, obj.levels);
                        if ~isempty(eventTime)
                            obj.lastTime = eventTime;
                        end
                        xlim([eventTime - obj.secsInWindow * 1000, eventTime + obj.secsInWindow])
                    end
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
            eventTime = [];
            uniqueTransitions = ClusterTransition.getUniqueTransitions(transitions);
            for t = 1 : length(uniqueTransitions) 
                % outlier creation --> +anomaly
                if uniqueTransitions(t).type == TransitionType.OutlierCreateTransition
                    if strcmp(eventText, '') 
                        eventText = 'new anomaly detected';
                    else
                        eventText = [eventText ', ' 'new anomaly detected'];
                    end
                    eventTime = uniqueTransitions(t).timestamp;
                end
                
                % cluster creation --> +state
                if uniqueTransitions(t).type == TransitionType.CreateTransition
                    if strcmp(eventText, '')
                        eventText = 'new state detected';
                    else
                        eventText = [eventText ', new state detected'];
                    end
                    eventTime = uniqueTransitions(t).timestamp;
                end
                
                % cluster merge --> -state
                if uniqueTransitions(t).type == TransitionType.MergeTransition
                    if strcmp(eventText, '')
                        eventText = 'state withdrawn';
                    else
                        eventText = [eventText ', state withdrawn'];
                    end
                    eventTime = uniqueTransitions(t).timestamp;
                end
                                
                % recurrent cluster transition --> stable state
                if uniqueTransitions(t).type == TransitionType.RecurrentClusterTransition
                    if strcmp(eventText, '')
                        eventText = 'return within stable state';
                    else
                        eventText = [eventText ', return within stable state'];
                    end
                    eventTime = uniqueTransitions(t).timestamp;
                end
            end
        end
        
        function level = nextLevel(obj)
            level = obj.lastLevel + 1;
            if level > obj.levels
                level = -obj.levels;
            elseif level == 0
                level = level + 1;
            end
            obj.lastLevel = level;
        end
    end
    
end

