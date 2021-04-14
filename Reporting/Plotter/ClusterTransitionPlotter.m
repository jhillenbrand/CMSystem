% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 02.01.2021
% DEPENDENCY HoldOnPlotter.m
classdef ClusterTransitionPlotter < Plotter
    %CLUSTERTRANSITIONPLOTTER   
    properties
        
    end
    
    methods
        function obj = ClusterTransitionPlotter()
            %CLUSTERTRANSITIONPLOTTER
            obj@Plotter();
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if ~isempty(data)
                if isa(data, class(ClusterTransition.empty))
                    ClusterTracking.plotTransitionVector(data);
                else
                    error(['data is not of type ' class(ClusterTransition.empty)])
                end
            else
                warning([class(ClusterTransitionPlotter.empty) ' --> no data was passed'])
            end
        end
    end
end

