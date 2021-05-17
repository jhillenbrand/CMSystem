% AUTHOR: jonas.hillenbrand@kit.edu
% VERSION: V0.1
% DATE: 27.04.2021
% DEPENDENCY: Plotter.m
% LICENCES: 
classdef FFTPlotter < Plotter
    %FFTPLOTTER 
    
    properties
        sampleRate = 0;
    end
    
    methods
        %% - TimePlotter
        function obj = FFTPlotter(sampleRate)
            %PLOTTER
            obj@Plotter();
            obj.sampleRate = sampleRate;
        end        
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if isnumeric(data)
                plot(data(:, 1), data(:, 2))
                xlabel('Frequency [Hz]')
                ylabel('Amplitude [-/Hz]')
                grid on
                grid minor
            else
                whos(data)
                error('dimension or type of is are not supported for plotting');
            end
        end
    end
end

