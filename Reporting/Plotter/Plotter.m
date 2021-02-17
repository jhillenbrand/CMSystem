classdef Plotter < Modeler
    %PLOTTER 
    
    properties
        F = []; % figure variable
        numOfDataPoints = 0;
    end
    
    methods
        %% - Plotter
        function obj = Plotter(noFigure)
            %PLOTTER
            if nargin < 1
                noFigure = false;
            end
            if ~noFigure                
                obj.F = figure();
            end
        end
        
        function setFigure(obj, fig)
            if nargin < 1
                error('not enough input arguments')
            end
            if class(fig)~= class('Figure')
                error('input FIG must be of type Figure');
            end
            close(obj.F);
            obj.F = fig;
        end
    end
    
    %% Interface Methods
    methods
        function newData = transform(obj, data)
            newData = data;
        end
        
        function newData = transfer(obj, data)
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
end

