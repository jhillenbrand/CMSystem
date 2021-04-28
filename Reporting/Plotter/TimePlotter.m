% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: V0.1
% DATE: 27.04.2021
% DEPENDENCY: Plotter.m
% LICENCES: 
classdef TimePlotter < Plotter
    %TIMEPLOTTER 
    
    properties
        sampleRate = 0;
    end
    
    methods
        %% - TimePlotter
        function obj = TimePlotter(sampleRate)
            %PLOTTER
            obj@Plotter();
            obj.sampleRate = sampleRate;
        end        
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if isnumeric(data)
                P.timePlot(data, obj.sampleRate);
            else
                whos(data)
                error('dimension or type of is are not supported for plotting');
            end
        end
    end
end

