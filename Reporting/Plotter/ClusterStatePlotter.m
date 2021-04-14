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
        function report(obj, data)
            if ~isempty(data)
                if isa(data, 'ClusterBoundaryTracking')
                    data.plotClusterState()
                else
                    error(['data is not of type ClusterBoundaryTracking'])
                end
            else
                warning('data was empty')
            end
        end
    end
end

