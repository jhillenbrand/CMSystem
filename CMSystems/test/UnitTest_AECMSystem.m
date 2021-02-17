%%
clear
close all
clc

%% Step 0 - Instantiation

%% Step 1 - Data Acquisition Setup
AE_MAT_FOLDER = 'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\5-Achser-KGT-Measurements\20210118_mess_ae_kgt_cam\Verschleissfahrt3\';
aeFiles = DataParser.getFilePaths(AE_MAT_FOLDER, 'mat', 'ORFL', true);
f_sr = 2e6;
dp = DataParser('FileType', 'mat');
rsDAQ = SimStreamAcquisitor(dp, aeFiles, f_sr / 2, f_sr / 2);

%% Step 2 - Preprocessing Setup
preprocessor = Preprocessor();
funcHandle = @(x) SignalAnalysis.correctBitHickup(x, 12, true, false);
preprocTrafo = PreprocessingTransformation(funcHandle, 'BitHickUpTrafo');
preprocessor.addTransformation();

rsDAQ.addObserver(preprocessor);

%% Step 3 - Segmentation Setup


%% Step 4 - Feature Extraction Setup
f_res = 10;
aenExtractor = AEncoderExtractor(f_sr, f_res);

% collect n samples of representative data
n = 50e6;
data = [];
while size(data, 1) < n
    data = [data; rsDAQ.requestAvailableData()];
end
aenExtractor.learn(data);



%% Step 5 - Clustering Setup


%% Step 6 - Cluster Tracking Setup


%% Final Step - Run Application


%%

while rsDAQ.dataStream.moreDataAvailable  
    SignalAnalysis.fftPowerSpectrum(rsDAQ.requestAvailableData(), f_sr, 'DualPlot', true, 'NewFigure', false);
    drawnow
    disp(['At file (' num2str(rsDAQ.dataStream.idx) '): ' rsDAQ.dataStream.fileList{rsDAQ.dataStream.idx}])
end