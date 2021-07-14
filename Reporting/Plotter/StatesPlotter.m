% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY Modeler.m
classdef StatesPlotter < Plotter
    %StatesPlotter 
       
    methods
        function obj = StatesPlotter()
            %StatesPlotter
            obj@Plotter(false, [class(StatesPlotter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']']);
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if ~isempty(data)
                if isa(data, class(ClusterBoundaryTracking2.empty))
                    % only plot if states are non-empty
                    if isempty(data.lastClustering.S_i)
                        warning([class(ClusteringPlotter.empty) ' --> no states in ' class(Clustering.empty) ' were found'])
                    else                        
                        data.plotStates(data.lastClustering);
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

