classdef Plotter < Modeler
    %PLOTTER 
    
    properties
        F = []; % figure variable
        numOfDataPoints = 0;
    end
    
    methods
        %% - Plotter
        function obj = Plotter()
            %PLOTTER
            obj.F = figure();
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
    end
end

