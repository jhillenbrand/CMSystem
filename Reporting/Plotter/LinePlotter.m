% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: V0.1
% DATE: 27.04.2021
% DEPENDENCY: Plotter.m
% LICENCES: 
classdef LinePlotter < Plotter
    %LinePlotter 
    
    properties
       
    end
    
    methods
        %% - TimePlotter
        function obj = LinePlotter()
            %PLOTTER
            obj@Plotter();
        end        
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if isnumeric(data)
                
            else
                whos(data)
                error('dimension or type of is are not supported for plotting');
            end
        end
    end
end

