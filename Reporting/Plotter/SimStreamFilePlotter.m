classdef SimStreamFilePlotter < Plotter
    %SIMSTREAMFILEPLOTTER 
    
    properties
        simStreamAcquisitor = [];
        fileFieldInds = [];
        plotCounter = 0;
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
        function report(obj, data)
            % plot file name fields according to specified index
            if ~isempty(obj.fileFieldInds)
                fieldValues = obj.simStreamAcquisitor.dataStream.dataParserObj.FileNameFieldValues(obj.fileFieldInds);
                for f = 1 : length(fieldValues)
                    numValue = DataParser.removeNonNumericPart(fieldValues{f});
                    titleValue = strrep(fieldValues{f}, num2str(numValue{1}), '');
                    subplot(2, 1, f)
                    hold on
                    plot(obj.plotCounter, str2double(numValue{1}), [P.COLOR_SYMBOLS{f} 'o'])
                    title(titleValue)
                    hold off
                    obj.plotCounter = obj.plotCounter + 1;
                end
            end
        end
    end
end

