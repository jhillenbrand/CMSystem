classdef MovingWindowPlotterTimeSeries < Plotter
    %PLOTTER 
    
    properties
        maxWindowSize = 100;
        plotHandle = [];
        data = [];
    end
    
    methods
        function obj = MovingWindowPlotterTimeSeries(noFigure, maxWindowSize)
            %MOVINGWINDOWPLOTTER
            if nargin < 1
                noFigure = false;
            end
            if nargin < 2 
                maxWindowSize = 100;
            end                
            obj@Plotter(noFigure);
            obj.maxWindowSize = maxWindowSize;
            if ~noFigure
                obj.plotHandle = plot(NaN);
                xlim([0, obj.maxWindowSize])
            end
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
%             % data is assumed to be n x m, where n is the number of samples
%             % and m the number fo features
            obj.plotTimeSeries(data);
            newData = data;
        end
    end
    
    %% Plotting methods
    methods
        
        function plotTimeSeries(obj, data)
            
            if ~isempty(data)
            obj.data = [obj.data; data];
            obj.data = sortrows(obj.data,1);
            obj.data = unique(obj.data,'rows');
            time = obj.data(:, 1);
            time = 1:size(obj.data,1);
            dataY = obj.data(:, 2:end);
            plot(dataY)
            %xlim([time(end)-60*100 time(end)]);
            xlim([time(end)-60 time(end)]);
            drawnow
            end

        end
    end
    
    %% setting methods
    methods
        function setPlotHandle(obj, plotHandle)
            obj.plotHandle = plotHandle;             
        end
    end
end

