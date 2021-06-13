classdef AEPLCSimStreamPlotter < Plotter
    %AEPLCSimStreamPlotter 
    
    properties
        simStreamAcquisitor = [];
        fileFieldInds = [];
        plotCounter = 0;
    end
    
    methods
        function obj = AEPLCSimStreamPlotter()
            %SIMSTREAMFILEPLOTTER
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if iscell(data)
                t_ae = data{1,1};
                d_ae = data{2, 1};
                t_plc = data{3, 1};
                d_plc = data{4, 1};
                yyaxis right
                    plot(t_ae, d_ae)
                    ylabel('AE [-]')
                
                yyaxis left
                    plot(t_plc, d_plc);
                    ylabel('Speed [1/min]')
                
                xlabel('Time [ms]')
                grid on
                grid minor
                drawnow
            else
                error(['data[' class(data) '] must be of type cell'])
            end
        end
    end
end

