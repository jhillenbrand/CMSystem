classdef Plotter < Reporter
    %PLOTTER 
    
    properties
        F = []; % figure variable
        numOfDataPoints = 0;
        docked = true;
        noFocus = true;
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
        function obj = Plotter(noFigure)
            %PLOTTER
            if nargin < 1
                noFigure = false;
            end
            if ~noFigure                
                obj.F = obj.incrementFigureIndex();
                figure(obj.F);
                if obj.docked
                    set(gcf, 'WindowStyle', 'docked') % Insert the figure to dock
                end
            end
        end
        
        function setFigure(obj, index)
            if nargin < 1
                error('not enough input arguments')
            end
            obj.F = index;
            close(figure(obj.F));
            figure(obj.F);
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            % get focus back to figure (in background or foreground)
            % depending on config
            if obj.noFocus
                set(groot, 'CurrentFigure', obj.F);
            else
                figure(obj.F);
            end
            % report function contains the actual logic of corresponding
            % plotter
            obj.report(data);
            newData = data;
        end
        
        function report(obj, data)
            if DataTransformer.is1D(data)
                P.plot1DFeatures(data);
            elseif DataTransformer.is2D(data)
                P.plot2DFeatures(data);  
            elseif DataTransformer.is3D(data)
                P.plot3DFeatures(data);  
            else
                size(data)
                error('dimensions of data are not supported for plotting');
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

