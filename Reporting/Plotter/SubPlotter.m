classdef SubPlotter < Plotter
    %PLOTTER 
    
    properties
    end
    
    methods
        function obj = SubPlotter()
            %SubPlotter
            obj@Plotter();
            
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)            
            P.plotDataColumnsIntoSubplots(data, []);
        end
    end
    
end

