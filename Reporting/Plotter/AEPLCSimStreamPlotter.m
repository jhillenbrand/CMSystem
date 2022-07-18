classdef AEPLCSimStreamPlotter < Plotter
    %AEPLCSimStreamPlotter 
    
    properties
        
    end
    
    methods
        function obj = AEPLCSimStreamPlotter(name)
            %SIMSTREAMFILEPLOTTER
            obj@Plotter(false, name);
            %[class(AEPLCSimStreamPlotter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']']);
            obj.legends = {'AE', 'Drehzahl'};
            obj.axisLabels = {'Zeit UTC [ms]', 'Spannung [mV]', 'Vorschub [mm/s]'};
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

