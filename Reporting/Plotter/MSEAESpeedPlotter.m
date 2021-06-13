classdef MSEAESpeedPlotter < Plotter
    %MSEAESpeedPlotter 
    
    properties
    end
    
    methods
        function obj = MSEAESpeedPlotter()
            %MSEAESpeedPlotter
            obj@Plotter();            
            view(30, 30)
            grid on
            grid minor
            box on
            xlabel('Speeds [-]')
            ylabel('Segmentations [-]')
            zlabel('MSE [-]')
        end
    end
    
    %% Interface Methods
    methods
        function report(obj, data)
            if iscell(data)
                if ~isempty(data)
                    hold on
                    for i = 1 : size(data, 1)
                        mse_ = data(i, :);
                        for j = 1 : size(mse_, 2)
                            z = mse_{1, j};
                            x = i * ones(size(z));
                            y = j * ones(size(z));
                            P.scatter3(x, y, z, P.red, [0 0 0], 30)
                        end
                    end
                    drawnow
                    hold off
                end
            else
                error(['data[' class(data) '] must be of type cell'])
            end
        end
    end
end

