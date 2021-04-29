classdef TimeSubPlotter < Plotter
    %TimeSubPlotter 
    
    properties
        headers = {};
    end
    
    methods
        function obj = TimeSubPlotter(headers)
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
            P.plotDataColumnsIntoSubplots(data(:, 2 : end), obj.headers, data(:, 1));
        end
    end
    
end

