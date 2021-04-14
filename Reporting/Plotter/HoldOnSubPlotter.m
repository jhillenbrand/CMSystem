classdef HoldOnSubPlotter < Plotter
    %PLOTTER 
    
    properties
        maxHoldOn = 250;
        holdOnCount = 0;
        numOfSubplots = 2;
        currentSubplot = 1;
    end
    
    methods
        function obj = HoldOnSubPlotter(numOfSubplots)
            %HOLDONSUBPLOTTER
            obj@Plotter();
            % preset holdOnCount to maxHoldOn to make sure plot is cleaned
            %   on first plot cmd
            obj.holdOnCount = obj.maxHoldOn + 1;
            obj.numOfSubplots = numOfSubplots;
            
            % setup plots for the first time with grid
            figure(obj.F);
            for p = 1 : obj.numOfSubplots
                subplot(obj.numOfSubplots, 1, p);
                grid on
                grid minor
                box on
            end
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)            
            % check if maxHoldOn is reached and then clear plots
            if obj.holdOnCount > obj.maxHoldOn 
                for p = 1 : obj.numOfSubplots
                    subplot(obj.numOfSubplots, 1, p);
                        plot(NaN,NaN)
                end
            end
            
            % switch to next subplot            
            subplot(obj.numOfSubplots, 1, obj.currentSubplot);
            obj.currentSubplot = obj.currentSubplot + 1;
            if obj.currentSubplot > obj.numOfSubplots
                obj.currentSubplot = 1;
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
        end
    end
    
    %% Plotting methods
    methods        
        function plot1D(obj, data)
            if obj.holdOnCount > obj.maxHoldOn                 
                obj.numOfDataPoints = 0;
                x = obj.numOfDataPoints + 1 : 1 : obj.numOfDataPoints + length(data);
                plot(x, data, 'Color', P.bluegreen)
                grid on
                grid minor
                drawnow
                obj.holdOnCount = 0;
            else                               
                x = obj.numOfDataPoints + 1 : 1 : obj.numOfDataPoints + length(data);
                x = x(:);
                data = data(:);
                hold on
                % check if data is a single data point
                if sum(size(x)) == 2
                    % --> single point --> plot with marker
                    plot(x, data, '-o', 'Color', P.bluegreen)
                    grid on
                    grid minor
                else                    
                    plot(x, data, 'Color', P.bluegreen)
                    grid on
                    grid minor
                end
                hold off
                drawnow 
            end
            if obj.currentSubplot == obj.numOfSubplots 
                obj.holdOnCount = obj.holdOnCount + 1;
                obj.numOfDataPoints = obj.numOfDataPoints + length(data);
            end
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
end

