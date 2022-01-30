classdef Plotter < Reporter
    %PLOTTER 
    
    properties
        F = []; % figure variable
        numOfDataPoints = 0;
        docked = true;
        noFocus = true;
        xAxisLimits = [];
        yAxisLimits = [];
        zAxisLimits = [];
        axisLabels = {};
        legends = {}
    end
    
    %% static variable for figure index
    methods (Access = protected)
        function figIndex = incrementFigureIndex(obj)
            persistent figureIndex
            if isempty(figureIndex)
                figureIndex = 0;
            end
            figureIndex = figureIndex + 1;
            figIndex = figureIndex;
        end
    end
    
    methods
        %% - Plotter
        function obj = Plotter(noFigure, name)
            %PLOTTER
            if nargin < 2
                name = [class(Plotter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@Reporter(name);
            if nargin < 1
                noFigure = false;
            end
            if ~noFigure                
                obj.F = obj.incrementFigureIndex();
                obj.createFigure();
            end
        end
        
        function createFigure(obj)
            figure(obj.F);
            if obj.docked
                set(gcf, 'WindowStyle', 'docked') % Insert the figure to dock
            end
            set(gcf, 'Name', obj.name, 'NumberTitle', 'off')
            set(gcf,'color', 'w');
        end
        
        function setFigure(obj, index)
            if nargin < 1
                error('not enough input arguments')
            end
            obj.F = index;
            close(figure(obj.F));
            figure(obj.F);
        end
        
        function enable(obj)
            enable@DataTransformer(obj)
            obj.createFigure();
        end
        
        function disable(obj)
            disable@DataTransformer(obj)
            close(figure(obj.F));
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
                
                % report function contains the actual logic of corresponding
                % plotter                
                obj.report(data);
                
                % set axis labels and legends if given
                if DataTransformer.is1D(data)
                    if ~isempty(obj.axisLabels)
                        ylabel(obj.axisLabels{1});
                    end
                elseif DataTransformer.is2D(data)
                    if ~isempty(obj.axisLabels)
                        xlabel(obj.axisLabels{1});
                        ylabel(obj.axisLabels{2});
                    end
                elseif DataTransformer.is3D(data)
                    if ~isempty(obj.axisLabels)
                        xlabel(obj.axisLabels{1});
                        ylabel(obj.axisLabels{2});
                        zlabel(obj.axisLabels{3});
                    end
                end
                if ~isempty(obj.legends)
                    legend(obj.legends);
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
                
                drawnow
            end
            newData = data;
        end
        
        function report(obj, data)
            if DataTransformer.is1D(data)
                P.plot1DFeatures(data);
                %if ~isempty(obj.axisLabels)
                %    ylabel(obj.axisLabels{1});
                %end
            elseif DataTransformer.is2D(data)
                P.plot2DFeatures(data);
                %if ~isempty(obj.axisLabels)
                %    xlabel(obj.axisLabels{1});
                    ylabel(obj.axisLabels{2});
                %end
            elseif DataTransformer.is3D(data)
                P.plot3DFeatures(data); 
                %if ~isempty(obj.axisLabels)
                %    xlabel(obj.axisLabels{1});
                %    ylabel(obj.axisLabels{2});
                %    zlabel(obj.axisLabels{3});
                %end
            else
                size(data)
                error('dimensions of data are not supported for plotting');
            end
            if ~isempty(obj.legends)
            %    legend(obj.legends);
            end
        end
    end
    
    methods 
        function resetFigureIndex(obj)
            persistent figureIndex
            figureIndex = 0;
        end
    end
end

