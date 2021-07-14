% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 14.07.2021
% DEPENDENCY HoldOnPlotter.m
classdef TransitionPlotter < Plotter
    %TransitionPlotter   
    properties
        
    end
    
    methods
        function obj = TransitionPlotter()
            %TransitionPlotter
            obj@Plotter(false, [class(TransitionPlotter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']']);
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if ~isempty(data)
                if isa(data, class(ClusterBoundaryTracking2.empty))
                    data.plotTransitions();
                else
                    error(['data is not of type ' class(ClusterBoundaryTracking2.empty)])
                end
            else
                warning([class(TransitionPlotter.empty) ' --> no data was passed'])
            end
        end
    end
end

