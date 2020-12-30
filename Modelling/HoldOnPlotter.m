classdef HoldOnPlotter < Modeler
    %PLOTTER 
    
    properties
        F = []; % figure variable
        maxHoldOn = 100;
        holdOnCount = 101;
        xIndex = 0;
    end
    
    methods
        function obj = HoldOnPlotter()
            %PLOTTER
            obj.F = figure();
        end
        
        function newData = transform(obj, data)
            newData = data;
        end
        
        function transfer(obj, data)
            obj.F;            
            if sum(size(data) == 1) == 1
                obj.plot1D(data);
            elseif size(data, 1) > 1 && size(data, 2) == 2
                obj.plot2D(data);
            elseif  size(data, 1) > 1 && size(data, 2) == 3
                obj.plot3D(data);
            end
        end
        
        function plot1D(obj, data)
            if obj.maxHoldOn > obj.holdOnCount                    
                x = obj.xIndex + 1 : 1 : obj.xIndex + length(data);
                x = x(:);
                data = data(:);
                hold on                    
                plot(x, data, 'Color', P.bluegreen)
                hold off
                drawnow 
            else
                obj.xIndex = 0;
                x = obj.xIndex + 1 : 1 : obj.xIndex + length(data);
                plot(x, data, 'Color', P.bluegreen)
                drawnow
                obj.holdOnCount = 0;                
            end
            obj.holdOnCount = obj.holdOnCount + 1;
            obj.xIndex = obj.xIndex + length(data);
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

