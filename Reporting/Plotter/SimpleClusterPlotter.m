% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY Modeler.m
classdef SimpleClusterPlotter < Plotter
    %SIMPLECLUSTERPLOTTER
    
    properties
        frames = [];
        recordPlot = [];
    end
    
    methods
        function obj = SimpleClusterPlotter(recordPlot)
            %SIMPLECLUSTERPLOTTER 
            if nargin < 1
                obj.recordPlot = false;
            else
                obj.recordPlot = recordPlot;
            end
            
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            if ~isempty(data)
                if isa(data, 'ClusterState')
                    figure(obj.F);
                    ClusteringTools.plotCluster(data.dataPoints, data.clusterIndices, true, false);
                    if obj.recordPlot
                        obj.frames = [obj.frames; getframe(gcf)];
                    end
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

