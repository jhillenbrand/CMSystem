% @AUTHOR jonas.hillenbrand@kit.edu
% @VERSION 0.1
% @DATE 03.06.2021
% @DEPENDENCY
classdef AEPLCSimStreamAcquisitor < SimStreamAcquisitor
    %AEPLCSimStreamAcquisitor
    
    properties
        plcFiles = {};
        sampleRate = 2e6;
        dataColumnNames = {'SPEED [1/min]'};
        timeDataHeaderName = 'Sink Timestamp (CSV) [ms]';
        t_start_plc = [];
        aeTimeShift = 0;
    end
        
    methods
        function obj = AEPLCSimStreamAcquisitor(dataParserObj, files, plcFiles)
            obj@SimStreamAcquisitor(dataParserObj, files, 0, 0, true)
            obj.plcFiles = plcFiles;
            obj.dataStream.fileAtOnce = true;
            
            % extract time stamps from log files
            obj.t_start_plc = DataParser.getUnixTimeStampsFromFilePaths(obj.plcFiles);
                
        end
        
        function newData = requestAvailableData(obj)
            %REQUESTAVAILABLEDATA(obj)
            if obj.dataStream.moreDataAvailable
                % Step 1: load continously sampled data and start timestamp                
                d_ae = obj.dataStream.nextData();                
                if isempty(d_ae)
                    warning(['No data returned from ' class(AEPLCSimStreamAcquisitor.empty) ' ' obj.name]);
                    newData = [];
                    return;
                end
                ts_start_ae = obj.dataStream.dataParserObj.FileNameFieldValues(1);
                
                % Step 2: calculate unixtime_ms for the AE data based on extracted
                %         timestamp
                T = 1 / obj.sampleRate;                
                t_ae = 0 : T : (size(d_ae, 1) - 1) * T;
                t_ae = t_ae(:);
                t_start_ae = str2double(ts_start_ae);             
                t_ae = t_ae * 1000 + t_start_ae;
                % add time shift (correct TCP lag)
                t_ae = t_ae + obj.aeTimeShift;
                
                % Step 3: Search for corresponding PLC logfiles depending on timestamp extracted from AE filename
                %         because the plc log files contain data over multiple minutes,
                %         it may happen that corresponding plc data for a specific AE
                %         file is contained in more than on log file (this
                %         case is ignored)
            
                % Check time stamps and calculate necessary csv files
                % plc time has to be smaller then ae time

                plcFileInd = find(obj.t_start_plc > t_start_ae, 1, 'first');               
                if ~isempty(plcFileInd) && plcFileInd > 1
                    foundFile = obj.plcFiles{plcFileInd - 1, 1}; 
                else
                    % try last file
                    foundFile =  obj.plcFiles{length(obj.plcFiles), 1};
                end
                % Step 5: create the plc variables
                % load found plc files
                dp2 = DataParser();
                dp2.readFile(foundFile);
                % try to load plc time
                try
                    t_plc = dp2.getDataColumnByName(obj.timeDataHeaderName);
                catch
                    disp('Time column name is not correct');
                end
                % load other data
                d_plc = zeros(length(t_plc), length(obj.dataColumnNames));
                try
                    for i = 1 : length(obj.dataColumnNames)
                        d_plc(:, i) = dp2.getDataColumnByName(obj.dataColumnNames{i});
                    end
                catch e
                    disp(e.message)
                    disp(['Column "' obj.dataColumnNames{i} '" does not exist']);
                end
                % Step 4: find the data in plc log files that matches the same time
                %         period as the sampled Data

                % check if extra time padding is requested
                try 
                    indsLog = (t_plc >= t_ae(1) & t_plc <= t_ae(end));
                catch e
                    disp(e.message)
                end
                t_plc = t_plc(indsLog);
                d_plc = d_plc(indsLog, :);
                if isempty(t_plc)
                    warning('no matching plc log file found')
                    t_plc = [];
                    d_plc = [];
                end
                newData = {t_ae; d_ae; t_plc; d_plc};
            else
                newData = {};
            end
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            warning(['method requestData is not implemented for ' class(SimStreamAcquisitor.Empty) ', method requestAvailableData is used instead'])
            newData = obj.requestAvailableData();
        end
        
    end
end

