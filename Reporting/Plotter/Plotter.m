classdef Plotter < Reporter
    %PLOTTER 
    
    properties
        F = []; % figure variable
        numOfDataPoints = 0;
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
            figure(obj.F);
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
            newData = data;
        end
    end
    
    methods 
        function resetFigureIndex(obj)
            persistent figureIndex
            figureIndex = 0;
        end
    end
end

