% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY Modeler.m
classdef SimpleClusterPlotter < Plotter
    %SIMPLECLUSTERPLOTTER
    
    properties
        
    end
    
    methods
        function obj = SimpleClusterPlotter()
            %SIMPLECLUSTERPLOTTER 
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            if ~isempty(data)
                if isa(data, 'ClusterState')
                    figure(obj.F);
                    ClusteringTools.plotCluster(data.dataPoints, data.clusterIndices, true, false);
                else
                    error(['data is not of type ClusterState'])
                end
            else
                warning('data was empty');
            end
            newData = data;
        end
    end
    
    methods
        
    end
end

