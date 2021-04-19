%%
clear
close all
clc

%% Setup Files to Parse
paths = DataParser.selectMultipleFilesFolders();
files = DataParser.getFilesInFolders(paths,'mat');
if isempty(files)
    files = paths;
end
%%
AE_MAT_FOLDER = 'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\5-Achser-KGT-Measurements\20210118_mess_ae_kgt_cam\Verschleissfahrt3\';
AE_MAT_FOLDER = 'C:\Users\Jan\OneDrive - student.kit.edu\Uni\HIWI\SyncedStreamAcquisitor\AE';
LOG_CSV_FOLDER = 'C:\Users\Jan\OneDrive - student.kit.edu\Uni\HIWI\SyncedStreamAcquisitor\PLC';

files = DataParser.getFilePaths(AE_MAT_FOLDER, 'mat', 'ORLL', true);
log_files = DataParser.getFilePaths(LOG_CSV_FOLDER, 'csv', 'plc', true);
%%
f_sr = 2e6;
dp = DataParser('FileType', 'mat');
rsDAQ = SimStreamAcquisitor(dp, files, f_sr / 2, f_sr / 10);

%%

syncedAcq = SyncedSimStreamAcquisitor(rsDAQ,f_sr,log_files,["SPEED [1/min]";"CURRENT [A]";"POS [mm]";"T_ORFL [C]"],["Sink Timestamp (CSV) [ms]"]);

%%

rsDAQ.addObserver(syncedAcq);
%%

%plotter = HoldOnPlotter();
%plotter2 = HoldOnPlotter();
plotter2 = MovingWindowPlotterTimeSeries();
%%
%rsDAQ.addObserver(plotter);
syncedAcq.addObserver(plotter2);

%%

while rsDAQ.dataStream.moreDataAvailable 
    
    rsDAQ.update([]);
    
%     SignalAnalysis.fftPowerSpectrum(rsDAQ.requestAvailableData(), f_sr, 'DualPlot', true, 'NewFigure', false);
%     drawnow
%     disp(['At file (' num2str(rsDAQ.dataStream.idx) '): ' rsDAQ.dataStream.fileList{rsDAQ.dataStream.idx}])
end

%%
%d = datetime(t_log(1),'ConvertFrom','epochtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss.SSS');