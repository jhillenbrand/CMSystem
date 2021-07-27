classdef AEPLCSimStreamPlotter < Plotter
    %AEPLCSimStreamPlotter 
    
    properties
        
    end
    
    methods
        function obj = AEPLCSimStreamPlotter()
            %SIMSTREAMFILEPLOTTER
            obj@Plotter(false, [class(AEPLCSimStreamPlotter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']']);
            obj.legends = {'AE [bit]', 'Speed [1/min]'};
            obj.axisLabels = {'TIME UTC [ms]', 'AE [bit]', 'Speed [1/min]'};
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if ~isempty(data)
                if iscell(data)
                    t_ae = data{1, 1};
                    d_ae = data{2, 1};
                    t_plc = data{3, 1};
                    d_plc = data{4, 1};
                    yyaxis left
                        plot(t_ae, d_ae)
                        ylabel(obj.axisLabels{2})

                    yyaxis right
                        plot(t_plc, d_plc);
                        ylabel(obj.axisLabels{3})

                    xlabel(obj.axisLabels{1})
                    grid on
                    grid minor
                    legend(obj.legends)
                    drawnow
                else
                    error(['data[' class(data) '] must be of type cell'])
                end
            end
        end
    end
end

