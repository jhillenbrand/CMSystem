classdef SubPlotter < Plotter
    %PLOTTER 
    
    properties
        headers = {};
    end
    
    methods
        function obj = SubPlotter(headers)
            %SubPlotter
            obj@Plotter();
            if nargin < 1
                headers = {};
            end
            obj.headers = headers;
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            P.plotDataColumnsIntoSubplots(data, obj.headers);
        end
    end
    
end

