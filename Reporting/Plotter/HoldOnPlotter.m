classdef HoldOnPlotter < Plotter
    %PLOTTER 
    
    properties
        maxHoldOn = 1000;
        holdOnCount = 0;
    end
    
    methods
        function obj = HoldOnPlotter(name, maxHoldOn)            
            %HOLDONPLOTTER(name, maxHoldOn) 
            if nargin < 2
                maxHoldOn = 1000;
            end
            if nargin < 1
                name = [class(HoldOnPlotter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@Plotter(false, name);
            obj.maxHoldOn = maxHoldOn;
            % preset holdOnCount to maxHoldOn to make sure plot is cleaned
            %   on first plot cmd
            obj.holdOnCount = obj.maxHoldOn + 1;
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
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
        end
    end
    
    %% Plotting methods
    methods        
        function plot1D(obj, data)
            if obj.maxHoldOn > obj.holdOnCount                    
                x = obj.numOfDataPoints + 1 : 1 : obj.numOfDataPoints + length(data);
                x = x(:);
                data = data(:);
                hold on       
                if length(data) == 1
                    plot(x, data, 'ro')
                else
                    plot(x, data, 'Color', P.bluegreen)
                end
                hold off
                drawnow 
            else
                obj.numOfDataPoints = 0;
                x = obj.numOfDataPoints + 1 : 1 : obj.numOfDataPoints + length(data);
                if length(data) == 1
                    plot(x, data, 'ro')
                else
                    plot(x, data, 'Color', P.bluegreen)
                end
                drawnow
                obj.holdOnCount = 0;                
            end
            obj.holdOnCount = obj.holdOnCount + 1;
            obj.numOfDataPoints = obj.numOfDataPoints + length(data);
        end
        
        function plot2D(obj, data)  
            sz = 40;
            lw = 1;
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
end

