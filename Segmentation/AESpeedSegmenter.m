classdef AESpeedSegmenter < Segmenter
    %AESPEEDSEGMENTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        minWindowSize = 6;
        minSpeed = 10;
        tau = 3;
        returnAllSegmentData = false;
        returnOnly1Segment = true;
    end
    
    methods
        function obj = AESpeedSegmenter()
            %AESPEEDSEGMENTER
            if nargin < 1
                name = [class(AESpeedSegmenter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'];
            end
            obj@Segmenter(name);
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
                
                if ~isempty(speed_sections)
                    if obj.returnAllSegmentData
                        ae_sections = cell(size(speed_sections, 1), 2);
                        for s = 1 : length(speed_sections)
                            sd = speed_sections{s, 1};
                            ts1 = sd(1, 1);
                            ts2 = sd(end, 1);
                            aeInd = t_ae >= ts1 & t_ae <= ts2;
                            speedInd = t_plc >= ts1 & t_plc <= ts2;
                            ds_ae = d_ae(aeInd);
                            ts_ae = t_ae(aeInd);
                            ae_sections{s, 1} = [ts_ae, ds_ae];
                            ae_sections{s, 2} = sd;
                        end
                    else
                        ae_sections = cell(size(speed_sections));
                        speeds = zeros(size(speed_sections));
                        for s = 1 : length(speed_sections)
                            sd = speed_sections{s, 1};
                            ts1 = sd(1, 1);
                            ts2 = sd(end, 1);
                            aeInd = t_ae >= ts1 & t_ae <= ts2;
                            ds_ae = d_ae(aeInd);
                            ae_sections{s, 1} = ds_ae;
                            speeds(s, 1) = floor(mean(abs(sd(:, 2))));  % take mean and absolute values                        
                        end
                    end
                    if iscell(ae_sections)
                        if length(ae_sections) > 1
                            if ~obj.returnAllSegmentData
                                newData = {ae_sections, speeds};
                            else
                                newData = ae_sections;
                            end
                        else
                            if ~obj.returnAllSegmentData
                                newData = [ae_sections, speeds];
                            else
                                newData = ae_sections;
                            end
                        end
                    else
                        error('unkown ae section output')
                    end 
                    if obj.returnOnly1Segment
                        if iscell(newData{1, 1})
                            nd1 =  newData{1, 1};
                            nd2 = newData{1, 2};
                            newData = {nd1{1}, nd2(1)};
                        end
                    end
                else
                    newData = [];
                end
            else  
                newData = [];
            end
        end
    end
end

