% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 22.07.2021
% DEPENDENCY Plotter.m
classdef MultiStatePlotter < Plotter
    %MultiStatePlotter
    
    properties
        
    end
    
    methods
        function obj = MultiStatePlotter()
            %MultiStatePlotter 
            obj@Plotter(false, [class(MultiStatePlotter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']']);      
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if ~isempty(data)
                if iscell(data)
                    first = true;
                    countPlots = obj.countNonEmptyClusterers(data);                    
                    rows = ceil(countPlots / 2);
                    cols = ceil(countPlots / rows);
                    count = 1;
                    %if rows > 0
                    %    ha = P.tightSubplot(rows, cols, 0.005, 0.1, 0.1);
                    %end
                    if rows > 0
                        t = tiledlayout(rows, cols);
                        t.TileSpacing = 'compact';
                        t.Padding = 'compact';
                    end
                    for i = 1 : size(data, 1)
                        for j = 1 : size(data, 2)                            
                            if ~isempty(data{i, j})
                                if isa(data{i, j}, class(ClusterBoundaryTracking2.empty))
                                    if isempty(data{i, j}.lastClustering)
                                        warning(['no cluster states found in ' class(ClusterBoundaryTracking2.empty) '(' num2str(i) ',' num2str(j) ') in' obj.name]);
                                    else
                                       if ~isempty(data{i, j}.lastClustering.S_i)
                                            nexttile 
                                            %subplot(rows, cols, count)
                                            %axes(ha(count));
                                            data{i, j}.plotStates(data{i, j}.lastClustering);
                                            
                                            text(0, 0, data{i, j}.name);
                                            
                                            count = count + 1;
                                        end
                                    end
                                else
                                    error(['data[' class(data{i, j}) '] is not of type ' class(ClusterBoundaryTracking2.empty)])
                                end
                            end
                        end
                    end
                    drawnow
                else
                    error(['data[' class(data) '] must of type cell'])
                end
            else
                warning(['data was empty in ' obj.name]);
            end
        end
    end
    
    methods (Access = private)
        function count = countNonEmptyClusterers(obj, data)
            count = 0;
            for i = 1 : size(data, 1)
                for j = 1 : size(data, 2)                            
                    if isa(data{i, j}, class(ClusterBoundaryTracking2.empty))
                        if ~isempty(data{i, j}.lastClustering)
                            if ~isempty(data{i, j}.lastClustering.clusterIndices)
                                count = count + 1;
                            end
                        end
                    end
                end
            end
        end
    end
    
end

