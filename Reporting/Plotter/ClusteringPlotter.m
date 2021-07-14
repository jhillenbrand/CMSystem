% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY Modeler.m
classdef ClusteringPlotter < Plotter
    %ClusteringPlotter 
    
    %% Label properties
    properties
        labelInds = [];
        labels = {};
    end
    
    methods
        function obj = ClusteringPlotter()
            %ClusteringPlotter
            obj@Plotter(false, [class(ClusteringPlotter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']']);
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if ~isempty(data)
                if isa(data, class(ClusterBoundaryTracking2.empty))
                    % only plot if clustering was clustered before
                    if isempty(data.lastClustering.clusterIndices)
                        warning([class(ClusteringPlotter.empty) ' --> no clusterIndices in ' class(Clustering.empty) ' were found'])
                        return;
                    end
                    if ~isempty(obj.labelInds)
                        subplot(2, 1, 1)                        
                            data.plotClustering()
                        
                        subplot(2, 1, 2)
                            X = data.lastClustering.dataPoints;
                            len = size(X, 1);
                            li = obj.labelInds(1 : len);
                            u = unique(li);
                            l = obj.labels(1 : length(u));
                            ClusteringTools.plotClusterLabels(X, li, l, data.featureNames)
                    else
                        data.plotClustering()
                    end
                else
                    error(['data is not of type ' class(ClusterBoundaryTracking2.empty)])
                end
            else
                warning([class(ClusteringPlotter.empty) ' --> data was empty'])
            end
        end
    end
end

