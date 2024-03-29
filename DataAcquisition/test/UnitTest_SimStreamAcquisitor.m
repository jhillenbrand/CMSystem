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
files = DataParser.getFilePaths(AE_MAT_FOLDER, 'mat', 'ORFL', true);

%%
f_sr = 2e6;
dp = DataParser('FileType', 'mat');
rsDAQ = SimStreamAcquisitor(dp, files, f_sr / 2, f_sr / 10);

%%

while rsDAQ.dataStream.moreDataAvailable  
    SignalAnalysis.fftPowerSpectrum(rsDAQ.requestAvailableData(), f_sr, 'DualPlot', true, 'NewFigure', false);
    drawnow
    disp(['At file (' num2str(rsDAQ.dataStream.idx) '): ' rsDAQ.dataStream.fileList{rsDAQ.dataStream.idx}])
end


%% EXAMPLE 2 - load files at once
AE_MAT_FOLDER = 'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\5-Achser-KGT-Measurements\20210118_mess_ae_kgt_cam\Verschleissfahrt3\';
files = DataParser.getFilePaths(AE_MAT_FOLDER, 'mat', 'ORFL', true);

%%
f_sr = 2e6;
dp = DataParser('FileType', 'mat');
rsDAQ = SimStreamAcquisitor(dp, files, [], []);
rsDAQ.dataStream.fileAtOnce = true;

%% Plotter

tp = TimePlotter(2e6);
rsDAQ.addObserver(tp);


%%
while rsDAQ.dataStream.moreDataAvailable  
    rsDAQ.update([])
    drawnow
    disp(['At file (' num2str(rsDAQ.dataStream.idx) '): ' rsDAQ.dataStream.fileList{rsDAQ.dataStream.idx}])
end