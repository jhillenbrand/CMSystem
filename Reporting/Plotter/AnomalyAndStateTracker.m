% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: 0.1
% DATE: 25.05.2021
% DEPENDENCY: Plotter.m, ClusterTransition.m
classdef AnomalyAndStateTracker < Plotter
    %ANOMALYANDSTATETRACKER 
    
    properties
        anomalyCount = 0;
        stateCount = 1;
        currentState = 0;
        currentDescription = '';    % contains text info about the current state,
                                    %   e.g. transient/continuous state,
                                    %   state on the verge of changing to other state (CenterOutOfBoundsDrift),
                                    %   ...
        transitionHistory = [];
    end
    
    methods
        function obj = AnomalyAndStateTracker()
            %ANOMALYANDSTATETRACKER 
        end       
    end
    
    %% interface methods
    methods
        function newData = report(obj, data)
            newData = [];
            if ~isempty(data)
                if isa(data, class(ClusterTransition.empty))
                    obj.transitionHistory = [obj.transitionHistory; data];
                    obj.processTransitions(data);
                    c = categorical({'Anomalies','States'});
                    c = reordercats(c,{'Anomalies','States'});
                    b = bar(c, [obj.anomalyCount, obj.stateCount]);                    
                    b.FaceColor = P.darkgreen() ./ 255;
                    b.CData(1, :) = P.red() ./ 255;
                                        
                    xtips1 = b.XEndPoints;
                    ytips1 = b.YEndPoints;
                    labels1 = string(b.YData);
                    text(xtips1, ytips1, labels1, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')
                    
                    m = max([obj.anomalyCount, obj.stateCount]);
                    my = m + 20;
                    ylim([0, my])
                    
                    et1 = ['current state: ' num2str(obj.currentState)];
                    et2 = ['description: ' obj.currentDescription];
                    text(1.5, my - 5, et1);
                    text(1.5, my - 10, et2);
                    
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
            for t = 1 : length(transitions)
                % outlier creation --> +anomaly
                if transitions(t).type == TransitionType.OutlierCreateTransition
                    obj.anomalyCount = obj.anomalyCount + 1;
                    obj.currentDescription = 'new anomaly detected';
                end
                
                % outlier decrease --> -anomaly
                if transitions(t).type == TransitionType.OutlierVanishTransition
                    obj.anomalyCount = obj.anomalyCount - 1;
                    obj.currentDescription = 'anomaly withdrawn';
                end
                % outlier merge --> -anomaly
                if transitions(t).type == TransitionType.OutlierMergeTransition
                    obj.anomalyCount = obj.anomalyCount - 1;
                    obj.currentState = -11;
                    obj.currentDescription = 'anomalies formed new state over time';
                end
                
                % cluster creation --> +state
                if transitions(t).type == TransitionType.CreateTransition
                    obj.stateCount = obj.stateCount + 1;
                    obj.currentState = transitions(t).clusterIndex;
                    obj.currentDescription = 'new state detected';
                end
                % outliers formed cluster --> +state
                if transitions(t).type == TransitionType.OutlierToStateTransition
                    obj.anomalyCount = obj.anomalyCount - 1;
                    obj.currentState = transitions(t).clusterIndex;
                    obj.currentDescription = 'anomalies belong to existing state';
                end
                
                % cluster merge --> -state
                if transitions(t).type == TransitionType.MergeTransition
                    obj.stateCount = obj.stateCount - 1;
                    obj.currentState = transitions(t).clusterIndex;
                    obj.currentDescription = 'state withdrawn';
                end
                
                % survive transition --> stable state
                if transitions(t).type == TransitionType.SurviveTransition
                    obj.currentState = transitions(t).clusterIndex;
                    obj.currentDescription = 'within stable state';
                end
                
                % recurrent cluster transition --> stable state
                if transitions(t).type == TransitionType.RecurrentClusterTransition
                    obj.currentState = transitions(t).clusterIndex;
                    obj.currentDescription = 'return within stable state';
                end
                
                % check for valid state and anomaly count
                if obj.anomalyCount < 0
                    obj.anomalyCount = 0;
                end
                if obj.stateCount < 1                    
                    obj.stateCount = 1;
                end
            end
        end
    end
    
end

