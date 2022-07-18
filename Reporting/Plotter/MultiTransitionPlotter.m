% AUTHOR jonas.hillenbrand@kit.edu
% VERSION 0.1
% DATE 14.07.2021
% DEPENDENCY HoldOnPlotter.m
classdef MultiTransitionPlotter < Plotter
    %TransitionPlotter   
    properties
        
    end
    
    methods
        function obj = MultiTransitionPlotter(name)
            %TransitionPlotter
            if nargin < 1
                name = [class(MultiTransitionPlotter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@Plotter(false, name);
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if ~isempty(data)
                if iscell(data)
                    if isa(data{1, 1}, class(ClusterBoundaryTracking2.empty))
                        for i = 1 : size(data, 1)
                            for j = 1 : size(data, 2)
                                hold on
                                data{i, j}.plotTransitions((i - 1) / size(data, 1), (j - 1) / size(data, 2));
                                hold off
                            end
                        end                    
                    else
                        error(['data is not of type ' class(ClusterBoundaryTracking2.empty)])
                    end
                else
                    error([class(MultiTransitionPlotter.empty) ' --> data must be of type cell'])
                end
            else
                warning([class(MultiTransitionPlotter.empty) ' --> no data was passed'])
            end
        end
    end
end

