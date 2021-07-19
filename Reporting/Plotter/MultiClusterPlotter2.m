% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY Modeler.m
classdef MultiClusterPlotter2 < Plotter
    %MultiClusterPlotter2
    
    properties
        
    end
    
    methods
        function obj = MultiClusterPlotter2()
            %MultiClusterPlotter 
            obj@Plotter();      
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
                    for i = 1 : size(data, 1)
                        for j = 1 : size(data, 2)                            
                            if ~isempty(data{i, j})
                                if isa(data{i, j}, class(ClusterBoundaryTracking2.empty))
                                    if isempty(data{i, j}.lastClustering)
                                        warning(['no cluster states found in ' class(ClusterBoundaryTracking2.empty) '(' num2str(i) ',' num2str(j) ') in' obj.name]);
                                    else
                                        clustering = data{i, j}.lastClustering;
                                        if ~isempty(clustering.clusterIndices)
                                            subplot(rows, cols, count)
                                            clustering.plot(false);
                                            ylabel('MSE [-]')
                                            title(['Speed ' num2str(i) ', Segmentation ' num2str(j)])
                                            P.removeXAxisTicks(true);
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

