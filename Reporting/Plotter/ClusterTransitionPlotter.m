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
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            if isa(data, class(ClusterBoundaryTracking.empty))
                figure(obj.F);
                data.plotTransitions();
            else
                error(['data is not of type ' class(ClusterBoundaryTracking.empty)])
            end
            newData = data;
        end
    end
end

