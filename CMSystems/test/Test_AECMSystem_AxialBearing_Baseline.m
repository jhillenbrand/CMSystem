%%
clear
close all
clc

%%
aeSystem = AEncoderMonitoringSystem();
aeSystem.AE_MAT_FOLDER = 'D:\Dokumente\01_Studium\02_Master\05_Masterarbeit\01_Masterarbeit\3_Programming\Matlab\SourceCodeThesis\Datasets\20200721_axialbearing_baselineseries7\';
aeSystem.AE_FILE_TYPE = 'mat';
aeSystem.AE_FILE_NAME_ID = 'baseline';
aeSystem.windowSize = 100e3;
% aeSystem.f_res = 10;
aeSystem.f_res = 2e6/100e3;
aeSystem.bitPrecision = 12;
aeSystem.lowPassFrequency = -1;
aeSystem.downsampleFactor = 1;
        
aeSystem.saveToFilePath = 'cmsystem_blank_save.mat';

aeSystem.initTransformers();

aeSystem.saveToFile();

%%
aeSystem.start();

%%