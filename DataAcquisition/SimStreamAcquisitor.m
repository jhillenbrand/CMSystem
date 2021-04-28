% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DATE 01.12.2020
% @DEPENDENCY
classdef SimStreamAcquisitor < DataAcquisitor
    %RANDSINEACQUISITOR
    
    properties
        files = {};
        bufferSize = 0;
        stepSize = 0;
        dataStream = [];
        plotFileFieldInds = [];        
    end
    
    properties (Access = private)
        fileFieldNameFig = [];
        plotCounter = 1;
    end
    
    methods
        function obj = SimStreamAcquisitor(dataParserObj, files, bufferSize, stepSize)
            obj@DataAcquisitor(0, true);
            if nargin > 0
                obj.files = files;
                obj.bufferSize = bufferSize;
                obj.stepSize = stepSize;
            end
            obj.dataStream = SimulateDataStream_v2(dataParserObj, obj.files, obj.bufferSize, obj.stepSize);
        end
        
        function newData = requestAvailableData(obj)
            %REQUESTAVAILABLEDATA(obj)
            if obj.dataStream.moreDataAvailable
                newData = obj.dataStream.nextData();

                % plot file name fields according to specified index
                if ~isempty(obj.plotFileFieldInds)
                    if isempty(obj.fileFieldNameFig)
                        obj.fileFieldNameFig = figure();
                        set(gcf, 'WindowStyle', 'docked')
                    end
                    fieldValues = obj.dataStream.dataParserObj.FileNameFieldValues(obj.plotFileFieldInds);
                    figure(obj.fileFieldNameFig)
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
            else
                newData = [];
            end
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            warning(['method requestData is not implemented for ' class(SimStreamAcquisitor.Empty) ', method requestAvailableData is used instead'])
            newData = obj.requestAvailableData();
        end
        
    end
end

