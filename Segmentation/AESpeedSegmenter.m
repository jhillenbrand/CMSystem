classdef AESpeedSegmenter < Segmenter
    %AESPEEDSEGMENTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        minWindowSize = 4;
        minSpeed = 10;
        tau = 2.5;
    end
    
    methods
        function obj = AESpeedSegmenter()
            %AESPEEDSEGMENTER
        end
    end
    
    %% interface Methods
    methods
        function newData = segment(obj, data)
            if ~isempty(data)
                t_plc = data{3, 1};
                s_plc = data{4, 1};
                t_ae = data{1, 1};
                d_ae = data{2, 1};

                speed_sections = Mapping.findConstantSections([t_plc, s_plc], obj.tau, obj.minWindowSize, obj.minSpeed);
                ae_sections = cell(size(speed_sections));
                speeds = zeros(size(speed_sections));
                for s = 1 : length(speed_sections)
                    sd = speed_sections{s, 1};
                    ts1 = sd(1, 1);
                    ts2 = sd(end, 1);
                    aeInd = t_ae >= ts1 & t_ae <= ts2;
                    ds_ae = d_ae(aeInd);
                    ae_sections{s, 1} = ds_ae;
                    speeds(s, 1) = floor(mean(sd(:, 2)));
                end
                newData = [ae_sections, speeds];
            else  
                newData = [];
            end
        end
    end
end

