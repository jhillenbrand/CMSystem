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
        currentLogEntry = '';
        lastLogEntry = '';
        eventLog = {};    % contains text info about the current state,
                                    %   e.g. transient/continuous state,
                                    %   state on the verge of changing to other state (CenterOutOfBoundsDrift),
                                    %   ...
        maxLogEntries = 7;
        transitionHistory = [];
    end
    
    methods
        function obj = AnomalyAndStateTracker()
            %ANOMALYANDSTATETRACKER
            obj@Plotter();
        end       
    end
    
    %% interface methods
    methods
        function newData = report(obj, data)
            newData = [];
            if ~isempty(data)
                if isa(data, class(ClusterTransition.empty))
                    obj.processTransitions(data);
                    names = {'States', 'Anomalies'};
                    subplot(1, 3, 1)
                        counts = [obj.stateCount, obj.anomalyCount];
                        b = bar(1, counts(1));
                        b.FaceColor = P.darkgreen();                   
                        xtips1 = b.XEndPoints;
                        ytips1 = b.YEndPoints;
                        labels1 = string(b.YData);
                        text(xtips1, ytips1, labels1, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')                                                
                        hold on
                        b = bar(2, counts(2));
                        b.FaceColor = P.red();
                        xtips1 = b.XEndPoints;
                        ytips1 = b.YEndPoints;
                        labels1 = string(b.YData);
                        text(xtips1, ytips1, labels1, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')                                                
                        set(gca, 'xtick', [1 : 2],'xticklabel',names)
                        m = max(counts);
                        ylim([0, m + 5])
                        hold off
                    if ~isempty(obj.currentLogEntry)                                  
                        if ~strcmp(obj.lastLogEntry, obj.currentLogEntry)
                            if length(obj.eventLog) >= obj.maxLogEntries
                                obj.eventLog = obj.eventLog(2:end);
                                obj.eventLog{end + 1} = [datestr(now) ' --> ' obj.currentLogEntry newline];
                            else 
                                obj.eventLog{end + 1} = [datestr(now) ' --> ' obj.currentLogEntry newline];
                            end
                        else
                            if isempty(obj.eventLog)
                                obj.eventLog{1} = [datestr(now) ' --> ' obj.currentLogEntry newline];
                            else
                                obj.eventLog{end} = [datestr(now) ' --> ' obj.currentLogEntry newline];
                            end
                        end
                        if ~isempty(obj.eventLog)
                            et1 = ['current state: ' num2str(obj.currentState)];                    
                            et2 = ['Log: ' newline obj.eventLog];

                            subplot(1, 3, 2:3)
                                plot(0,0)
                                xlim([0, 20])
                                ylim([0, 20])
                                text(1, 19, et1);
                                text(1, 8, et2);
                                P.removeAxisTicks(false)
                                set(gca,'Color',P.gold())
                        end
                    end                        
                    obj.lastLogEntry = obj.currentLogEntry;
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
                        obj.currentLogEntry = [obj.currentLogEntry ',' newline 009 'new anomaly detected'];
                    end
                end
                
                % outlier decrease --> -anomaly
                if uniqueTransitions(t).type == TransitionType.OutlierVanishTransition
                    obj.anomalyCount = obj.anomalyCount - 1;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'anomaly withdrawn';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ',' newline 009 'anomaly withdrawn'];
                    end
                end
                % outlier merge --> -anomaly
                if uniqueTransitions(t).type == TransitionType.OutlierMergeTransition
                    obj.anomalyCount = obj.anomalyCount - 1;
                    obj.currentState = -11;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'anomalies formed new state over time';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ',' newline 009 'anomalies formed new state over time'];
                    end
                end
                % outliers formed cluster --> -anomaly
                if uniqueTransitions(t).type == TransitionType.OutlierToStateTransition
                    obj.anomalyCount = obj.anomalyCount - 1;
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'anomalies belong to existing state';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ',' newline 009 'anomalies belong to existing state'];
                    end
                end
                
                % cluster creation --> +state
                if uniqueTransitions(t).type == TransitionType.CreateTransition
                    obj.stateCount = obj.stateCount + 1;
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'new state detected';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ',' newline 009 'new state detected'];
                    end
                end
                
                % cluster merge --> -state
                if uniqueTransitions(t).type == TransitionType.MergeTransition
                    obj.stateCount = obj.stateCount - 1;
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'state withdrawn';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ',' newline 009 'state withdrawn'];
                    end
                end               
                % repeating old cluster transition --> -state
                if uniqueTransitions(t).type == TransitionType.ConsumeOldStateTransition
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'state withdrawn (it already exists)';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ',' newline 009 'state withdrawn (it already exists)'];
                    end
                end
                
                % recurrent cluster transition --> stable state
                if uniqueTransitions(t).type == TransitionType.RecurrentClusterTransition
                    obj.currentState = uniqueTransitions(t).clusterIndex;
                    if strcmp(obj.currentLogEntry, '')
                        obj.currentLogEntry = 'return within stable state';
                    else
                        obj.currentLogEntry = [obj.currentLogEntry ',' newline 009 'return within stable state'];
                    end
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

