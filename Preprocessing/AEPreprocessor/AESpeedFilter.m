classdef AESpeedFilter < Preprocessor
    %AESpeedFilter 
    
    properties
    end
    
    methods
        function obj = AESpeedFilter(minSpeed, lowerLim, upperLim)
            %AESpeedFilter 
            if nargin < 5
                error('not enough input arguments')
            end
            obj@Preprocessor([class(AESpeedFilter.empty) ' [' char(java.util.UUID.randomUUID().toString()) ']'], []);
            
            funcHandle = @(x) AEPreprocessor.filterFunc(x, minSpeed, lowerLim, upperLim);
            trafo = Transformation('AESpeedFilter', funcHandle);
            obj.addTransformation(trafo);
        end       
    end
    
    methods (Static)
        function newData = filterFunc(data, minSpeed, lowerLim, upperLim)
            %filterFunc(data, minSpeed, lowerLim, upperLim)
            newData = data;
            if ~isempty(data)
                t_plc = data{3, 1};
                s_plc = data{4, 1};
                t_ae = data{1, 1};
                d_ae = data{2, 1};
                sInd = (s_plc > minSpeed);
                if sum(sInd) > 1
                    newData = SignalAnalysis.removeWindowsInRange(d_ae, stillstandLowerLimit, stillstandUpperLimit, ceil(sampleRate * 0.1), false);            
                else
                    newData = [];
                end
            else
                newData = [];
            end
            if removeStillstand
                % remove stillstand sections if present defined by noise
                % lower and upper limit
                newData = SignalAnalysis.removeWindowsInRange(newData, stillstandLowerLimit, stillstandUpperLimit, ceil(sampleRate * 0.1), false);
            end
            if isempty(newData)
                newData = [NaN; NaN];
            end
        end
    end
end

