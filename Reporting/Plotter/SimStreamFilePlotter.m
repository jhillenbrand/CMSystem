classdef SimStreamFilePlotter < Plotter
    %SIMSTREAMFILEPLOTTER 
    
    properties
        simStreamAcquisitor = [];
        fileFieldInds = [];
    end
    
    methods
        function obj = SimStreamFilePlotter(simStreamAcquisitor, fileFieldInds)
            %SIMSTREAMFILEPLOTTER
            obj.simStreamAcquisitor = simStreamAcquisitor;
            obj.fileFieldInds = fileFieldInds;
        end
    end
    
    %% Interface Methods
    methods
        
    end
end

