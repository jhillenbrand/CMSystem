classdef MovingWindowPlotter < Plotter
    %PLOTTER 
    
    properties
        maxWindowSize = 100;
        plotHandle = [];
    end
    
    methods
        function obj = MovingWindowPlotter(noFigure, maxWindowSize)
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
        function newData = transform(obj, data)
            % set focus to the figure, if not empty
            %   empty figure can be the case if plothandle in App uiaxes is
            %   used instead
            if ~isempty(obj.F)
                figure(obj.F);
            end
            % data is assumed to be n x m, where n is the number of samples
            % and m the number fo features
            if size(data, 2) == 1
                % 1D data must be a column vector n x 1
                obj.plot1D(data);
            elseif size(data, 2) == 2
                % 2D data must be a column vector n x 2
                obj.plot2D(data);
            elseif  size(data, 2) == 3
                % 3D data must be a column vector n x 3
                obj.plot3D(data);
            else
                error(['undefined data dimensions for ' class(HoldOnPlotter)])
            end
            newData = data;
        end
    end
    
    %% Plotting methods
    methods        
        function plot1D(obj, data)
            y_last = get(obj.plotHandle,'YData');
            y_last = y_last(:);
            y = [y_last; data];
            if length(y) > obj.maxWindowSize
                y = y(end - obj.maxWindowSize : end, :);
            end
            x = 1 : 1 : length(y);
            x = x(:);
            set(obj.plotHandle, 'XData', x, 'YData', y);
            drawnow
        end
        
        function plot2D(obj, data)  
            
            sz = 40;
            lw = 1.5;
            edgeColor = [0 0 0];
            faceColor = P.bluegreen;
            if obj.maxHoldOn > obj.holdOnCount
                hold on 
                scatter(data(:, 1), data(:, 2), sz, 'MarkerFaceColor', faceColor, 'MarkerEdgeColor', edgeColor, 'LineWidth', lw)
                hold off
                drawnow 
            else
                scatter(data(:, 1), data(:, 2), sz, 'MarkerFaceColor', faceColor, 'MarkerEdgeColor', edgeColor, 'LineWidth', lw)
                box on
                grid on
                grid minor
                drawnow 
                obj.holdOnCount = 0;
            end
            obj.holdOnCount = obj.holdOnCount + 1;
        end
        
        function plot2TimeSeries(obj, data)            
            data1 = data(:, 1);
            data2 = data(:, 2);
            if obj.maxHoldOn > obj.holdOnCount                    
                x = obj.numOfDataPoints + 1 : 1 : obj.numOfDataPoints + size(data, 1);
                x = x(:);
                hold on                    
                yyaxis left
                plot(x, data1, '-o-', 'Color', P.bluegreen)
                yyaxis right
                plot(x, data2, '-*-', 'Color', P.red)
                hold off
                drawnow 
            else
                obj.numOfDataPoints = 0;
                x = obj.numOfDataPoints + 1 : 1 : obj.numOfDataPoints + size(data, 1);
                yyaxis left
                plot(x, data1, 'Color', P.bluegreen)
                yyaxis right
                plot(x, data2, 'Color', P.red)
                box on
                grid on
                grid minor
                drawnow
                obj.holdOnCount = 0;                
            end
            obj.holdOnCount = obj.holdOnCount + 1;
            obj.numOfDataPoints = obj.numOfDataPoints + size(data, 1);
        end
        
        function plot3D(obj, data)  
            sz = 40;
            lw = 1;
            edgeColor = [0 0 0];
            faceColor = P.bluegreen;
            if obj.maxHoldOn > obj.holdOnCount
                hold on 
                scatter3(data(:, 1), data(:, 2), data(:, 3), 'MarkerFaceColor', faceColor, 'MarkerEdgeColor', edgeColor, 'LineWidth', lw)
                hold off
                drawnow 
            else
                scatter3(data(:, 1), data(:, 2), data(:, 3), 'MarkerFaceColor', faceColor, 'MarkerEdgeColor', edgeColor, 'LineWidth', lw)
                box on
                grid on
                grid minor
                view(30, 30)
                drawnow 
                obj.holdOnCount = 0;
            end
            obj.holdOnCount = obj.holdOnCount + 1;
        end
    end
    
    %% setting methods
    methods
        function setPlotHandle(obj, plotHandle)
            obj.plotHandle = plotHandle;             
        end
    end
end

