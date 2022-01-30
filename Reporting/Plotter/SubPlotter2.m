classdef SubPlotter2 < Plotter
    %SUBPLOTTER2
    
    properties
        numOfPlots = 1;
        currentSubPlot = 1;
        holdOn = [];
    end
    
    methods
        function obj = SubPlotter2(numOfPlots)
            %SubPlotter
            obj@Plotter();
            if nargin < 1
                numOfPlots = 1;
            end
            obj.numOfPlots = numOfPlots;
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            % get focus back to figure (in background or foreground)
            % depending on config
            if obj.isEnabled
                if obj.noFocus
                    set(groot, 'CurrentFigure', obj.F);
                else
                    figure(obj.F);
                end
                
                % activate current subplot
                subplot(obj.numOfPlots, 1, obj.currentSubPlot);
                
                % hold on
                if obj.holdOn(obj.currentSubPlot)
                	hold on
                end
                
                % report function contains the actual logic of corresponding
                % plotter                
                obj.report(data);
                
                % set axis labels and legends if given
                if DataTransformer.is1D(data)
                    if ~isempty(obj.axisLabels)
                        labels = obj.axisLabels(obj.currentSubPlot, :);
                        ylabel(labels{1});
                    end
                elseif DataTransformer.is2D(data)
                    if ~isempty(obj.axisLabels)
                        labels = obj.axisLabels(obj.currentSubPlot, :);
                        xlabel(labels{1});
                        ylabel(labels{2});
                    end
                elseif DataTransformer.is3D(data)
                    if ~isempty(obj.axisLabels)
                        labels = obj.axisLabels(obj.currentSubPlot, :);
                        xlabel(labels{1});
                        ylabel(labels{2});
                        zlabel(labels{3});
                    end
                end
                if ~isempty(obj.legends)
                    legs = obj.legends(obj.currentSubPlot, :);
                    legend(legs);
                end
                
                % set axis limits if available
                if ~isempty(obj.xAxisLimits)
                    xlim(obj.xAxisLimits);
                end
                if ~isempty(obj.yAxisLimits)
                    ylim(obj.yAxisLimits);
                end
                if ~isempty(obj.zAxisLimits)
                    zlim(obj.zAxisLimits);
                end
                
                % hold off                
                if obj.holdOn(obj.currentSubPlot)
                	hold off
                end
                
                % increment subplot number
                obj.currentSubPlot = obj.currentSubPlot + 1;                
                if (obj.currentSubPlot > obj.numOfPlots)
                    obj.currentSubPlot = 1;
                end
                
                drawnow
            end
            newData = data;
        end
    end
    
end

