classdef AESpeedFilter < Preprocessor
    %AESpeedFilter 
    
    properties
        minSpeed = 0;
        lowerLim = 0;
        upperLim = 0;
        sampleRate = 0;
    end
    
    methods
        function obj = AESpeedFilter(minSpeed, lowerLim, upperLim, sampleRate)
            %AESpeedFilter 
            if nargin < 4
                error('not enough input arguments')
            end
            obj@Preprocessor([class(AESpeedFilter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'], []);           
            obj.minSpeed = minSpeed;
            obj.lowerLim = lowerLim;
            obj.upperLim = upperLim;
            obj.sampleRate = sampleRate;
        end       
    end
    
    %% Interface EMethods
    methods
        function newData = transform(obj, data)
            %filterFunc(data, minSpeed, lowerLim, upperLim, sampleRate)
            if ~isempty(data)           
                %t_plc = data{3, 1};
                s_plc = data{4, 1};
                t_ae = data{1, 1};
                d_ae = data{2, 1};
                sInd = (s_plc > obj.minSpeed);
                if sum(sInd) > 1
                    [d_ae_r, inds] = SignalAnalysis.removeWindowsInRange(d_ae, obj.lowerLim, obj.upperLim, ceil(obj.sampleRate * 0.05), false);            
                    t_ae_r = t_ae(inds);
                    newData = [t_ae_r, d_ae_r];
                else
                    newData = [];
                end
            else
                newData = [];
            end            
        end
    end
end

