% @AUTHOR jonas.hillenbrand@kit.edu, Jan Detroy
% @VERSION 0.1
% @DATE 01.12.2020
% @DEPENDENCY DataAcquisitor.m, DataParser.m
classdef SyncedSimStreamAcquisitor < DataAcquisitor
    %SyncedSimStreamAcquisitor
    
    properties
        dataParser = [];
        linkedAcquisitor = [];
        SimStreamAcq = [];
        samplingRate = 0;
        log_files = [];
        dataColumnNames = [];
        timeDataHeaderName = [];
        timePadding = 0;   % [ms] can be used to extract additional time window in front and after the found time window
    end
        
    methods
        function obj = SyncedSimStreamAcquisitor(SimStreamAcq, samplingRate, log_files, dataColumnNames, timeDataHeaderName) % dataParserObj, files, bufferSize, stepSize, samplingRate, log_files
            obj@DataAcquisitor(0, true);
            if nargin > 0
                obj.SimStreamAcq = SimStreamAcq;
                obj.samplingRate = samplingRate;
                obj.log_files = log_files;
                obj.dataColumnNames = dataColumnNames;
                obj.timeDataHeaderName = timeDataHeaderName;
            end
        end
    end
    
    %% Interface Methods
    methods
        function newData = requestAvailableData(obj)
            unix_timestamp_start = obj.SimStreamAcq.dataStream.dataParserObj.FileNameFieldValues(1); %ACHTUNG!! checken was passiert wenn zweite datei geladen wird
            %d = datetime(t_log(1),'ConvertFrom','epochtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss.SSS');    
            idxFile = obj.SimStreamAcq.dataStream.idxFile;
            sampleRate = obj.samplingRate;
            
            % Step 1: load continously sampled data
            
            % differentiate between fileAtOnce DataStream and
            %   buffered/windowed data stream            
            if obj.SimStreamAcq.dataStream.fileAtOnce
                bufferSize = size(obj.SimStreamAcq.dataStream.dataParserObj.Data, 1);
            else
                bufferSize = obj.SimStreamAcq.dataStream.bufferSize;
            end
            
            % Step 2: calculate unixtime_ms for the AE data based on extracted
            %         timestamp
            T = 1 / sampleRate;                
            t = 0 : T : (bufferSize - 1) * T;
            t = t(:);
            utcTime = str2double(unix_timestamp_start);             
            t = t * 1000 + utcTime + idxFile/sampleRate*1000;  % convert to absolute ms
            
            % Step 3: Search for corresponding PLC logfiles depending on timestamp extracted from AE filename
            %         because the plc log files contain data over multiple minutes,
            %         it may happen that corresponding plc data for a specific AE
            %         file is contained in more than on log file
            
            % extract time stamps from log files
            utcTimes = DataParser.getUnixTimeStampsFromFilePaths(obj.log_files);
            % Check time stamps and calculate necessary csv files
            % plc time has to be smaller then ae time

            logFileInd = find(utcTimes > utcTime, 1, 'first');
            if ~isempty(logFileInd) && logFileInd > 1
            
            % PREVIOUS CODE
%             startFileNum = 0;
%             endFileNum = 0;
%             for i = 1:size(utcTimes)
%                 if t(1) > (utcTimes(i) - 1)
%                     startFileNum = i;
%                 end
%                 if t(end) > (utcTimes(i) - 1)
%                     endFileNum = i;
%                 end
%             end
%            csvFileNums = startFileNum : endFileNum;
%            if csvFileNums(1) > 0
%                foundFiles = obj.log_files(csvFileNums);

                foundFiles = obj.log_files(logFileInd - 1);    

                % load found log files
                dp2 = DataParser();
                dp2.readFiles(foundFiles);
                % try to load plc time
                try
                    logUtcTimes = dp2.getDataColumnByName(obj.timeDataHeaderName);
                catch
                    disp('Time column name is not correct');
                end
                % load logging data
                d_log_temp = zeros(length(logUtcTimes), length(obj.dataColumnNames));
                try
                    for i = 1 : length(obj.dataColumnNames)
                        d_log_temp(:, i) = dp2.getDataColumnByName(obj.dataColumnNames{i});
                    end
                catch e
                    disp(e.message)
                    disp(['Column "' obj.dataColumnNames{i} '" does not exist']);
                end
                % Step 4: find the data in plc log files that matches the same time
                %         period as the sampled Data
                
                % check if extra time padding is requested
                indsLog = (logUtcTimes >= t(1) - obj.timePadding & logUtcTimes <= t(end) + obj.timePadding);
                
            
%       PREVIOUS CODE           
%             deltaUtcTime = -100;
%             iter = 0;
% 
%             % Search for start position
%             % the correct log time is a row before the log time which is greater
%             % than the sampled data time
%             while deltaUtcTime < 0
%                 iter = iter + 1;
%                 if iter > length(logUtcTimes)
%                     % quit if no end position is found
%                     newData = NaN(2, length(obj.dataColumnNames) + 1);
%                     warning('could not find start position in log files');
%                     return;
%                 end
%                 deltaUtcTime = logUtcTimes(iter) - t(1);
%             end
%             iter = iter - 1;
%             % Check if plc time is found
%             if iter == 0
%                 warning('No matching csv file found');
%             end
%             startIter = iter;
% 
%             % Search for end position
%             deltaUtcTime = -100;
%             while deltaUtcTime < 0
%                 iter = iter + 1;
%                 if iter > length(logUtcTimes)
%                     % quit if no end position is found
%                     newData = NaN(2, length(obj.dataColumnNames) + 1);
%                     warning('could not find end position in log files');
%                     return;
%                 end
%                 deltaUtcTime = logUtcTimes(iter) - t(end);
%             end
%             iter = iter -1;
% 
%                 % Step 5: create the log output variables
% 
%                 % return plc Time and plc Data
%                 t_log = zeros([iter - startIter + 1, 1]);
%                 d_log = zeros([iter - startIter + 1, length(obj.dataColumnNames)]);
%                 if iter>0
%                 for i = startIter:iter
%                     t_log(i - startIter + 1) = logUtcTimes(i);
%                     for j = 1: length(obj.dataColumnNames)
%                         d_log(i - startIter + 1 , j) = d_log_temp(i, j);
%                     end
%                 end

                % Step 5: create the log output variables
                
                t_log = logUtcTimes(indsLog);
                d_log = d_log_temp(indsLog, :);
                
            else
                warning('No matching csv file found')
                t_log = [];
                d_log = [];
            end
            clear d_log_temp logUtcTimes
            %disp('merge finished');
            newData = [t_log, d_log];
            %d = datetime(t_log(1),'ConvertFrom','epochtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss.SSS');
            %mat = [[t newData zeros(length(t),size(dataColumnNames,1))]; [t_log zeros(length(t_log),1) d_log]];
            %sortrows(mat,1);
            %---------------------------------------------------------------
            if isempty(newData)
                disp('oops')
            end
        end
        
        function newData = requestData(obj, nSamples)
            %REQUESTDATA(obj, nSamples)
            warning(['method requestData is not implemented for ' class(SyncedSimStreamAcquisitor.empty) ', method requestAvailableData is used instead'])
            newData = obj.requestAvailableData();
        end
                
    end
end

