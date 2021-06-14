% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY Modeler.m
classdef MultiClusterPlotter < Plotter
    %MultiClusterPlotter
    
    properties
        
    end
    
    methods
        function obj = MultiClusterPlotter()
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
                            if isa(data{i, j}, class(SimpleBoundaryClusterer.empty))
                                if isempty(data{i, j}.clusterStates)
                                    warning(['no cluster states found in ' class(SimpleBoundaryClusterer.empty) '(' num2str(i) ',' num2str(j) ') in' obj.name]);
                                else
                                    clusterState = data{i, j}.clusterStates(end);
                                    if ~isempty(clusterState.clusterIndices)
                                        subplot(rows, cols, count)
                                        clusterState.plot(false);
                                        ylabel('MSE [-]')
                                        title(['Speed ' num2str(i) ', Segmentation ' num2str(j)])
                                        P.removeXAxisTicks(true);
                                        count = count + 1;
                                    end
                                end
                            else
                                error(['data[' class(data{i, j}) '] is not of type ' class(SimpleBoundaryClusterer.empty)])
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
                    if isa(data{i, j}, class(SimpleBoundaryClusterer.empty))
                        if ~isempty(data{i, j}.clusterStates)
                            if ~isempty(data{i, j}.clusterStates(end).clusterIndices)
                                count = count + 1;
                            end
                        end
                    end
                end
            end
        end
    end
    
end

