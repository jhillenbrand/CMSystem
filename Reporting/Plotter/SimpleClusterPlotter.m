% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY Modeler.m
classdef SimpleClusterPlotter < Plotter
    %SIMPLECLUSTERPLOTTER
    
    properties
        plotCenterTrend = true;
    end
    
    methods
        function obj = SimpleClusterPlotter()
            %SIMPLECLUSTERPLOTTER 
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if ~isempty(data)
                if isa(data, class(SimpleBoundaryClusterer.empty))
                    data.clusterStates(end).plot(obj.plotCenterTrend);
                    drawnow
                else
                    error(['data is not of type ClusterState'])
                end
            else
                warning('data was empty');
            end
        end
    end
end

