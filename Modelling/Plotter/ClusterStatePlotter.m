% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY Modeler.m
classdef ClusterStatePlotter < Plotter
    %CLUSTERSTATEPLOTTER 
    
    properties
        
    end
    
    methods
        function obj = ClusterStatePlotter()
            %CLUSTERSTATEPLOTTER 
        end
    end
    
    %% Interface Methods
    methods
        function transfer(obj, data)
            if isa(data, 'ClusterState')
                obj.F;
                obj.plotClusterState(data)
            else
                error(['data is not of type ClusterState'])
            end
        end
    end
    
    methods
        %% - plotClusterState
        function plotClusterState(obj, clusterState)
            % plot the current state
            % check if there more datapoints then clusterindices, this can
            %   happen because a cluster can be appended
            numOfUnclusteredPoints = size(clusterState.dataPoints, 1) - length(clusterState.clusterIndices);
            ClusteringTools.plotCluster(clusterState.dataPoints(1 : end - numOfUnclusteredPoints, :), clusterState.clusterIndices, true, false);
            % plot unclustered datapoints
            if numOfUnclusteredPoints > 0
                unclusteredDataPoints = clusterState.dataPoints(end - numOfUnclusteredPoints : end, :);
                hold on                    
                if size(unclusteredDataPoints, 2) == 1
                    error('plotting is not implemented for 1D yet!')
                elseif size(unclusteredDataPoints, 2) == 2
                    scatter(unclusteredDataPoints(:, 1), unclusteredDataPoints(:, 2), 45, 'MarkerFaceColor', [0.3 0.3 0.3], 'MarkerEdgeColor', [0 0 0])
                elseif size(unclusteredDataPoints, 2) == 3
                    scatter3(unclusteredDataPoints(:, 1), unclusteredDataPoints(:, 2), unclusteredDataPoints(:, 3), 45, 'MarkerFaceColor', [0.3 0.3 0.3], 'MarkerEdgeColor', [0 0 0])
                else
                    error('plotting is only implemented for 1D, 2D and 3D datapoints!')
                end
                %legs = P.getLegend(gcf);
                % append new legend correctly
                %legs = legs{1, 1};
                %legs{end} = 'Unclustered Datapoints';
                %P.setLegend(gcf, legs);
                hold off
            end
            %P.setLegendPosition(gcf, [0.89, 0.8, 0.3, 0.2])
            grid on
            grid minor
            title(['Number of Data points:' num2str(clusterState.nDataPoints) ', Number of Clusters: ' num2str(clusterState.kClusters)])                                
        end
    end
end

